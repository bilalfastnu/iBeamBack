//
//  FilterFeedRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FilterFeedRemoteCaller.h"


#import "CONSTANTS.h"
#import "GroupManager.h"

@implementation FilterFeedRemoteCaller


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
	NSString *feedRemotingService = [NSString stringWithFormat:@"%@",JAVA_FEED_SERVICE];
	self = [super initWithRemotingService:feedRemotingService withRemotCallingURL:INDEX_GATEWAY_URL];
	if (self)
	{
        //Initialization
		m_remotingCall.amfVersion = kAMF0Version;
	}
	return self;
}

-(void)fetchFeedForFilter:(NSDictionary *) filterDictionary ofPageNumber:(NSInteger) page
{
	m_remotingCall.delegate = self;
	
	m_remotingCall.method = @"fetchFeed";
	
    int startingIndex = (page - 1) *FEED_PAGE_SIZE;
	
    m_remotingCall.arguments = [NSArray arrayWithObjects:[[GroupManager sharedGroupManager] getGroupsIDs],         filterDictionary,@"false",[NSNumber numberWithInt:startingIndex], [NSNumber numberWithInt:                 FEED_PAGE_SIZE],@"null", [NSNumber numberWithInt:3],[NSNumber numberWithInt:150],[NSNumber numberWithInt:1],@"null",nil];
    
	[m_remotingCall start];
	
	lastMethodInvoked = m_remotingCall.method;
	
}

#pragma mark -
#pragma mark poll Feed

-(void)pollFeed:(NSArray *)groupIDsArray withFiltersObject:(NSDictionary*)filtersObject
{
    m_remotingCall.delegate = self;
	
	m_remotingCall.method = @"pollFeed";
    
    m_remotingCall.arguments = [NSArray arrayWithObjects:[[GroupManager sharedGroupManager] getGroupsIDs],
                                @"null",nil];
    
    [m_remotingCall start];
	
	lastMethodInvoked = m_remotingCall.method;
    
}
@end
