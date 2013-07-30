//
//  ChatUser.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatUser.h"
#import "ChatItem.h"


@implementation ChatUser

@synthesize userName;
@synthesize userProfileImage;
@synthesize status;
@synthesize userId;



-(id)init{
	self = [super init];	
	if (self) {
		
		
	}
	return self;
	
}
-(void)dealloc{
	[userProfileImage release];
    [userName release];
	[userId release];
	[super dealloc];
}

@end
