//
//  ItemBase.m
//  ShowMeTheMovie
//
//  Created by charlie park on 11/3/15.
//  Copyright © 2015 ForDot. All rights reserved.
//

#import "ItemBase.h"

@implementation ItemBase

static NSMapTable *AllItemsTable()
{
    static NSMapTable *allItems = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allItems = [NSMapTable strongToWeakObjectsMapTable];
    });
    
    return allItems;
}

+ (nonnull instancetype)itemWithDictionaryRepresentation:(NSDictionary * _Nonnull)dictionaryRepresentation
{
    NSMapTable *allItems = AllItemsTable();
    
    NSString *uniqueID = dictionaryRepresentation[@"id"];
    ItemBase *item = [allItems objectForKey:uniqueID];
    if (!item)
        item = [[self alloc] init];
    [item updateWithDictionaryRepresentation:dictionaryRepresentation];
    [allItems setObject:item forKey:uniqueID];
    
    return item;
}

#pragma mark - Public methods

- (void)updateWithDictionaryRepresentation:(NSDictionary * _Nonnull)dictionaryRepresentation
{
    self.uniqueID = dictionaryRepresentation[@"id"];
    self.oriTitle = dictionaryRepresentation[@"original_title"];
    self.title = dictionaryRepresentation[@"title"];
    self.releaseDate = dictionaryRepresentation[@"release_date"];
    self.overView = dictionaryRepresentation[@"overview"];
    self.popularity = dictionaryRepresentation[@"popularity"];
    self.video = dictionaryRepresentation[@"video"];
    self.adult = dictionaryRepresentation[@"adult"];
    self.voteAverage = dictionaryRepresentation[@"vote_average"];
    self.voteCount = dictionaryRepresentation[@"vote_count"];
    self.backdropImgURL = dictionaryRepresentation[@"backdrop_path"];
    self.posterImgURL = dictionaryRepresentation[@"poster_path"];
}

@end