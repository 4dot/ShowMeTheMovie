//
//  DataAccessManager.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "DataAccessManager.h"
#import "NetResponse.h"
#import "ItemBase.h"
#import "RealServer.h"

@interface DataAccessManager ()

@end


@implementation DataAccessManager

// Singelton
+ (DataAccessManager *)manager
{
    static DataAccessManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        manager = [[DataAccessManager alloc] init];
    });
    
    return manager;
}

// Fetch Datas
- (void)fetchItemListWithCompletionHandler:(nullable NSDictionary*)param completionHandler:(void(^ _Nonnull)(NSDictionary * _Nullable items, NSError * _Nullable error))handler
{
    if(!self.server) {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"_server must be set.", @"_server must be set.") code:0 userInfo:nil];
        handler(nil, error);
        return;
    }
    
    [self.server contentItems:param completionHandler:^(NetResponse * _Nullable response, NSError * _Nullable error) {
        if(error || !response.payload) {
            handler(nil, error);
        }
        else {
            NSMutableArray *itemsOut = [NSMutableArray array];
            NSArray *items = response.payload[@"results"];
            
            for(NSDictionary* itemDictionaryInfo in items) {
                if(![itemDictionaryInfo isKindOfClass:[NSDictionary class]])
                    continue;
                
                ItemBase *node = [ItemBase itemWithDictionaryRepresentation:itemDictionaryInfo];
                if (!node)
                    continue;
                
                [itemsOut addObject:node];
            }
            
            NSUInteger currentPage = [response.payload[@"page"] integerValue];
            NSUInteger totalPages = [response.payload[@"total_pages"] integerValue];
            NSUInteger totalResults = [response.payload[@"total_results"] integerValue];
            
            NSDictionary *itemData = @{
                                       @"items" : itemsOut,
                                       @"currentPage" : [NSNumber numberWithInteger:currentPage],
                                       @"totalPages" : [NSNumber numberWithInteger:totalPages],
                                       @"totalResults" : [NSNumber numberWithInteger:totalResults],
                                       };
            handler(itemData, nil);
        }
    }];
}

- (ServerType)serverType
{
    return ([self.server isKindOfClass:[RealServer class]]) ? ServerTypeRealServer : ServerTypeFakeServer;
}

@end
