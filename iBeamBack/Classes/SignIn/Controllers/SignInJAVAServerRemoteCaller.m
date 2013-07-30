//
//  SignInJAVAServerRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SignInJAVAServerRemoteCaller.h"


@implementation SignInJAVAServerRemoteCaller

@synthesize signInDelegate;
///////////////////////////////////////////////////////////////////////////

- (id)init
{
	
	NSString *feedRemotingService = [NSString stringWithFormat:@"%@",LOGIN_SERVICE_SEARCH_SERVER];
	self = [super initWithRemotingService:feedRemotingService withRemotCallingURL:INDEX_GATEWAY_URL];
	if (self)
	{
		m_remotingCall.amfVersion = kAMF0Version;
		super.delegate = self;
		
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////
-(void)SignInWithUserName:(NSString *)userName AndPassword:(NSString *)pass
{
	m_remotingCall.method = @"login";
	
	m_remotingCall.arguments = [NSArray arrayWithObjects:userName, pass, [NSNull null], @"false",nil];
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
	
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark RemoteCall Delegate methods


- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    @try {
        NSLog(@"in JAVA Controler %@",object);
        
        NSDictionary *loginInfoDictionary = (NSDictionary*) object;
        int loginStatus = [[loginInfoDictionary objectForKey:@"login_status"] intValue]; 
        
        if (loginStatus ) {
            
              [signInDelegate didSignInSuccessfullyWithObject:@"SignedAtJAVAServer"];
            
        }else // if login not successfuly
        {
             [signInDelegate didSignInFailWithError:(NSError*)object];
        }    
    }
    @catch (NSException *exception) {
        
          [signInDelegate didSignInFailWithError:(NSError*)object];
     
    }
    @finally {
        
    }
    
}

- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
	UIAlertView *errorAlertView = [[UIAlertView alloc] 
                                   initWithTitle:@"Feed Data Error in Feed Remote Caller"
                                   message:[NSString stringWithFormat:@"%@", error] 
                                   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
	[errorAlertView show];
	[errorAlertView release];
	
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"signInFail" object:nil];
}


///////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [super dealloc];
}
@end
