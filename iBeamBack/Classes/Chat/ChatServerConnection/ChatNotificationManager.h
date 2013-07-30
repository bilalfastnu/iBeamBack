//
//  ChatLoginManager.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatManager.h"
#import "ChatDataManager.h"

#import "SynthesizeSingleton.h"


@interface ChatNotificationManager : NSObject<ChatManagerDataReceiverDelegate> {
    ChatManager *chatManager;
    NSMutableArray *notificationMessages;
    ChatDataManager * chatDataManager;
    
    
}

+ (ChatNotificationManager *)sharedChatNotificationManager;
@end
