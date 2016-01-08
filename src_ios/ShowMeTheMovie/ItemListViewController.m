//
//  ItemListViewController.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemListViewController.h"
#import "ItemListDataSource.h"
#import "ItemDetailViewController.h"
#import "AAPLCollectionViewGridLayout.h"
#import "ItemViewCell.h"

@interface ItemListViewController ()

@property (nonatomic, strong) ItemListDataSource *itemsDataSource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end


@implementation ItemListViewController


- (instancetype)init
{
    UICollectionViewFlowLayout *gridLayout = [[UICollectionViewFlowLayout alloc] init];
    gridLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    gridLayout.minimumInteritemSpacing = 0.f;
    gridLayout.minimumLineSpacing = 0.f;
    self = [super initWithCollectionViewLayout:gridLayout];
    if(!self) return nil;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // add user button on the navigation bar
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = userButton;
    
    // Data sources
    ItemListDataSource* dataSource = [self newItemListDataSource];
    
    AAPLLayoutSectionMetrics *metrics = dataSource.defaultMetrics;
    metrics.rowHeight = AAPLRowHeightVariable;
    metrics.separatorColor = [UIColor lightGrayColor];
    metrics.separatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.itemsDataSource = dataSource;
    self.collectionView.dataSource = self.itemsDataSource;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.title = dataSource.title;
    
    if ([dataSource isKindOfClass:[AAPLDataSource class]]) {
        
        // First data loading
        [dataSource setNeedsLoadContent];
    }
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Private methods

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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = self.collectionView.frame.size;
    return CGSizeMake(itemSize.width/2, (itemSize.width/2) * 1.5);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemListDataSource *dataSource = (ItemListDataSource *)self.collectionView.dataSource;
    
    if (dataSource.currentPage != dataSource.totalPages && dataSource.prevPage == dataSource.currentPage && indexPath.row == dataSource.items.count - 1 ) {
        
        // Request next page
        [dataSource setNeedsLoadContent];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDetailViewController *itemDetailViewController = [[ItemDetailViewController alloc] initWithDefaultCollectionViewGridLayout];
    itemDetailViewController.item = [self.itemsDataSource itemAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:itemDetailViewController animated:YES];
}

@end
