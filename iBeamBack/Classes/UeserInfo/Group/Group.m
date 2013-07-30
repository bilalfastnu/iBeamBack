//
//  Group.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Group.h"


@implementation Group

@synthesize ID,name;
@synthesize createdBy,type;

///////////////////////////////////////////////////////////////////////////

-(id) init
{
    self = [super init];
    
	if (self) {

        
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
	[ID release];
	[name release];
	[createdBy release];
	[type release];
	[super dealloc];
}

@end
