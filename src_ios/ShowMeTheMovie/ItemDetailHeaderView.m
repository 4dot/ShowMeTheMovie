//
//  ItemDetailHeaderView.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemDetailHeaderView.h"
#import "ItemBase.h"
#import "DataAccessManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ItemDetailHeaderView()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *rating;
@property (nonatomic, strong) UILabel *releaseDateLabel;
@property (nonatomic, strong) UILabel *releaseDate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *overviewLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation ItemDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    UIFont *fontName = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    UIFont *fontInfo = [UIFont fontWithName:@"HelveticaNeue" size:26];
    UIFont *fontTitle = [UIFont fontWithName:@"HelveticaNeue" size:36];
    UIFont *fontOverview = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    // background image
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    _backgroundImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backgroundImageView];
    
    // poster image offset, top:20 left:20, size:half of width
    _posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, frame.size.width/2 - 40, (frame.size.width/2) * 1.5 - 40)];
    _posterImageView.contentMode = UIViewContentModeScaleToFill;
    _posterImageView.layer.cornerRadius = 7;
    _posterImageView.layer.masksToBounds = YES;
    _posterImageView.clipsToBounds = YES;
    [self addSubview:_posterImageView];
    
    _scoreLabel = [self createInformationLabel:fontName accessbilityId:@"scoreLabel"];
    _scoreLabel.text = @"Score:";
    [self addSubview:_scoreLabel];
    
    _score = [self createInformationLabel:fontInfo accessbilityId:@"score"];
    [self addSubview:_score];
    
    _ratingLabel = [self createInformationLabel:fontName accessbilityId:@"ratingLabel"];
    _ratingLabel.text = @"Rating:";
    [self addSubview:_ratingLabel];
    
    _rating = [self createInformationLabel:fontInfo accessbilityId:@"rating"];
    [self addSubview:_rating];
    
    _releaseDateLabel = [self createInformationLabel:fontName accessbilityId:@"releaseDateLabel"];
    _releaseDateLabel.text = @"Release Date:";
    [self addSubview:_releaseDateLabel];
    
    _releaseDate = [self createInformationLabel:fontInfo accessbilityId:@"releaseDate"];
    [self addSubview:_releaseDate];
    
    _titleLabel = [self createInformationLabel:fontTitle accessbilityId:@"titleLabel"];
    [self addSubview:_titleLabel];
    
    _overviewLabel = [self createInformationLabel:fontOverview accessbilityId:@"overviewLabel"];
    [_overviewLabel sizeToFit];
    [self addSubview:_overviewLabel];
    
    // separate lines
    _topLine = [[UIView alloc] initWithFrame:CGRectZero];
    _topLine.translatesAutoresizingMaskIntoConstraints = NO;
    _topLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2];
    [self addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.2];
    [self addSubview:_bottomLine];
    
    [self setItemDetailHeaderConstraints];
    
    return self;
}

#pragma mark - Private method

- (UILabel *)createInformationLabel:(UIFont *)font accessbilityId:(NSString *)accessbilityId
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.accessibilityIdentifier = accessbilityId;
    
    return label;
}

- (void)setItemDetailHeaderConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_backgroundImageView, _posterImageView, _scoreLabel, _score, _ratingLabel, _rating, _releaseDateLabel, _releaseDate, _titleLabel, _overviewLabel, _topLine, _bottomLine);
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *metrics = @{
                              // 44:font height = font size:18 + font size 26
                              // 15:font gap between label and info * 3
                              @"rightInfoTopMargin" : @(((_posterImageView.frame.size.height+20)-(44*3+15))/4),
                              };
    
    // scoreLabel, score
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_scoreLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_score]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-rightInfoTopMargin-[_scoreLabel]-5-[_score]" options:0 metrics:metrics views:views]];
    
    // ratingLabel, rating
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_ratingLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_rating]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_score]-rightInfoTopMargin-[_ratingLabel]-5-[_rating]" options:0 metrics:metrics views:views]];
    
    // releaseDateLabel, releaseDate
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_releaseDateLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_releaseDate]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rating]-rightInfoTopMargin-[_releaseDateLabel]-5-[_releaseDate]" options:0 metrics:metrics views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_releaseDateLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_posterImageView]-20-[_releaseDate]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rating]-rightInfoTopMargin-[_releaseDateLabel]-5-[_releaseDate]" options:0 metrics:metrics views:views]];
    
    // titleLabel, overviewLabel
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLabel]-20-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_overviewLabel]-20-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_posterImageView]-20-[_titleLabel]-20-[_topLine(==1)]-20-[_overviewLabel]-20-[_bottomLine(==1)]" options:0 metrics:nil views:views]];
    
    // top, bottom line
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_topLine]-0-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_bottomLine]-0-|" options:0 metrics:nil views:views]];
    
    
    [self addConstraints:constraints];
}

- (void)configureWithItem:(ItemBase *)item
{
    // check validate
    if(item.voteAverage != (id)[NSNull null])
        _score.text = [NSString stringWithFormat:@"%.1f", [item.voteAverage floatValue]];
    
    if(item.adult != (id)[NSNull null])
        _rating.text = ([item.adult integerValue] == 0) ? @"R" : @"X";
    
    // set date
    if(item.releaseDate != (id)[NSNull null]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:item.releaseDate];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        _releaseDate.text = [formatter stringFromDate:date];
    }
    if(item.title != (id)[NSNull null])
        _titleLabel.text = item.title;
    if(item.overView != (id)[NSNull null])
        self.overviewLabel.text = item.overView;
    
    // Check Server Type
    if([[DataAccessManager manager] serverType] == ServerTypeRealServer) {

        // Real Server
        // Set poster Image and background image
        // request image from SDWebImage
        __weak __typeof(self)weakself = self;
        [self.posterImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w342%@", item.posterImgURL]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                                      options:0
                                     progress:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                        // set backgound blur
                                        weakself.backgroundImageView.image = image;
                                        
                                        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                                        
                                        // add effect to an effect view
                                        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
                                        effectView.frame = weakself.frame;
                                        [weakself.backgroundImageView addSubview:effectView];
                                    }
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    else {
        // Fake Server
        UIImage *image = [UIImage imageNamed:item.posterImgURL];
        if(!image) {
            [UIImage imageNamed:@"placeholder.jpg"];
        }
        self.posterImageView.image = image;
        self.backgroundImageView.image = image;
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // add effect to an effect view
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = self.frame;
        [self.backgroundImageView addSubview:effectView];

    }
}

@end
