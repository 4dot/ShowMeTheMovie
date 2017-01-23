//
//  ItemListDataSource.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemListDataSource.h"
#import "DataAccessManager.h"
#import "ItemBase.h"
#import "UICollectionView+Helpers.h"
#import "ItemViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@implementation ItemListDataSource

- (void)loadContent
{
    [self loadContentWithBlock:^(AAPLLoading *loading) {
        void (^handler)(NSDictionary *itemData, NSError *error) = ^(NSDictionary *itemData, NSError *error) {
            
            // Check to make certain a more recent call to load content hasn't superceded this one…
            if (!loading.current) {
                [loading ignore];
                return;
            }
            
            if (error) {
                [loading doneWithError:error];
                return;
            }
            
            if (itemData.count)
                [loading updateWithContent:^(ItemListDataSource *me) {
                    NSMutableArray *arrItems = [NSMutableArray arrayWithArray:me.items];
                    [arrItems addObjectsFromArray:itemData[@"items"]];
                    me.items = nil;
                    me.items = [arrItems copy];
                    me.currentPage = [itemData[@"currentPage"] integerValue];
                    me.totalPages = [itemData[@"totalPages"] integerValue];
                    me.totalItemCount = [itemData[@"totalResults"] integerValue];
                    
                    me.prevPage = me.currentPage;
                }];
            else
                [loading updateWithNoContent:^(ItemListDataSource *me) {
                    me.items = @[];
                }];
        };
        
        self.prevPage = self.currentPage++;
        [[DataAccessManager manager] fetchItemListWithCompletionHandler:@{
                                                                            @"page" : [NSNumber numberWithInteger:self.currentPage]
                                                                          }
                                                      completionHandler:handler];
    }];
}



#pragma mark - UICollectionViewDataSource methods

- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView
{
    [super registerReusableViewsWithCollectionView:collectionView];
    [collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ItemViewCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.currentPage == self.totalPages) {
        return self.totalItemCount;
    }
    return self.items.count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ItemViewCell class]) forIndexPath:indexPath];
    cell.posterImageView.contentMode = UIViewContentModeScaleToFill;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.posterImageView.layer.cornerRadius = 7;
    cell.posterImageView.layer.masksToBounds = true;
    
    ItemBase* node = [self itemAtIndexPath:indexPath];

    // Check Server Type
    if([[DataAccessManager manager] serverType] == ServerTypeRealServer) {
        
        // Real Server, Using the SDWebImage library
        [cell.posterImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w342%@", node.posterImgURL]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else {
        // Fake server
        cell.posterImageView.image = [UIImage imageNamed:node.posterImgURL];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeFittingSize:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    CGSize fittingSize = [cell aapl_preferredLayoutSizeFittingSize:size];
    [cell removeFromSuperview];
    
    return fittingSize;
}

@end
