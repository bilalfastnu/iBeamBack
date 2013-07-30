//
//  ChatItem.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChatItem : NSObject {
	
	NSString *textMessage;
	NSString  * timeStamp;
	NSString *fromUserId;
	NSString *toUserId;
   	
	
    
}

@property (nonatomic,retain)NSString *textMessage;
@property(nonatomic,retain)NSString *timeStamp;
@property(nonatomic,retain)NSString *fromUserId;
@property(nonatomic,retain)NSString *toUserId;


-(id)init;
@end