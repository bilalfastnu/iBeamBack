//
//  ChatSessionViewController.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatSessionViewController.h"
#include <time.h>
#import "ScrybeUserImage.h"
#import "UserManager.h"

#import "ICONS.h"
#import "CONSTANTS.h"
#import "UsersViewController.h"
#import "ChatUser.h"
#import "NotificationView.h"

#import <QuartzCore/QuartzCore.h>
#import "MessageView.h"
#import "ChatItem.h"
#import "ChatManager.h"


BOOL IS_REPLY = NO;
CGFloat cell_Height =0.0f;
static int i =0;


@implementation ChatSessionViewController


@synthesize currentSelectedUser;
@synthesize sessionDelegate;
@synthesize latestTimestamp;
@synthesize chatContent;
@synthesize chatBar;
@synthesize chatInput;
@synthesize lastContentHeight;
@synthesize chatInputHadText;
@synthesize sendButton;







#pragma mark -
#pragma mark Text view delegate

// Reveal a Done button when editing starts
- (void)textViewDidBeginEditing:(UITextView *)textView {
	
  
	textView.text = @"";
	textView.textColor = [UIColor blackColor];
    textView.enablesReturnKeyAutomatically = YES;
	
	
	
}



- (void)textViewDidChange:(UITextView *)textView {
	CGFloat contentHeight = textView.contentSize.height - 12.0f;
	
	
	if ([textView hasText]) {
		if (!chatInputHadText) {
			ENABLE_SEND_BUTTON;
			chatInputHadText = YES;
		}
		
		if (textView.text.length > 620) { // truncate text to 1024 chars
			textView.text = [textView.text substringToIndex:620];
		}
		
		// Resize textView to contentHeight
		if (contentHeight != lastContentHeight) {
			if (contentHeight <= 76.0f) { // Limit chatInputHeight <= 4 lines
				
				CGFloat chatBarHeight = contentHeight + 18.0f;
				SET_CHAT_BAR_HEIGHT(chatBarHeight);
				if (lastContentHeight > 76.0f) {
					textView.scrollEnabled = NO;
					
				}
				textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
			} else if (lastContentHeight <= 76.0f) { // grow
				textView.scrollEnabled = YES;
				textView.contentOffset = CGPointMake(0.0f, contentHeight-68.0f); // shift to bottom
				if (lastContentHeight < 76.0f) {
					
					EXPAND_CHAT_BAR_HEIGHT;
				}
			}
		}	
	} else { // textView is empty
		if (chatInputHadText) {
			DISABLE_SEND_BUTTON;
			chatInputHadText = NO;
		}
		if (lastContentHeight > 22.0f) {
			RESET_CHAT_BAR_HEIGHT;
			if (lastContentHeight > 76.0f) {
				textView.scrollEnabled = NO;
				
			}
		}		
		textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk	
		
	}
	lastContentHeight = contentHeight;
	
}

// This fixes a scrolling quirk
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    
    if ([text isEqualToString:@"\n"]) {
        [self sendMsg];
        
    }
    
	return YES;
}

// Prepare to resize for keyboard
#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
	
    
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = newTextViewFrame;
   
	
    [UIView commitAnimations];
	chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
	chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
}



- (void)keyboardWillHide:(NSNotification *)notification {
	
	
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0, 0, 540, 580);
  
	
    [UIView commitAnimations];
    
    
}



#pragma mark -
#pragma mark View lifecycle

-(id)init{
    self = [super init];
    
	if (self) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification object:self.view.window];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification object:self.view.window];
        
        ChatManager *manager = [ChatManager sharedChatManager];
       
        currentUser = [[ChatUser alloc]init];
      
       
        currentUser.userId =  manager.loginedUserId;;
        
		
	}
	return self;
}

