//
//  ItemBase.h
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemBase : NSObject

@property (nonatomic, strong, nonnull) NSString *uniqueID;
@property (nonatomic, strong, nullable) NSString *oriLanguage;
@property (nonatomic, strong, nullable) NSString *oriTitle;
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *releaseDate;
@property (nonatomic, strong, nullable) NSString *overView;
@property (nonatomic, strong, nullable) NSArray *genreIds;
@property (nonatomic, strong, nullable) NSString *popularity;
@property (nonatomic, strong, nullable) NSString *video;
@property (nonatomic, strong, nullable) NSString *adult;
@property (nonatomic, strong, nullable) NSString *voteAverage;
@property (nonatomic, strong, nullable) NSString *voteCount;
@property (nonatomic, strong, nullable) NSString *backdropImgURL;
@property (nonatomic, strong, nullable) NSString *posterImgURL;

- (void)updateWithDictionaryRepresentation:(NSDictionary * _Nonnull)dictionaryRepresentation;

// Create Item
+ (nonnull instancetype)itemWithDictionaryRepresentation:(NSDictionary * _Nonnull)dictionaryRepresentation;

@end
