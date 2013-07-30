//
//  ScrybeResourceImage.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeResourceImage.h"

#import "AccountManager.h"

@implementation ScrybeResourceImage


///////////////////////////////////////////////////////////////////////////////////////////////////
+(NSString*) getScrybeImageForURLVersion:(ScryePhotoVersion)version applicationName:(NSString*) applicationName withResourceId:(NSString*) resourceId withResourceUrl:(NSString *) url
{
    NSString *imageURLForVersion = nil;
    
    imageURLForVersion =[[AccountManager sharedAccountManager].amazonWebService.accountS3Path stringByAppendingString:applicationName];
    
    switch (version) {
        case ScryePhotoVersionLarge:
            return [[imageURLForVersion stringByAppendingString:resourceId] stringByAppendingFormat:@"/%@",url];
        case ScryePhotoVersionSmall:
            return [[imageURLForVersion stringByAppendingString:resourceId] stringByAppendingFormat:@"/%@",url];
        case ScryePhotoVersionThumbnail:
            return [[imageURLForVersion stringByAppendingString:resourceId] stringByAppendingFormat:@"/thumbnails/%@",url];
        case ScryePhotoVersionNone: //use version none for web Link
            return  [[[imageURLForVersion stringByAppendingString:resourceId] stringByAppendingString:@"/"]stringByAppendingString:url];
            
        default:
            return nil;
    }
    
}
@end
