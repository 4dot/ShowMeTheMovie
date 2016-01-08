//
//  IServer.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetResponse;

/**
 Interface class
 */

@protocol IServer <NSObject>

- (void)contentItems:(nullable NSDictionary*)param completionHandler:(void(^ _Nonnull)(NetResponse* _Nullable response, NSError* _Nullable error))handler;

@end
