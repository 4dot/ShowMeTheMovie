//
//  ItemViewCell.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "AAPLCollectionViewCell.h"

@interface ItemViewCell : AAPLCollectionViewCell

@property (nonatomic) UIEdgeInsets contentInsets;
@property (nonatomic, readonly) UIImageView *posterImageView;

@end
