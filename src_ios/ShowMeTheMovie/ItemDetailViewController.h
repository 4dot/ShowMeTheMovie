//
//  ItemDetailViewController.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "AAPLCollectionViewController.h"

@class ItemBase;


@interface ItemDetailViewController : AAPLCollectionViewController

@property (nonatomic, strong) ItemBase *item;

- (instancetype)initWithDefaultCollectionViewGridLayout;

@end


