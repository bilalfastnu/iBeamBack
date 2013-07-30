//
//  FeedRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedRemoteCaller.h"

#import "CONSTANTS.h"
#import "Account.h"
#import "AccountManager.h"

@implementation FeedRemoteCaller



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
	NSString *FeedRemotingService = [NSString stringWithFormat:@"%@",JAVA_ACCOUNT_FEED_SERVICE];
	self = [super initWithRemotingService:FeedRemotingService withRemotCallingURL:INDEX_GATEWAY_URL];
	if (self)
	{
        //Initialization
        
		m_remotingCall.amfVersion = kAMF0Version;
		
	}
	return self;
}
-(void)fetchAccountFeedForPage:(NSInteger)page
{
	m_remotingCall.delegate = self;
	
	int startingIndex = (page - 1) *FEED_PAGE_SIZE;
	
	AccountManager *accountManager = [AccountManager sharedAccountManager];
	NSMutableDictionary *summeryParams = [[NSMutableDictionary alloc] init];
	[summeryParams setObject:@"0" forKey:@"directsTimestamp"];
	
	m_remotingCall.method = @"fetchAccountFeed";
	
	m_remotingCall.arguments = [NSArray arrayWithObjects:accountManager.userAccount.accountId,
                                [NSNumber numberWithInt:startingIndex], [NSNumber numberWithInt:FEED_PAGE_SIZE],
                                summeryParams,[NSNumber numberWithInt:3],[NSNumber numberWithInt:150],nil];
	
	[m_remotingCall start];
	[summeryParams release];
	
	lastMethodInvoked = m_remotingCall.method;
	
}


@end
