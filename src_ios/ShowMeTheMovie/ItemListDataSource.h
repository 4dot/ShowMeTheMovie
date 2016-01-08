//
//  ItemListDataSource.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "AAPLBasicDataSource.h"

//
// This is for TableView's DataSource
//
@interface ItemListDataSource : AAPLBasicDataSource

@property(nonatomic, readwrite) NSUInteger prevPage;
@property(nonatomic, readwrite) NSUInteger currentPage;
@property(nonatomic, readwrite) NSUInteger totalPages;
@property(nonatomic, readwrite) NSUInteger totalItemCount;

@end
