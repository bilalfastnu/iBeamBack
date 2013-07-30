//
//  SignInViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SignInViewController.h"


#import "MD5Hasher.h"
#import "SignInView.h"
#import "GroupRemoteCaller.h"
#import "ChatNotificationManager.h"
#import "SignInPHPServerRemoteCaller.h"
#import "SignInJAVAServerRemoteCaller.h"


@implementation SignInViewController

@synthesize  delegate;

///////////////////////////////////////////////////////////////////////////

-(id) init
{
    self = [super init];
    
    if (self) {
        
        isSignedAtPHPServer = NO;
		isSignedAtFeedServer = NO;
        
		signInView = [[SignInView alloc] init];
        accountRemoteCaller = [[AccountsRemoteCaller alloc] init];
        accountRemoteCaller.delegate = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Log In Method

- (void) SignIn: (id) sender
{
    if ([signInView.usernameField.text isEqualToString:@""] || [signInView.passwordField.text isEqualToString:@""]) {
		
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iBeamBack"
                             message:@"Email/password combination specified is invalid."
                             delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];

		signInView.passwordField.text =  @"";
        
	}else {
        signInView.signInButton.enabled = NO; 
        [signInView.waitingIndicator startAnimating ];
        
		[accountRemoteCaller getKey];
    }
}

-(void) sendRequestForLogIn:(NSString*) serverRandomKey
{
    
    NSString *md5StrPassword = [MD5Hasher returnMD5Hash:signInView.passwordField.text];
    
    NSString *finalPass = [MD5Hasher returnMD5Hash:[md5StrPassword stringByAppendingString:serverRandomKey]];
    
    phpServerRemoteCaller = [[SignInPHPServerRemoteCaller alloc] init];
    phpServerRemoteCaller.signInDelegate = self;
    [phpServerRemoteCaller SignInWithUserName:signInView.usernameField.text AndPassword:finalPass];
    
    javaServerRemoteCaller = [[SignInJAVAServerRemoteCaller alloc] init];
    javaServerRemoteCaller.signInDelegate = self;
    [javaServerRemoteCaller SignInWithUserName:signInView.usernameField.text AndPassword:md5StrPassword];


}
///////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [accountRemoteCaller release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [signInView.signInButton addTarget:self action:@selector(SignIn:) forControlEvents:UIControlEventTouchUpInside];
    
	[self.view addSubview:signInView];

}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
			
			signInView.frame = bounds;
			
			break;
			
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationLandscapeLeft:
			
			signInView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
            
			
			break;
	}
    // Return YES for supported orientations
	return YES;
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark RemoteCall Delegate methods

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    NSLog(@"%@",object);
    
    [self sendRequestForLogIn:(NSString*)object];
    
    //serverRandomKey = [[NSString alloc] initWithString:(NSString*)object];
}

- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iBeamBack Server Error"
                        message:[NSString stringWithFormat:@"%@",error]
                        delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    signInView.signInButton.enabled = YES;
    [signInView.waitingIndicator stopAnimating];

}

///////////////////////////////////////////////////////////////////////////

-(void) fetchGroupsData
{
     groupRemoteCaller = [[GroupRemoteCaller alloc] init];
     GroupManager *groupManager = [GroupManager sharedGroupManager];
     groupManager.groupsDataProcessorDelegate = self;
     groupRemoteCaller.delegate = groupManager ;
     [groupRemoteCaller getAccountData];
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark SignIn Delegate

-(void) didSignInSuccessfullyWithObject:(NSString*)object
{
    NSString *data = object;
    if ([data isEqualToString:@"SignedAtJAVAServer"])
	{
		isSignedAtFeedServer = YES;
        [javaServerRemoteCaller release];
		NSLog (@"Successfully signIn on SignedAtJAVAServer");
	}
	
	else if ([data isEqualToString:@"SignedAtPHPServer"])
	{
		isSignedAtPHPServer = YES;
        [phpServerRemoteCaller release];
		NSLog (@"Successfully signIn on SignedAtPHPServer");
	}
	
	if( isSignedAtPHPServer && isSignedAtFeedServer )
	{
        [self fetchGroupsData];
        
        ChatNotificationManager *chatNotificationManager = [ChatNotificationManager sharedChatNotificationManager];
        
	}

 }

-(void) didSignInFailWithError:(NSError*)error

{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iBeamBack"
                      message:@"Email/password combination specified is invalid."
                      delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
    
    signInView.signInButton.enabled = YES;
    [signInView.waitingIndicator stopAnimating];

    [javaServerRemoteCaller release];
    [phpServerRemoteCaller release];

}


///////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma mark Group Manager Delegate methods

- (void)groupsDataDidFinishProcessing:(GroupManager *)groupsDataProcessing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInCompleted" object:nil];
}
- (void)groupsDataProcessing:(GroupManager *)groupsDataProcessing didFailWithError:(NSError *)error
{
    
}

///////////////////////////////////////////////////////////////////////////

@end