- (void)loadView {
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	self.navigationController.navigationBar.tintColor = ACANI_RED;
	
	//Create Chat Manager
	//chatManager = [[ChatDataManager alloc] init];
    chatManager = [ChatDataManager sharedChatDataManager];
	
	
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 540,580)];
	contentView.backgroundColor = CHAT_BACKGROUND_COLOR; // shown during rotation
	
	// Create chatContent.
	UITableView *tempChatContent = [[UITableView alloc] initWithFrame:
									CGRectMake(0.0f, 0.0f,contentView.frame.size.width,
											   contentView.frame.size.height - CHAT_BAR_HEIGHT_1)];
	
	
	
	
	
	self.chatContent = tempChatContent;
	[tempChatContent release];
	chatContent.clearsContextBeforeDrawing = NO;
	chatContent.delegate = self;
	chatContent.dataSource = self;
	chatContent.backgroundColor = CHAT_BACKGROUND_COLOR;
	chatContent.separatorStyle = UITableViewCellSeparatorStyleNone;
	chatContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[contentView addSubview:chatContent];
	
	// Create chatBar.
	UIImageView *tempChatBar = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, contentView.frame.size.height - CHAT_BAR_HEIGHT_1,
										   contentView.frame.size.width, CHAT_BAR_HEIGHT_1)];
	
	self.chatBar = tempChatBar;
	[tempChatBar release];
	chatBar.clearsContextBeforeDrawing = NO;
	chatBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	chatBar.image = [[UIImage imageNamed:ChatBarIcon] stretchableImageWithLeftCapWidth:18 topCapHeight:20];
	chatBar.userInteractionEnabled = YES;
	
	
	
	
	// Create chatInput.
	
	UITextView *tempChatInput = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 8.0f, chatContent.frame.size.width-100, 25.0f)];
	self.chatInput = tempChatInput;
	[tempChatInput release];
	
	UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
		//chatInput.contentSize = CGSizeMake(694.0f, 25.0f);
        chatInput.contentSize = CGSizeMake(620.0f, 25.0f);
    } else {
		//chatInput.contentSize = CGSizeMake(950.0f, 25.0f);
        chatInput.contentSize = CGSizeMake(620.0f, 25.0f);
    }
	chatInput.text = @"Enter Text Here...";
	chatInput.textAlignment = UITextAlignmentLeft;
	chatInput.scrollsToTop =YES;
	chatInput.textColor = [UIColor grayColor];
	chatInput.delegate = self;
	chatInput.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	chatInput.scrollEnabled = NO; // not initially
	chatInput.scrollIndicatorInsets = UIEdgeInsetsMake(5.0f, 0.0f, 4.0f, -2.0f);
	chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
	chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
	chatInput.clearsContextBeforeDrawing = NO;
	chatInput.font = [UIFont systemFontOfSize:INPUT_FONT_SIZE];
	chatInput.dataDetectorTypes = UIDataDetectorTypeAll;
	chatInput.backgroundColor = [UIColor clearColor];
	lastContentHeight = chatInput.contentSize.height;
	chatInputHadText = NO;
	[chatBar addSubview:chatInput];	
	
	
	
	// Create sendButton.
	self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sendButton.clearsContextBeforeDrawing = NO;
	sendButton.frame = CGRectMake(chatBar.frame.size.width - 70.0f, 8.0f, 64.0f, 26.0f);  // multi-line input & landscape (below)
	sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	UIImage *sendButtonBackground = [UIImage imageNamed:SendButtonIcon];
	[sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateNormal];
	[sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateDisabled];	
	sendButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
	sendButton.backgroundColor = [UIColor clearColor];
	[sendButton setTitle:@"Send" forState:UIControlStateNormal];
	[sendButton addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
	
	
	
	
	DISABLE_SEND_BUTTON; // initially
	[chatBar addSubview:sendButton];
	
	[contentView addSubview:chatBar];
	
	[contentView sendSubviewToBack:chatBar];
	
	self.view = contentView;
	[contentView release];
    
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (currentSelectedUser ==nil) {
		self.title = @"SMS Chat";
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
	self.navigationController.navigationBar.tintColor = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}




#pragma mark -
#pragma mark MyUtility methods



-(NSString*)getTimeStamp{
	
	if (true) { 
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; // Jan 1, 2010
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  // 1:43 PM
        
        time_t now; time(&now);
        latestTimestamp = now;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:latestTimestamp];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // TODO: get locale from iPhone system prefs
        [dateFormatter setLocale:usLocale];
        [usLocale release];
        
        return ( [dateFormatter stringFromDate:date]);
        
	}
}

