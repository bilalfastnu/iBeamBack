//
//  ChatSessionViewController.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatUser.h"
#import "MessageView.h"
#import "ChatSession.h"
#import "ChatDataManager.h"
#import "ChatItem.h"


@protocol ChatSessionDelegate
-(void) sendMessage:(ChatItem*)sendingMsg;
@end



@interface ChatSessionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate> {
    
	
	ChatUser *currentUser;
    ChatUser *currentSelectedUser;
	ChatSession *session;
	ChatDataManager *chatManager;
	NSString *currentSessionID;
	
	id<ChatSessionDelegate>sessionDelegate;
    
	
	/////////////////////////////////////////
	CGFloat move;
	
	time_t latestTimestamp;
	
	UITableView *chatContent;
	
	UIImageView *chatBar;
	UITextView *chatInput;
	CGFloat lastContentHeight;
	Boolean chatInputHadText;
	UIButton *sendButton;
	
	
	MessageView *message;
	UIImage *userImage;
    
    
    
}

@property (nonatomic,retain) ChatUser *currentSelectedUser;

@property(nonatomic,retain)	id<ChatSessionDelegate>sessionDelegate;

////////////////////////////////////////////////////
@property (nonatomic, assign) time_t latestTimestamp;
@property (nonatomic, retain) UITableView *chatContent;
@property (nonatomic, retain) UIImageView *chatBar;
@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat lastContentHeight;
@property (nonatomic, assign) Boolean chatInputHadText;
@property (nonatomic, retain) UIButton *sendButton;

- (void)sendMsg;
-(void)receiveMsg:(ChatItem*)msgReceived;

-(void)updateCurrentSelectedUser:(ChatUser*)newUser;
@end
