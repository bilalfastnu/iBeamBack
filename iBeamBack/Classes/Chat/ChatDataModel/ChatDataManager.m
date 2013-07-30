//
//  ChatDataManager.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatDataManager.h"


@implementation ChatDataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ChatDataManager);

@synthesize chatDataManager;


-(id)init{
	self = [super init];
	if (self) {
		chatDataManager = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void)dealloc {
	[chatDataManager release];
    [super dealloc];
}


@end