-(ChatSession*)getSession:(NSString*)sessionId
{
	id anObj=[chatManager.chatDataManager objectForKey:sessionId];
	return anObj;
}



-(ChatSession*)createSession:(ChatUser*)newUser
{  
	ChatSession *mySession =nil;
	mySession =[self getSession:newUser.userId];    
	
	if (mySession == nil) {			
		
		mySession =[[[ChatSession alloc] init] autorelease];
        mySession.sessionUser = newUser;
		
		mySession.sessionId = newUser.userId;
                
		[chatManager.chatDataManager setObject:mySession forKey:newUser.userId];
		
	}
	
	return mySession;
}


-(void)updateCurrentSelectedUser:(ChatUser*)newUser
{
    currentSelectedUser = newUser;
    ChatSession *mySession =[self createSession:currentSelectedUser];
    
    session = mySession;
    [chatContent reloadData];
    
}
-(NSString*)getUserId:(NSString*)userName{
    
    NSString *userId =[[NSString alloc] init];
    if ([userName compare:@"sumaira"] == NSOrderedSame) {
        userId = @"usr-3db7277e-5538-11e0-b8a8-000f2075d66f";
        
    }
    if ([userName compare:@"umar"] == NSOrderedSame) {
        userId = @"usr-3db10a56-5538-11e0-b8a8-000f2075d66f";

    }
    if ([userName compare:@"bilal"] == NSOrderedSame) {
        userId = @"usr-3d9af14e-5538-11e0-b8a8-000f2075d66f";
    }
    
    if ([userName compare:@"ali"] == NSOrderedSame) {
        userId = @"usr-3db7277e-5538-11e0-b8a8-000f2075d66f";
    }
    return userId;
    
}


/*-(void)updateChat:(ChatUser*)user withSession:(ChatSession*)chatSession{
	
	ChatSession *updateChat = [chatManager.chatDataManager objectForKey:user.userId];
	updateChat.chatArray = chatSession.chatArray;
	if (updateChat) {
		[chatManager.chatDataManager setObject:updateChat forKey:user.userId];
	}
	
}*/

-(void)updateChat:(ChatUser*)user withSession:(ChatSession*)chatSession{
 
    ChatSession *updateChat = [chatManager.chatDataManager objectForKey:user.userId];
    updateChat.chatArray = chatSession.chatArray;
    if (updateChat) {
        [chatManager.chatDataManager setObject:updateChat forKey:user.userId];
    }
 
 }

