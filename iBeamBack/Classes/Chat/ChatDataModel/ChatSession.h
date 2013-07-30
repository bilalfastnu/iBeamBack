//
//  ChatSession.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatUser.h"


@interface ChatSession : NSObject {
	
	NSMutableArray *chatArray;
	NSString *sessionId;
    ChatUser *sessionUser;
	
	
    
}

@property(nonatomic,retain)NSMutableArray *chatArray;
@property(nonatomic,retain)NSString *sessionId;
@property(nonatomic,retain)ChatUser *sessionUser;


@end
