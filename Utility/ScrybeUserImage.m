//
//  ScrybeUserImage.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeUserImage.h"

#import "UserManager.h"
#import "AccountManager.h"


@implementation ScrybeUserImage
///////////////////////////////////////////////////////////////////////////////////////////////////

/* //  USER_IMAGE_SIZE_SUFFICES_DICTIONARY = [NSDictionary dictionaryWithObjectsAndKeys:                              
 @"SIZE_22_x_22", @"22x22", @"SIZE_28_x_28", @"28x28"
 @"SIZE_32_x_32", @"32x32", @"SIZE_48_x_48", @"48x48",
 @"SIZE_184_x_184",@"184x184",  nil];*/

+(NSString*) getScrybeUserImageUrl:(NSString*) userId imageSize:(NSString*)size
{
    NSString *url = nil;
   
    if (userId != nil) {
        
        User *user = [[UserManager sharedUserManager] getUserForUserId:userId];
        AccountManager *accountManager = [AccountManager sharedAccountManager];
        
        if ([user.profileImageType integerValue] <= 0 || [user.profileImageVersion integerValue] <= 0) {
            // TODO: instead of loading the default user profile image from web server, use images embedded in the application.
            
            // Load default user profile image.
            url = [NSString stringWithFormat:@"http://%@.s3.amazonaws.com/user-images/default-user/thumbnails/default-user-thumbnail-%@.png",accountManager.amazonWebService.bucketName,size];
        }
        else
        {
            // Load custom user profile image.

            url = [NSString stringWithFormat:@"http://%@.s3.amazonaws.com/user-images/%@/thumbnails/%@-thumbnail-%@-%@.jpg",accountManager.amazonWebService.bucketName,userId,userId,size,user.profileImageVersion];
           }
    }
    return url;
}

-(void) dealloc
{
    [super dealloc];
}
@end
