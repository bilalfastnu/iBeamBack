//
//  RemoteCaller.m
//  iPadBeamBack
//
//  Created by Bilal Nazir on 7/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "RemoteCaller.h"


@implementation RemoteCaller
@synthesize delegate=m_delegate;
@synthesize lastMethodInvoked;
@synthesize AMFRemotingService;


#pragma mark -
#pragma mark Initialization & Deallocation

- (id)initWithRemotingService:(NSString *)remotingService withRemotCallingURL:(NSString *)remotURL
{
    self = [super init];
	if (self)
	{
		AMFRemotingService = remotingService;
		m_remotingCall = [[AMFRemotingCall alloc] init];
		//		m_remotingCall.URL = [NSURL URLWithString:@"http://www.nesium.com/amfdemo/gateway.php"];
		//		m_remotingCall.service = @"ExampleService";
		//m_remotingCall.URL = [NSURL URLWithString:AMFRemoteCallingURL];
		m_remotingCall.URL = [NSURL URLWithString:remotURL];
		m_remotingCall.service = AMFRemotingService;
		
		m_remotingCall.delegate = self;
		m_delegate = nil;
		
		lastMethodInvoked = [[NSString alloc] init];

		NSLog(@"Remote URL is :%@",m_remotingCall.URL);
		NSLog(@"Remote Base Service :%@",m_remotingCall.service);
	}
	return self;
}

- (void)dealloc
{
	[m_remotingCall release];
	[lastMethodInvoked release];
	[super dealloc];
}

#pragma mark -
#pragma mark AMFRemotingCall Delegate methods

- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall 
					  receivedObject:(NSObject *)object
{
	NSLog(@"Last Method invoked...:%@",m_remotingCall.method);
	objc_msgSend(m_delegate, @selector(callerDidFinishLoading:receivedObject:), self, object);
	
}

- (void)remotingCall:(AMFRemotingCall *)remotingCall didFailWithError:(NSError *)error
{
	objc_msgSend(m_delegate, @selector(caller:didFailWithError:), self, error);
}


@end
