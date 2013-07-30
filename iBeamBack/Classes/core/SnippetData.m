//
//  SnippetData.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SnippetData.h"


@implementation SnippetData

@synthesize type;
@synthesize data;
///////////////////////////////////////////////////////////////////////////

-(id) initWithType:(NSString *) p_type data:(NSMutableDictionary*)p_data
{
    self = [super init];
    if (self) {
        
        type = [p_type retain];
        data = [[NSMutableDictionary alloc] initWithDictionary:p_data];
    }
    return self;
}

-(NSMutableDictionary*) getValueObjectForServer
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dict setValue:type forKey:@"type"];
    [dict setValue:data forKey:@"data"];
    
    return dict;
}

-(void) dealloc
{
    [type release];
    [data release];
    [super dealloc];
}
@end
