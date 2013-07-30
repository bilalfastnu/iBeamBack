//
//  ChatViewController.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatNotificationManager.h"
#import "ScrybeUserImage.h"

#define X_POSTION 250
#define Y_POSTION 0
#define  NOTIFICATION_OFFSET 0


@implementation ChatViewController

@synthesize currentUser;
@synthesize friendDictionry;





-(id)init{
    
    self = [super init];
    if (self) {      
        
        
        friendDictionry = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserChatView)name:@"TappedOnNotificationView" object:nil ];
    }
    return self;
    
}


-(void)setCurrentUser:(ChatUser*)newUser
{
	if (currentUser !=newUser) {
		[currentUser release];
		currentUser = [newUser retain];
		self.title = currentUser.userName;
        [chatSessionController updateCurrentSelectedUser:currentUser];
		
	}
}
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



-(void)presentPopover:(id)sender
{
	[popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


#pragma mark -
#pragma mark - Utility method

-(void)addNotificationView:(NSString*)userName withMessage:(NSString*)textMsg
{
    
    if (notificationView == NULL) {
        notificationView = [[NotificationView alloc] initWithFrame:CGRectMake(250, 2, 290, 70)]; 
    }
    
    notificationView.notifierId = userName;
    NSString *name =[[userName componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    notificationView.userNameLabel.text = name;
    
   	
    NSString *imageUrl  =[ScrybeUserImage getScrybeUserImageUrl:[usersVC getUserId:name] imageSize:@"32x32"];
    notificationView.notifierImageView.urlPath = imageUrl;
	notificationView.messageLabel.text = textMsg;
	
	CGRect frame =chatSessionController.view.frame;
    
    
    // Show
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:0.3];
    notificationView.frame = CGRectMake(X_POSTION, Y_POSTION, notificationView.frame.size.width, notificationView.frame.size.height);
    chatSessionController.view.frame = CGRectMake(frame.origin.x, frame.origin.y+70, frame.size.width, frame.size.height-70);
    
    [UIView commitAnimations];  
    
    [self.view addSubview:notificationView];
    
    [self performSelector:@selector(toggleNotification) withObject:nil afterDelay:5.0];    
}



-(void)toggleNotification {
    // If calendar is off the screen, show it, else hide it (both with animations)
    
    CGRect frame =chatSessionController.view.frame;
    // Hide
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.6];
    notificationView.frame = CGRectMake(X_POSTION, -notificationView.frame.size.height+NOTIFICATION_OFFSET, notificationView.frame.size.width, notificationView.frame.size.height);
    chatSessionController.view.frame = CGRectMake(frame.origin.x, frame.origin.y-70, frame.size.width, frame.size.height+70);
    
    [UIView commitAnimations];
    
}




-(ChatUser*)getNotifingUser:(ChatItem*)receivedMsg
{
    ChatUser *newUser = [[ChatUser alloc] init];
    newUser.userId = receivedMsg.fromUserId;
    newUser.status = AVAILABLE;
    if (newUser !=nil) {
        newUser.userName = [[receivedMsg.fromUserId componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
    
    
    return newUser;
}

-(void)receiveNotification:(ChatItem*)messageRec{
    
    ChatUser *notifUser=nil;
    if ([friendDictionry count]==0) {
        notifUser = [self getNotifingUser:messageRec];
        
    }
    
    else
    {
        notifUser=[friendDictionry objectForKey:messageRec.fromUserId];
    }
    
    ChatSession *notifSession=[chatSessionController performSelector:@selector(createSession:)withObject:notifUser];
    
    [notifSession.chatArray addObject:messageRec];
    [chatSessionController performSelector:@selector(updateChat:withSession:) withObject:notifUser withObject:notifSession];
    
    NSString *textmsg = [[notifSession.chatArray objectAtIndex:[notifSession.chatArray count]-1 ] textMessage];
    
    
    
    [self addNotificationView:messageRec.fromUserId withMessage:textmsg];
    
    
}

-(void)updateUserChatView{
    
    ChatUser *notifUser=[friendDictionry objectForKey: notificationView.notifierId];
    [self setCurrentUser:notifUser];
    
}


-(void)closeChat
{
    
    ChatNotificationManager *chatNotificationManager =[ChatNotificationManager sharedChatNotificationManager];
    _chatManager.delegate = chatNotificationManager;
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    
    
    
    
}
#pragma mark -
#pragma mark Chat Manager delegate method

-(void)receiveMessage:(ChatItem *)messageReceived{
    
    
    if([messageReceived.fromUserId compare:currentUser.userId] == NSOrderedSame){
        [chatSessionController receiveMsg:messageReceived ];
    }
    else
    {
        [self receiveNotification:messageReceived]; 
    }
    
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
    
    usersVC = [[UsersViewController alloc] initWithStyle:UITableViewStylePlain];
    usersVC.userChatViewController =self;
    UINavigationController *usersNavController = [[UINavigationController  alloc] initWithRootViewController:usersVC];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:usersNavController];
    [usersNavController release];
    
    chatSessionController = [[ChatSessionViewController alloc] init];
    
    UIView *myView =[[UIView alloc] initWithFrame:CGRectMake(0,0, 540, 620)];
    
    myView.backgroundColor =[UIColor whiteColor];
    
    [myView addSubview:chatSessionController.view];
    
    
    ///////
    _chatManager = [ChatManager sharedChatManager];
    _chatManager.delegate =self;
    chatSessionController.sessionDelegate =_chatManager;
    self.view =myView;
    [myView release];
    
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeChat)];
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    [rightBarBtn release];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Users" style:UIBarButtonItemStylePlain target:self action:@selector(presentPopover:)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    
    if (currentUser ==nil) {
		self.title = @"SMS Chat";
	}
    else
        self.title = currentUser.userName;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
    
    
}

@end
