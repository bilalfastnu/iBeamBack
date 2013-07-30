//
//  FeedDataSource.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedDataSource.h"

#import "FeedDataModel.h"

#pragma mark -
#pragma mark Feed View Cell Files

#import "NoteFeedItemCell.h"
#import "WebLinkFeedItemCell.h"
#import "MessageFeedItemCell.h"
#import "MilestoneFeedItemCell.h"

#pragma mark -
#pragma mark Feed Model Files

#import "Note.h"
#import "WebLink.h"
#import "Message.h"
#import "Milestone.h"


@implementation FeedDataSource

static int count = 0;
static FeedDataSource* _sharedFeedDataSource = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
+(FeedDataSource*)sharedFeedDataSource
{
	@synchronized([FeedDataSource class])
	{
		if (!_sharedFeedDataSource)
			[[self alloc] init];
		
		return _sharedFeedDataSource;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([FeedDataSource class])
	{
		NSAssert(_sharedFeedDataSource == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedFeedDataSource = [super alloc];
		return _sharedFeedDataSource;
	}
	
	return nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) init
{
    self = [super init];
	if (self) {
		
		feedDataModel = [[FeedDataModel alloc] init];
		
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) fetchFeedForFilter:(NSDictionary*)filterDictionary forFilterType:(NSInteger)index
{
	feedDataModel.page = 1;
	feedDataModel.selectedFilterType = index;
	feedDataModel.isMoreFeedItems = YES;
	feedDataModel.filterDictionary = filterDictionary;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewDataSource methods

- (id<TTModel>)model {
	return feedDataModel;
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {
	
	if ([object isKindOfClass:[Note class]]) {
		
		return [NoteFeedItemCell class]; 
	}
    if ([object isKindOfClass:[WebLink class]]) {
		
		return [WebLinkFeedItemCell class]; 
	}
    if ([object isKindOfClass:[Message class]]) {
		
		return [MessageFeedItemCell class]; 
	}
    if ([object isKindOfClass:[Milestone class]]) {
		
		return [MilestoneFeedItemCell class]; 
	}

    return [super tableView:tableView cellClassForObject:object];
}


- (void)tableViewDidLoadModel:(UITableView *)tableView {
	
	NSLog(@"I am in tableViewDidLoadModel %d",count++ );
	NSMutableArray *modelItems = [NSMutableArray arrayWithArray:[feedDataModel modelItems]];
	self.items = modelItems;
    
    if (feedDataModel.isMoreFeedItems) {
        
        TTTableMoreButton *button = [TTTableMoreButton itemWithText:@"Loading More..."];
        [self.items addObject:button];
    }else
    {
        TTTableMoreButton *button = [TTTableMoreButton itemWithText:@"No more posts available"];
        [self.items addObject:button];
    }
    
}

#pragma mark -
#pragma mark TTTableView methods
//- (NSIndexPath*)indexPathOfItemWithUserInfo:(id)userInfo

- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell willAppearAtIndexPath:(NSIndexPath*)indexPath {
	[super tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
	if (indexPath.row == self.items.count-1 && [cell isKindOfClass:[TTTableMoreButtonCell class]]) {
		TTTableMoreButton* moreLink = [(TTTableMoreButtonCell *)cell object];
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (feedDataModel.isMoreFeedItems) {
            moreLink.isLoading = YES;
            [(TTTableMoreButtonCell *)cell setAnimating:YES];
            [self.model load:TTURLRequestCachePolicyDefault more:YES];
        }else
        {
            moreLink.isLoading = NO;
            [(TTTableMoreButtonCell *)cell setAnimating:NO];
        }
        
    }
}

#pragma mark -
#pragma mark Error Handling methods

- (NSString *)titleForLoading:(BOOL)reloading {
	return @"Loading...";
}

- (NSString *)titleForEmpty {
	return @"No feed";
}

- (NSString *)titleForError:(NSError *)error {
	return @"Oops";
}

- (NSString *)subtitleForError:(NSError *)error {
	return @"The requested feed is not available.";
}


-(void)dealloc
{
	//[feedDataModel release];
	[super dealloc];
}


@end
