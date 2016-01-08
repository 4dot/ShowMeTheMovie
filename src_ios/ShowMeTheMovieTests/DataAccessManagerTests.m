//
//
//  DataAccessManagerTests.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/9/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataAccessManager.h"
#import "FakeServer.h"
#import "ItemBase.h"

@interface DataAccessManagerTests : XCTestCase {
    DataAccessManager *_manager;
}
@end


@implementation DataAccessManagerTests

- (void)setUp {
    [super setUp];
    
    _manager = [DataAccessManager manager];

    // Set fake server
    FakeServer* fakeServer = [[FakeServer alloc] init];
    _manager.server = fakeServer;
}

- (void)testResultsWithFakeServer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"results"];
    
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:@1, @"page", nil];
    [_manager fetchItemListWithCompletionHandler:param completionHandler:^(NSDictionary * _Nullable items, NSError * _Nullable error) {
        NSArray *results = items[@"items"];
        XCTAssertEqual([results count], 6, @"Mismatch item count.");
        XCTAssert(!error, @"Error is not nil.");
        
        for(ItemBase* item in results) {
            XCTAssert([item isKindOfClass:[ItemBase class]]);
        }
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
