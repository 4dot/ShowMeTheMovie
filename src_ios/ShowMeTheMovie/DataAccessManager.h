//
//  DataAccessManager.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServer.h"

//
// Server Types
// FakeServer : getting resource file from local respsitory.
// RealServer : request and response from real server.
//
typedef enum {
    ServerTypeFakeServer = 0,
    ServerTypeRealServer,
} ServerType;

@interface DataAccessManager : NSObject

@property (nonatomic, strong, nonnull) id<IServer> server;

/**
 Get a singleton instance
 */
+ (nonnull DataAccessManager *)manager;

/**
 Fatch Item list and run the complete handler when finished process the response data from server.
 */
- (void)fetchItemListWithCompletionHandler:(nullable NSDictionary*)param completionHandler:(void(^ _Nonnull)(NSDictionary * _Nullable items, NSError * _Nullable error))handler;

/**
 Get current Server Type
 */
- (ServerType)serverType;

@end
