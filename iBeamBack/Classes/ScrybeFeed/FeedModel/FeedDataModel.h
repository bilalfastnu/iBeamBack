//
//  FeedDataModel.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

#import "FeedManager.h"

@class FeedDataProcessor;

@interface FeedDataModel : TTURLRequestModel<ScrybeFeedDataModelDelegate> {
   
    BOOL done;
	BOOL loading;
	
    BOOL isMoreFeedItems;
   
    NSInteger	_page;
    NSInteger selectedFilterType;
    NSDictionary *filterDictionary;
    FeedDataProcessor *feedDataProcessor;
    NSMutableDictionary *feedItemsDictionary;
}

@property (nonatomic, assign) NSInteger	page;
@property (nonatomic, assign) BOOL isMoreFeedItems;
@property (nonatomic, assign) NSInteger selectedFilterType;
@property (nonatomic, retain) NSDictionary *filterDictionary;

- (NSArray *)modelItems;

@end
