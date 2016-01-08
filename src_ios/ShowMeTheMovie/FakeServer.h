//
//  FakeServer.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "IServer.h"

//
// Using local resource
//
@interface FakeServer : NSObject <IServer>

@property (nonatomic, strong) NSString *localDataFileName;  // This is a local json data file

@end
