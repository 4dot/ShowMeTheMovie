//
//
//  ItemListDataSourceTests.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/9/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataAccessManager.h"
#import "FakeServer.h"
#import "ItemListDataSource.h"
#import "ItemBase.h"

@interface ItemListDataSourceTests : XCTestCase
@end


@implementation ItemListDataSourceTests

- (void)setUp {
    [super setUp];

    DataAccessManager *manager = [DataAccessManager manager];

    // Set fake server
    FakeServer* fakeServer = [[FakeServer alloc] init];
    manager.server = fakeServer;
}

- (void)testItemListDataSourceWithResults {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Data source."];

    // Test data source
    ItemListDataSource *dataSource = [self newItemListDataSource];
    [dataSource whenLoaded:^{
        XCTAssertEqual([dataSource.items count], 6, @"Mistmatch item count.");
        for(ItemBase* item in dataSource.items) {
            XCTAssert([item isKindOfClass:[ItemBase class]]);
        }

        [expectation fulfill];
    }];
    [dataSource setNeedsLoadContent];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


#pragma mark - Private methods.

- (ItemListDataSource *)newItemListDataSource
{
    ItemListDataSource *dataSource = [[ItemListDataSource alloc] init];
    
    dataSource.title = NSLocalizedString(@"Latest Movies", @"Title for available items list");
    dataSource.noContentMessage = NSLocalizedString(@"Please try again later.", @"The message to show when no items are available");
    dataSource.noContentTitle = NSLocalizedString(@"No Items", @"The title to show when no items are available");
    dataSource.errorMessage = NSLocalizedString(@"A problem with the network prevented loading the available items.\nPlease, check your network settings.", @"Message to show when unable to load items");
    dataSource.errorTitle = NSLocalizedString(@"Unable To Load Items", @"Title of message to show when unable to load items");
    
    return dataSource;
}

@end
