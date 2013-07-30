//
//  ChatLoginManager.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatNotificationManager.h"
#import "ChatViewController.h"
#import "ChatUser.h"
#import "ChatSession.h"




@implementation ChatNotificationManager


SYNTHESIZE_SINGLETON_FOR_CLASS(ChatNotificationManager);

-(id)init{
    self = [super init];
    if (self) {
        chatManager = [ChatManager sharedChatManager];
        chatManager.delegate = self;
        notificationMessages = [[NSMutableArray alloc] init];
        chatDataManager = [ChatDataManager sharedChatDataManager];
    }
    return self;
}


///////////////////////////////////////utility methods//////////////////////
-(ChatUser*)getNotifingUser:(ChatItem*)receivedMsg
{
    ChatUser *newUser = [[ChatUser alloc] init];
    newUser.userId = receivedMsg.fromUserId;
    newUser.status = AVAILABLE;
    newUser.userName = [[receivedMsg.fromUserId componentsSeparatedByString:@"@"] objectAtIndex:0];
    
    return newUser;
}



-(ChatSession*)getSession:(NSString*)sessionId
{
	id anObj=[chatDataManager.chatDataManager objectForKey:sessionId];
	return anObj;
}
-(ChatSession*)createSession:(ChatUser*)newUser
{  
	ChatSession *mySession =nil;
	mySession =[self getSession:newUser.userId];
	
	if (mySession == nil) {			
		
		mySession =[[ChatSession alloc] init];
        mySession.sessionUser = newUser;
		
		mySession.sessionId = newUser.userId;
        
		[chatDataManager.chatDataManager setObject:mySession forKey:newUser.userId];
		
	}
	
	return mySession;
}



-(void)updateChat:(ChatUser*)user withSession:(ChatSession*)chatSession{
	
	ChatSession *updateChat = [chatDataManager.chatDataManager objectForKey:user.userId];
	updateChat.chatArray = chatSession.chatArray;
	if (updateChat) {
		[chatDataManager.chatDataManager setObject:updateChat forKey:user.userId];
	}
	
}

///////////////////////////////////////Delegate methods//////////////////////
-(void)receiveMessage:(ChatItem *)messageReceived{
    
    
    [notificationMessages addObject:messageReceived];
    
    if ([notificationMessages count] >0) {
        ChatUser *notifUser = [self getNotifingUser:messageReceived];
        
        ChatSession *notifSession=[self createSession:notifUser];
        
        [notifSession.chatArray addObject:messageReceived];
        [self updateChat:notifUser withSession:notifSession];
        ChatItem *lastItem = [notificationMessages objectAtIndex:[notificationMessages count]-1];
        
        notifSession = [self getSession:lastItem.fromUserId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLastNotifierMessage" object:notifSession];
        
        NSString* count=[NSString stringWithFormat:@"%d",[notificationMessages count]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatNotificationReceived" object:count];
        
    }
    
    
}


- (void)dealloc
{
    [super dealloc];
}


@end
