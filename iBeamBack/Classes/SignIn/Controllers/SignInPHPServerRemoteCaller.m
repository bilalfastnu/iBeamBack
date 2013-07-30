//
//  SignInPHPServerRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SignInPHPServerRemoteCaller.h"

#import "AccountManager.h"
#import "DateManager.h"
#import "AccountsRemoteCaller.h"

@implementation SignInPHPServerRemoteCaller

@synthesize signInDelegate;
///////////////////////////////////////////////////////////////////////////

-(void)SignInWithUserName:(NSString *)userName AndPassword:(NSString *)password
{
    accountRemoteCaller = [[AccountsRemoteCaller alloc] init];
    accountRemoteCaller.delegate = self;
    [accountRemoteCaller signInWithArguments:[NSArray arrayWithObjects:userName,password,nil]];
    
   startMiliseconds = [[NSDate date] timeIntervalSince1970]*1000;
}
#pragma mark -
#pragma mark RemoteCall Delegate methods

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    @try {
        [accountRemoteCaller release];
        NSLog(@"in PHP Controler %@",object);
        ASObject *response = (ASObject *)object;
        
        //just for verify data
        if ([[response.properties objectForKey:@"message"] isEqualToString:@""]) {
            
            double endMiliseconds = [[NSDate date] timeIntervalSince1970]*1000; 
            
            double baseTimeStamp = (endMiliseconds-startMiliseconds);
           
            [[DateManager sharedDateManager] setTime:[[response.properties objectForKey:@"data"] objectForKey:@"time"] withBaseTimeStamp:baseTimeStamp withInitializationTimeStamp:[[NSDate date] timeIntervalSince1970]*1000];
            
            [[AccountManager sharedAccountManager] initilizeAmazonWebServiceData:response];
            
             [signInDelegate didSignInSuccessfullyWithObject:@"SignedAtPHPServer"];
              
        }else // if login not successfuly
        {
             [signInDelegate didSignInFailWithError:(NSError*)object];
        }    
    }
    @catch (NSException *exception) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"signInFail" object:object];
        
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



///////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [super dealloc];
}


@end
