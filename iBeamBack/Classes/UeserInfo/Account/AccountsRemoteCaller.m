//
//  AccountsRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "AccountsRemoteCaller.h"


@implementation AccountsRemoteCaller

///////////////////////////////////////////////////////////////////////////
- (id)init
{
	NSString *accountsRemotingService = [NSString stringWithFormat:@"%@accounts",AMFRemotingBaseService];
    self = [super initWithRemotingService:accountsRemotingService withRemotCallingURL:AMFRemoteCallingURL];
	
    if (self)
	{

	}
	return self;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public methods

// Implement  your own public Methods

- (void)getKey
{
	m_remotingCall.method = @"AccountLogin.getKey";
	m_remotingCall.arguments = [NSArray array];
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
}
- (void) signInWithArguments:(NSArray *)args
{
	m_remotingCall.method = @"AccountLogin.signIn";
	m_remotingCall.arguments = args;
	[m_remotingCall start];	
	lastMethodInvoked = m_remotingCall.method;	
}

@end
