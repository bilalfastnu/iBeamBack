//
//  ChatItem.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatItem.h"




@implementation ChatItem

@synthesize textMessage;
@synthesize timeStamp;
@synthesize fromUserId;
@synthesize toUserId;




-(id)init{
	self = [super init];	
	if (self) {
        
		
	}
	return self;
	
}
-(void)dealloc{
	[textMessage release];
	[timeStamp release];
	[fromUserId release];
	[toUserId release];
	[super dealloc];
}


@end
