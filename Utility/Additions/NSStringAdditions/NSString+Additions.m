//
//  NSString+Additions.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/24/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Category)

+ (NSString*) stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
	NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	uuidString = [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
	return [uuidString autorelease];
}
@end
