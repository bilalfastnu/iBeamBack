//
//  Utility.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MD5Hasher.h"


@implementation MD5Hasher

///////////////////////////////////////////////////////////////////////////////////////////////////
//generate md5 hash from string
+ (NSString *) returnMD5Hash:(NSString*)concat {
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
	
}

+ (NSString *) append:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while (eachArg = va_arg(alist, id)) 
			result = [result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
}

@end
