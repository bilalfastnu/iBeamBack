//
//  FeedDataModel.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedDataModel.h"

#import "FeedDataProcessor.h"

@implementation FeedDataModel

@synthesize page	= _page;

@synthesize isMoreFeedItems;
@synthesize selectedFilterType;
@synthesize filterDictionary;
///////////////////////////////////////////////////////////////////////////

-(id)init
{
    self = [super init];
	if (self) {
        
        self.page = 0;
        selectedFilterType = 0;
        isMoreFeedItems = YES;
		feedItemsDictionary = [[NSMutableDictionary alloc] init];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////

- (NSArray *)modelItems {
    
	NSSortDescriptor *feedItemSorter = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	
	NSArray *feedItemsSortedArray = [[feedItemsDictionary allValues]
                                     sortedArrayUsingDescriptors:[NSArray arrayWithObject:feedItemSorter]];
	[feedItemSorter release];
	
	return feedItemsSortedArray;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark --
#pragma mark TTModel methods

-(void)makeRequestForData
{
	FeedManager *feedManager = [FeedManager sharedFeedManager];
    feedManager.feedDataDelegate = self;
    
    if (selectedFilterType == 0) {
		
        [feedManager fetchAccountFeedForPage:self.page];
		
	}else {
		
		[feedManager fetchFeedForFilter:filterDictionary ofPageNumber:self.page];
	}
    
	done = NO;
	loading = YES;
}
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
    if (!self.isLoading) {
		if (more) {
			self.page += 1;
		} else {
			[feedItemsDictionary removeAllObjects];
			self.page = 1;
		}
        
        [self makeRequestForData]; // Implement yourself for your data
        
	} 
}

- (BOOL)isLoaded {
	return done;
}

- (BOOL)isLoading {
	return loading;
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ScrybeFeedDataModelDelegate Delegate methods

- (void)scrybeFeedDataDidFinishProcessing:(FeedManager *)feedManager
{
    done = YES;
	loading = NO;
    
    int count = [[[FeedManager sharedFeedManager] feedItems] count];
    
    if (count == 0) {
        isMoreFeedItems = NO;
    }
    
    [feedItemsDictionary addEntriesFromDictionary:[[FeedManager sharedFeedManager] feedItems]];
    
    [self didFinishLoad];
}
- (void)scrybeFeedDataProcessing:(FeedManager *)feedManager didFailWithError:(NSError *)error
{
    done = YES;
	loading = NO;
	
	[self didFailLoadWithError:error];
}


@end