-(void)receiveMsg:(ChatItem*)msgReceived{
	
	IS_REPLY =YES;
	
	
	
	if (session == nil) {
		session = [[ChatSession alloc] init];
	}
    [session.chatArray addObject:msgReceived];
    [self updateChat:currentSelectedUser withSession:session];
    
    [self sendMsg];
	
	
	
	
}
- (void)scrollToBottomAnimated:(BOOL)animated {
	
	
	i = [session.chatArray count]-1;
	
	NSUInteger bottomRow = [session.chatArray count] - 1;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
	[chatContent beginUpdates];
	[chatContent insertRowsAtIndexPaths:[NSArray arrayWithObject:
                                         [NSIndexPath indexPathForRow:bottomRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	[chatContent endUpdates];
	
	
	[chatContent scrollToRowAtIndexPath:indexPath
					   atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	
			
    
}


- (void)sendMsg {
	if (!IS_REPLY) {
		if (session == nil) {
			session = [[ChatSession alloc] init];
		}
               
        ChatItem *chatItem =[[ChatItem alloc] init];
        chatItem.textMessage =chatInput.text;
        chatItem.timeStamp =[self getTimeStamp];
        chatItem.fromUserId =currentUser.userId;
		
        chatItem.toUserId = currentSelectedUser.userId;
		
        [session.chatArray addObject:chatItem];
        
        [self updateChat:currentSelectedUser withSession:session];
        [sessionDelegate sendMessage:chatItem];
        
        [chatItem release];
        chatInput.text = @"";
       
        DISABLE_SEND_BUTTON;
        
        	
        
	} 
    
    
	[self scrollToBottomAnimated:YES];
	IS_REPLY = NO;
    
	
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [session.chatArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *CellIdentifire =@"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifire];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifire] autorelease];
		cell.selectionStyle =UITableViewCellSelectionStyleNone;
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
        
		
		message =[[MessageView alloc]initWithFrame:CGRectMake(0,0, cell.frame.size.width, cell.frame.size.height)];
		[cell.contentView addSubview:message];
		
	}
	else {
		
		message.balloonView = (UIImageView *)[[cell.contentView viewWithTag:MESSAGE_TAG] viewWithTag:BALLOON_TAG];
		message.label = (UILabel *)[[cell.contentView viewWithTag:MESSAGE_TAG] viewWithTag:TEXT_TAG];
		message.userImageView = (TTImageView *)[[cell.contentView viewWithTag:MESSAGE_TAG] viewWithTag:USER_TAG];
		
	}
	
	
	ChatItem *messageItem = [session.chatArray objectAtIndex:indexPath.row];
	NSString *text = messageItem.textMessage;
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:MESSAGE_FONT_SIZE]
				   constrainedToSize:CGSizeMake(CONSTRAINED_WIDTH, CONSTRAINED_HEIGHT)
					   lineBreakMode:UILineBreakModeWordWrap];
    
    

   // NSString *userId = [[UserManager sharedUserManager] getCurrentUserId];
   NSString *imageUrl  =[ScrybeUserImage getScrybeUserImageUrl:[[UserManager sharedUserManager] getCurrentUserId] imageSize:@"32x32"];
	
	UIImage *balloon;	
    
	
	if (messageItem.fromUserId ==currentUser.userId) {
 
        
        message.userImageView.urlPath =imageUrl;
            
        
        message.balloonView.frame =CGRectMake(chatContent.frame.size.width - ((size.width + 35.0f)+40),2.0f,size.width + 35.0f, size.height + 13.0f);
         
         balloon = [[UIImage imageNamed:ChatBubbleGreenIcon] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
         message.label.frame =CGRectMake(chatContent.frame.size.width -30.0f - (size.width+32),
         5.0f , size.width + 5.0f, size.height);		
         
         message.userImageView.frame = CGRectMake(chatContent.frame.size.width -(40),
         message.balloonView.frame.size.height-25,32, 32);
		
		
		
		
	}
	else
	{
		
        NSString * senderName =session.sessionUser.userName;
        NSLog(@"sender Name %@",senderName);
             
        
       // NSString *userId =[self getUserId:senderName];
        imageUrl  =[ScrybeUserImage getScrybeUserImageUrl:[self getUserId:senderName] imageSize:@"32x32"];
        
         message.userImageView.urlPath =imageUrl;
        
		message.balloonView.frame = CGRectMake(42, 2.0f, size.width + 35.0f, size.height + 13.0f);
		balloon = [[UIImage imageNamed:ChatBubbleGrayIcon] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
		
		message.label.frame = CGRectMake(57, 5.0f, size.width + 5.0f, size.height);
		
		message.userImageView.frame = CGRectMake(10.0f,message.balloonView.frame.size.height-25,
												 32, 32);
        
	}
	
	
	message.balloonView.image = balloon;
	
	message.label.text = text;   
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  { 
	
	ChatItem *messageItem = [session.chatArray objectAtIndex:indexPath.row];
	NSString *msg = messageItem.textMessage;
	
 	
	
	CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(CONSTRAINED_WIDTH, CONSTRAINED_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];	
	cell_Height = size.height + 40.0f;
	return cell_Height;
	
    
} 


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	message = nil;
	self.chatContent = nil;
	self.sendButton = nil;
	self.chatInput = nil;
	self.chatBar = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
	[message release];
	[chatContent release];
	[sendButton release];
	[chatInput release];
	[chatBar release];
	
	[super dealloc];
}


@end
