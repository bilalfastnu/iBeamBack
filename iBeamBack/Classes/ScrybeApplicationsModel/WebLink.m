//
//  WebLink.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "WebLink.h"

#import "extThree20JSON/JSON.h"


@implementation WebLink


@synthesize customProperty;
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithFeedData:(NSDictionary*)data
{
    self = [super initWithFeedData:data];
    if (self) {
        
        customProperty = [[WebLinkCustomProperties alloc] initWithCustomProperty:[[data objectForKey:@"custom_properties"] JSONValue]];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dealloc
{
    [customProperty release];
    [super dealloc];
}

@end
