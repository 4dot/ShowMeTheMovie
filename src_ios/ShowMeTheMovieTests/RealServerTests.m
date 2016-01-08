//
//
//  RealServerTests.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/9/15.
//  Copyright © 2015 ForDot. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "RealServer.h"
#import "NetResponse.h"

@interface RealServerTests : XCTestCase
{
    RealServer* _RealServer;
}
@end


@implementation RealServerTests

- (void)setUp {
    [super setUp];

    _RealServer = [[RealServer alloc] init];
}

- (void)testResultWithRealServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test results."];

    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:@1, @"page", nil];
    [_RealServer contentItems:param completionHandler:^(NetResponse* _Nullable response, NSError* _Nullable error) {
        XCTAssert([response isKindOfClass:[NetResponse class]]);
        XCTAssertNil(error, @"Error is not nil.");
        
        NSArray *items = response.payload[@"results"];
        XCTAssert([items isKindOfClass:[NSArray class]]);
        XCTAssertEqual([items count], 20);
        
        for(NSDictionary* itemDictionaryInfo in items) {
            XCTAssert([itemDictionaryInfo isKindOfClass:[NSDictionary class]]);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end



