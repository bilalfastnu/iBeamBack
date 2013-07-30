//
//  GroupRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "GroupRemoteCaller.h"


#import "AccountManager.h"

@implementation GroupRemoteCaller

- (id)init
{
	NSString *accountRemotingService = [NSString stringWithFormat:@"%@accounts",AMFRemotingBaseService];
    
	self = [super initWithRemotingService:accountRemotingService withRemotCallingURL:AMFRemoteCallingURL];
	if (self)
	{
		//Initialization
	}
	return self;
}
-(void) getAccountData
{
	AccountManager *accountManager = [AccountManager sharedAccountManager];
	
	m_remotingCall.method = @"AccountsData.getAccountData";
	m_remotingCall.arguments = [NSArray arrayWithObjects:accountManager.userAccount.accountId,nil];
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
}

@end
