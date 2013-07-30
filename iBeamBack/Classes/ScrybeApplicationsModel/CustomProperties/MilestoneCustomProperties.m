//
//  MilestoneCustomProperties.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MilestoneCustomProperties.h"


@implementation MilestoneCustomProperties

@synthesize status, dueOn, text, title, assignedTo;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject
{
    self = [super init];
    
	if (self) {
        
        status = [[dictionaryObject objectForKey:@"status"] retain];
        dueOn = [[dictionaryObject objectForKey:@"dueOn"] retain];
        title = [[dictionaryObject objectForKey:@"title"] retain];
        text = [[dictionaryObject objectForKey:@"text"] retain];
        assignedTo = [[dictionaryObject objectForKey:@"assignedTo"] retain];

    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [status release];
    [dueOn release];
	[text release];
	[title release];
	[assignedTo release];

    [super dealloc];
}


@end
