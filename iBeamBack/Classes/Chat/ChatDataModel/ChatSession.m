//
//  ChatSession.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatSession.h"


@implementation ChatSession

@synthesize chatArray;
@synthesize sessionId;
@synthesize sessionUser;



-(id)init{
	self = [super init];	
	if (self) {
		chatArray = [[NSMutableArray alloc]init];
		
	}
	return self;
	
}

-(void)dealloc{
	[sessionId release];
	[chatArray release];
    [sessionUser release];
	[super dealloc];
}

@end

