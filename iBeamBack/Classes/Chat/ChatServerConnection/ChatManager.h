//
//  ChatManager.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChatItem.h"
#import "ChatSessionViewController.h"

#import "SynthesizeSingleton.h"

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;

@protocol ChatManagerDataReceiverDelegate

-(void) receiveMessage:(ChatItem*)messageReceived;

@end



@interface ChatManager : NSObject<ChatSessionDelegate> {
    
    id <ChatManagerDataReceiverDelegate>delegate;
    
    XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
    
	XMPPRosterCoreDataStorage *xmppRosterStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isOpen;
    
    NSString *loginedUserId;
    
}

@property (nonatomic,assign) id <ChatManagerDataReceiverDelegate>delegate;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic,retain)NSString *loginedUserId;

+ (ChatManager *)sharedChatManager;



@end
