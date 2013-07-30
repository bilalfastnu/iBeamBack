//
//  Message.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Message.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface Message(PRIVATE)

-(NSString *) getMessageTitle:(NSString *)originalString;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Message

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithFeedData:(NSDictionary*)data
{
    self = [super initWithFeedData:data];
    if (self) {
        
        title = [[self getMessageTitle:details] retain];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSString *) getMessageTitle:(NSString *)originalString
{
#define MESSAGE_TITLE_LENGTH			40.0f
	
	NSString *chunk = nil;
	
	NSArray *piecesOfOriginalString = [originalString componentsSeparatedByString:@" "];
	
	int count = [piecesOfOriginalString count];
	
	if (count == 1) {
		if ([originalString length] > MESSAGE_TITLE_LENGTH) {
			chunk = [originalString substringToIndex:MESSAGE_TITLE_LENGTH];
		}else {
			chunk = originalString;
		}
	}
	else {
		
		for (int i = 0; i < count; i++) {
			
			if (chunk) {
				chunk = [chunk stringByAppendingString:[NSString stringWithFormat:@" %@", [piecesOfOriginalString objectAtIndex:i]]];
			} else {
				chunk = [piecesOfOriginalString objectAtIndex:i];
			}
			if ([chunk length] > MESSAGE_TITLE_LENGTH) {
				break;
			}
		}
	}
	return chunk;
}
///////////////////////////////////////////////////////////////////////////////////////////////////


-(void) dealloc
{
    
    [super dealloc];
}

@end
