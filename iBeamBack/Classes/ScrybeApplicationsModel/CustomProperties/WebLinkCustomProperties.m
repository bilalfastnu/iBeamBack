//
//  WebLinkCustomProperties.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/15/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "WebLinkCustomProperties.h"

@implementation WebLinkCustomProperties

@synthesize icon, source, thumbnailUrl;
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject
{
    self = [super init];
    
	if (self) {

        icon = [[dictionaryObject objectForKey:@"icon"] retain];
        source = [[dictionaryObject objectForKey:@"source"] retain];
        thumbnailUrl = [[dictionaryObject objectForKey:@"thumbnailURL"] retain];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [icon release];
	[source release];
	[thumbnailURL release];

    [super dealloc];
}

@end
