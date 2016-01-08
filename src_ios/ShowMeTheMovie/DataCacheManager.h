//
//  DataCacheManager.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/4/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// Data Cache Manager
// Using hashed disk memory and NSCashe Object
//
typedef void(^CacheCompletionHandler)(__nullable id object);

@interface DataCacheManager : NSObject

@property(nonatomic, copy, readonly, nonnull) NSString *name;
@property(nonatomic, copy, readonly, nonnull) NSString *basePath;

@property (nonatomic, assign) NSUInteger memoryCapacity;

/**
 Get a singelton instance
 */
+ (nonnull DataCacheManager *)manager;

- (nullable instancetype)initWithName:(nonnull NSString *)name;
- (nullable instancetype)initWithName:(nonnull NSString *)name basePath:(nonnull NSString *)basePath;

- (nullable id)objectForKey:(nonnull NSString *)key;

- (void)objectForKey:(nonnull NSString *)key completionHandler:(nonnull CacheCompletionHandler)completionHandler;

- (void)setObject:(nonnull id)object forKey:(nonnull NSString *)key;

- (void)removeObjectForKey:(nonnull NSString *)key;

- (void)removeAllObjects;
- (void)clearMemory;

- (void)setCountLimit:(NSUInteger)countLimit;
- (NSUInteger)countLimit;

@end

@interface DataCacheManager (Subclass)

- (nullable NSData *)dataWithObject:(nonnull id)object;
- (nullable id)objectWithData:(nonnull NSData *)data;
- (NSUInteger)cacheCostForObject:(nonnull id)object fromData:(nullable NSData *)data;

@end
