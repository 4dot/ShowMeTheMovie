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

+ (nonnull instancetype)itemWithDictionaryRepresentation:(NSDictionary * _Nonnull) dictionaryRepresentation
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

- (void)updateWithDictionaryRepresentation:(NSDictionary * _Nonnull) dictionaryRepresentation
{
    _uniqueID = dictionaryRepresentation[@"id"];
    _oriTitle = dictionaryRepresentation[@"original_title"];
    _title = dictionaryRepresentation[@"title"];
    _releaseDate = dictionaryRepresentation[@"release_date"];
    _overView = dictionaryRepresentation[@"overview"];
    _popularity = dictionaryRepresentation[@"popularity"];
    _video = dictionaryRepresentation[@"video"];
    _adult = dictionaryRepresentation[@"adult"];
    _voteAverage = dictionaryRepresentation[@"vote_average"];
    _voteCount = dictionaryRepresentation[@"vote_count"];
    _backdropImgURL = dictionaryRepresentation[@"backdrop_path"];
    _posterImgURL = dictionaryRepresentation[@"poster_path"];
}

@end
