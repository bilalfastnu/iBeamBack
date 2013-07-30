//
//  CommentsRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ConversationsRemoteCaller.h"


@implementation ConversationsRemoteCaller

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
	
	NSString *conversationRemotingService = [NSString stringWithFormat:@"%@conversations",AMFRemotingBaseService];
	self = [super initWithRemotingService:conversationRemotingService withRemotCallingURL:AMFRemoteCallingURL];
	if (self)
	{
        // add initializations
        //self.delegate = nil;
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) fetchDiscussionsAndCount:(NSDictionary*)paramsDictionary
{
	
	m_remotingCall.method = @"ResourceConversations.fetchDiscussionsAndCount";
    
	m_remotingCall.arguments = [NSArray arrayWithObjects:paramsDictionary,nil];
	
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) addComment:(NSMutableDictionary*) comment
{
    m_remotingCall.method = @"ResourceConversations.addComment";
    
   //NSLog(@"Comment Dictionary : %@",comment);
	m_remotingCall.arguments = [NSArray arrayWithObjects:comment,nil];
	
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
}


#pragma mark -
#pragma mark RemoteCaller Delegates

- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall 
                      receivedObject:(NSObject *)object;
{
    NSLog(@"Post comment %@",object);
    if (m_delegate) {
        objc_msgSend(m_delegate, @selector(callerDidFinishLoading:receivedObject:), self, object);
    }
}
- (void)remotingCall:(AMFRemotingCall *)remotingCall didFailWithError:(NSError *)error;
{
	//NSLog(@"Notes Data  Error : %@",error);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Post Data  Error"  message:[NSString stringWithFormat:@"%@", error] 
													   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}




@end
