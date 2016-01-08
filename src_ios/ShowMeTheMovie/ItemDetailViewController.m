//
//  ItemDetailViewController.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "AAPLCollectionViewGridLayout.h"
#import "ItemListDataSource.h"
#import "ItemDetailHeaderView.h"
#import "ItemBase.h"


@interface ItemDetailViewController ()
@property (nonatomic, strong) ItemListDataSource *itemsDataSource;
@end


@implementation ItemDetailViewController

- (instancetype)initWithDefaultCollectionViewGridLayout
{
    AAPLCollectionViewGridLayout* gridLayout = [[AAPLCollectionViewGridLayout alloc] init];
    self = [super initWithCollectionViewLayout:gridLayout];
    if(self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Data sources
    ItemListDataSource* dataSource = [self newItemListDataSource];
    
    self.itemsDataSource = dataSource;
    self.collectionView.dataSource = self.itemsDataSource;
    
    __weak __typeof(self)weakself = self;
    
    AAPLLayoutSupplementaryMetrics *globalHeader = [self.itemsDataSource newHeaderForKey:@"globalHeader"];
    globalHeader.visibleWhileShowingPlaceholder = YES;
    globalHeader.height = self.view.frame.size.height;
    globalHeader.supplementaryViewClass = [ItemDetailHeaderView class];
    globalHeader.configureView = ^(UICollectionReusableView *view, AAPLDataSource *dataSource, NSIndexPath *indexPath) {
        ItemDetailHeaderView *headerView = (ItemDetailHeaderView *)view;
        [headerView configureWithItem:weakself.item];
        self.title = weakself.item.title;
    };
}

- (ItemListDataSource *)newItemListDataSource
{
    ItemListDataSource *dataSource = [[ItemListDataSource alloc] init];
    dataSource.title = NSLocalizedString(@"Movie Name", @"Title for available items list");
    dataSource.noContentMessage = NSLocalizedString(@"Please try again later.", @"The message to show when no items are available");
    dataSource.noContentTitle = NSLocalizedString(@"No Items", @"The title to show when no items are available");
    dataSource.errorMessage = NSLocalizedString(@"A problem with the network prevented loading the available items.\nPlease, check your network settings.", @"Message to show when unable to load items");
    dataSource.errorTitle = NSLocalizedString(@"Unable To Load Items", @"Title of message to show when unable to load items");
    
    return dataSource;
}

@end
