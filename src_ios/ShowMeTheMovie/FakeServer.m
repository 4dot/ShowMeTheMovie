//
//  FakeServer.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "FakeServer.h"
#import "NetResponse.h"

static NSString *const kLocalDataFile = @"itemList";

static NSMapTable *AllItemsTable()
{
    static NSMapTable *allItems = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allItems = [NSMapTable strongToWeakObjectsMapTable];
    });
    
    return allItems;
}


@implementation FakeServer

- (void)contentItems:(nullable NSDictionary*)param completionHandler:(void(^ _Nonnull)(NetResponse* _Nullable response, NSError* _Nullable error))handler
{
    int page = [param[@"page"] intValue];
    page = (page > 0) ? page : 1;
    [self fetchJSONResourceWithName:[NSString stringWithFormat:@"%@-%d", kLocalDataFile, page] completionHandler:^(NSDictionary *json, NSError *error) {
        if (error) {
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, error);
                });
            }
            return;
        }
        
        NSArray *results = json[@"results"];
        NSAssert([results isKindOfClass:[NSArray class]], @"results property should be an array of items");
        
        NSMapTable *allItems = AllItemsTable();
        
        // Save all items
        for(NSDictionary* itemDictionaryInfo in results) {
            id uniqueID = itemDictionaryInfo[@"id"];
            if (!uniqueID)
                continue;
            
            NSDictionary *item = [allItems objectForKey:uniqueID];
            if (!item)
                item = itemDictionaryInfo;
            [allItems setObject:item forKey:uniqueID];
        }
        
        NetResponse *response = [[NetResponse alloc] init];
        response.payload = json;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(response, nil);
        });
    }];
}


#pragma mark - Private methods

- (void)fetchJSONResourceWithName:(NSString *)name completionHandler:(void(^)(NSDictionary *json, NSError *error))handler
{
    NSParameterAssert(handler != nil);
    
    NSError *error;
    
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"json"];
    if (!resourceURL) {
        // Should create an NSError and pass it to the completion handler
        //NSAssert(NO, @"Could not find resource: %@", name);
        NSLog(@"Could not find resource: %@", name);
        return;
    }
    
    // Fetch the json data. If there's an error, call the handler and return.
    NSData *jsonData = [NSData dataWithContentsOfURL:resourceURL options:NSDataReadingMappedIfSafe error:&error];
    if (!jsonData) {
        handler(nil, error);
        return;
    }
    
    // Parse the json data. If there's an error parsing the json data, call the handler and return.
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (!json) {
        handler(nil, error);
        return;
    }
    
    // If the json data specified that we should delay the results, do so before calling the handler
    NSNumber *delayResults = json[@"delayResults"];
    if (delayResults && [delayResults isKindOfClass:[NSNumber class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([delayResults floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            handler(json, nil);
        });
    }
    else {
        handler(json, nil);
    }
}

@end