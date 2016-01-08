//
//  DataCacheManager.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/4/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "DataCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#endif

static NSString *const SharedCacheName = @"SharedCache";

@interface DataCacheManager ()
{
    NSCache *_memCache;
    dispatch_queue_t _diskQueue;
}

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *basePath;

@property (nonatomic, strong) NSString *diskPath;

@end

@implementation DataCacheManager

+ (DataCacheManager *)manager
{
    static DataCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        manager = [[DataCacheManager alloc] initWithName:SharedCacheName];
    });
    
    return manager;
}

- (instancetype)initWithName:(NSString *)name
{
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    return [self initWithName:name basePath:cachesDirectory];
}

- (instancetype)initWithName:(NSString *)name basePath:(NSString *)basePath
{
    self = [super init];
    if (self) {
        self.name = name;
        self.basePath = basePath;
        
        NSString *namespace = [@"com.Fordot.DataCacheManager" stringByAppendingPathComponent:self.name];
        
        self.diskPath = [basePath stringByAppendingPathComponent:namespace];
        
        _memCache = [[NSCache alloc] init];
        _memCache.name = namespace;
        
        _diskQueue = dispatch_queue_create("com.Fordot.DataCacheManager.diskQueue", DISPATCH_QUEUE_CONCURRENT); // Using barrier blocks for write tasks
        
        [self addObservers];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public methods

- (void)setObject:(id)object forKey:(NSString *)key
{
    if (key == nil || object == nil) {
        return;
    }
    
    NSUInteger cost = [self cacheCostForObject:object fromData:nil];
    [_memCache setObject:object forKey:key cost:cost];
    
    [self _storeDiskCacheObject:object forKey:key];
}

- (id)objectForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    __block id object = [_memCache objectForKey:key];
    if (object) {
        return object;
    }
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    dispatch_async(_diskQueue, ^{
        
        NSData *data = [NSData dataWithContentsOfFile:[self _getDiskCachePathForKey:key]];
        if (data)
        {
            object = [self objectWithData:data];
        }
        
        if (object)
        {
            NSUInteger cost = [self cacheCostForObject:object fromData:data];
            [_memCache setObject:object forKey:key cost:cost];
        }
        else
        {
            [self removeObjectForKey:key];
        }
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    return object;
}

- (void)objectForKey:(NSString *)key completionHandler:(void (^)(id object))completionHandler
{
    if (key == nil) {
        if (completionHandler)
            completionHandler(nil);
        
        return;
    }
    
    id object = [_memCache objectForKey:key];
    if (object) {
        if (completionHandler)
            completionHandler(object);
        
        return;
    }
    
    dispatch_async(_diskQueue, ^{
        
        id object = nil;
        
        NSData *data = [NSData dataWithContentsOfFile:[self _getDiskCachePathForKey:key]];
        if (data) {
            object = [self objectWithData:data];
        }
        
        if (object) {
            NSUInteger cost = [self cacheCostForObject:object fromData:data];
            [_memCache setObject:object forKey:key cost:cost];
        }
        
        if (completionHandler)
            completionHandler(object);
    });
}

- (void)removeObjectForKey:(NSString *)key
{
    [_memCache removeObjectForKey:key];
    
    [self _deleteDiskCacheForKey:key];
}

- (void)removeAllObjects
{
    [self clearMemory];
    [self clearDisk];
}

- (void)clearMemory
{
    [_memCache removeAllObjects];
}

- (void)clearDisk
{
    dispatch_barrier_async(_diskQueue, ^{
        
        // Create new file manager for this thread
        NSFileManager *fileManager = [NSFileManager new];
        [fileManager removeItemAtPath:self.diskPath error:nil];
        [fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:NULL];
        
    });
}

#pragma mark - Private methods

- (void)_storeDiskCacheObject:(id)object forKey:(NSString *)key
{
    // Create data from object immediately, we don't want to do this async. (object may be mutated while waiting in queue)
    NSData *data = [self dataWithObject:object];
    if (data) {
        dispatch_barrier_async(_diskQueue, ^{
            
            // Create new file manager for this thread
            NSFileManager *fileManager = [NSFileManager new];
            if (![fileManager fileExistsAtPath:self.diskPath]) {
                [fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            BOOL success = [fileManager createFileAtPath:[self _getDiskCachePathForKey:key] contents:data attributes:nil];
            if (success == NO) {
                NSLog(@"Unable to store object to disk cache.");
            }
        });
    }
}

- (void)_deleteDiskCacheForKey:(NSString *)key
{
    NSString *cacheFilePath = [self _getDiskCachePathForKey:key];
    
    dispatch_barrier_async(_diskQueue, ^{
        
        // Create new file manager for this thread
        NSFileManager *fileManager = [NSFileManager new];
        if ([fileManager fileExistsAtPath:cacheFilePath]) {
            NSError *error = nil;
            BOOL success = [fileManager removeItemAtPath:cacheFilePath error:&error];
            if (success == NO) {
                NSLog(@"Unable to remove object from disk cache.");
            }
        }
        
    });
}

- (NSString *)_getDiskCachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [self.diskPath stringByAppendingPathComponent:filename];
}

#pragma mark - Overridable methods

- (NSData *)dataWithObject:(id)object
{
    if ([object respondsToSelector:@selector(encodeWithCoder:)]) {
        return [NSKeyedArchiver archivedDataWithRootObject:object];
    }
    
    return nil;
}

- (id)objectWithData:(NSData *)data
{
    id object = nil;
    
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"VIMCache:objectWithData: Exception: %@", exception);
    }
    
    return object;
}

- (NSUInteger)cacheCostForObject:(id)object fromData:(NSData *)data
{
    if (data) {
        return [data length];
    }
    
    return 1;
}

#pragma mark - NSCache

- (void)setCountLimit:(NSUInteger)countLimit
{
    [_memCache setCountLimit:countLimit];
}

- (NSUInteger)countLimit
{
    return [_memCache countLimit];
}

#pragma mark - Notifications

- (void)addObservers
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
#endif
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
    NSLog(@"DataCacheManager: applicationDidReceiveMemoryWarning");
    
    [self clearMemory];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self clearMemory];
}

@end
