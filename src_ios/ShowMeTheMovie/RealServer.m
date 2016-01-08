//
//  RealServer.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "RealServer.h"
#import "NetResponse.h"

#warning Please type your API key.
static NSString *const kAPIKey = @"abcdefghijklmnopqurstuvwxyz";


static NSMapTable *AllItemsTable()
{
    static NSMapTable *allItems = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allItems = [NSMapTable strongToWeakObjectsMapTable];
    });
    
    return allItems;
}

@implementation RealServer

- (void)contentItems:(nullable NSDictionary*)param completionHandler:(void(^ _Nonnull)(NetResponse* _Nullable response, NSError* _Nullable error))handler
{
    int page = [param[@"page"] intValue];
    page = (page > 0) ? page : 1;
    
    NSString *apiURL = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/now_playing?api_key=%@&page=%d", kAPIKey, page];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:apiURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               // handle response
                               if (!error) {
                                   
                                   [self fetchJSONResourceWithData:data completionHandler:^(NSDictionary *json, NSError *error) {
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
                                       response.payload = [NSDictionary dictionaryWithDictionary:json];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           handler(response, nil);
                                       });
                                   }];
                               } // end if
                           }];
                
}

#pragma mark - Private methods

- (void)fetchJSONResourceWithData:(NSData * _Nullable)data completionHandler:(void(^)(NSDictionary *json, NSError *error))handler
{
    NSParameterAssert(handler != nil);
    
    NSError *error;
    
    // Parse the json data. If there's an error parsing the json data, call the handler and return.
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!json) {
        handler(nil, error);
        return;
    }
    
    NSLog(@"%@",json);
    
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
