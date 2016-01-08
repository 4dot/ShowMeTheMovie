//
//  ItemViewCell.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemViewCell.h"

@interface ItemViewCell()

@property (nonatomic, strong, readwrite) UIImageView *posterImageView;
@property (nonatomic, strong) NSMutableArray *constraints;

@end


@implementation ItemViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        _posterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _posterImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _posterImageView.backgroundColor = [UIColor clearColor];
        _posterImageView.accessibilityIdentifier = @"posterImageView";
        [self.contentView addSubview:_posterImageView];
    }
    return self;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(contentInsets, _contentInsets))
        return;
    _contentInsets = contentInsets;
    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints
{
    if (_constraints) {
        [super updateConstraints];
        return;
    }
    
    UIView *contentView = self.contentView;
    _constraints = [NSMutableArray array];
    
    float marginHorizontal = 10.f;
    float marginVertical = 5.f;
    
    // poster image view.
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_posterImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1.f constant:marginHorizontal];
    [_constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_posterImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-marginHorizontal];
    [_constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_posterImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.f constant:marginVertical];
    [_constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_posterImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-marginVertical];
    [_constraints addObject:constraint];
    
    
    [contentView addConstraints:_constraints];
    [super updateConstraints];
}


- (void)setNeedsUpdateConstraints
{
    if (_constraints)
        [self.contentView removeConstraints:_constraints];
    _constraints = nil;
    [super setNeedsUpdateConstraints];
}

@end

