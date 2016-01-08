//
//  ItemDetailHeaderView.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "AAPLPinnableHeaderView.h"

@class ItemBase;


@interface ItemDetailHeaderView : AAPLPinnableHeaderView

- (void)configureWithItem:(ItemBase *)item;

@end
