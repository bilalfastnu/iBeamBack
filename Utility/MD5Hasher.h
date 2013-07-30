//
//  Utility.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

@interface MD5Hasher : NSObject {
    
}
//generates md5 hash from a string
+ (NSString *) returnMD5Hash:(NSString*)concat;
+ (NSString *) append:(id) first, ...;

@end
