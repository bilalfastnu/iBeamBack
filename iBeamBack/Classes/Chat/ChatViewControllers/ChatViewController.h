//
//  ChatViewController.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatSessionViewController.h"
#import "ChatUser.h"
#import "ChatManager.h"
#import "NotificationView.h"
#import "UsersViewController.h"



@interface ChatViewController : UIViewController<ChatManagerDataReceiverDelegate> {
    UIPopoverController *popoverController;
    ChatSessionViewController *chatSessionController; 
    ChatUser *currentUser;
    ChatManager *_chatManager;
    NotificationView *notificationView;
    NSMutableDictionary *friendDictionry;
    UsersViewController *usersVC;
    
}

@property (nonatomic,retain) ChatUser *currentUser;
@property (nonatomic,retain) NSMutableDictionary *friendDictionry;
@end
