//
//
//  FakeServerTests.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/9/15.
//  Copyright © 2015 ForDot. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "FakeServer.h"
#import "NetResponse.h"

@interface FakeServerTests : XCTestCase
{
    FakeServer* _fakeServer;
}
@end


@implementation FakeServerTests

- (void)setUp {
    [super setUp];

    _fakeServer = [[FakeServer alloc] init];
}

- (void)testResultWithFakeServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test results."];

    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:@1, @"page", nil];
    [_fakeServer contentItems:param completionHandler:^(NetResponse* _Nullable response, NSError* _Nullable error) {
        XCTAssert([response isKindOfClass:[NetResponse class]]);
        XCTAssertNil(error, @"Error is not nil.");
        
        NSArray *items = response.payload[@"results"];
        XCTAssert([items isKindOfClass:[NSArray class]]);
        XCTAssertEqual([items count], 6);
        
        for(NSDictionary* itemDictionaryInfo in items) {
            XCTAssert([itemDictionaryInfo isKindOfClass:[NSDictionary class]]);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end



