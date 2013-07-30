//
//  User.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "User.h"


@implementation User

@synthesize email, firstName, lastName,signedUp;
@synthesize userId,profileImageVersion, emailVarified,profileImageType;

///////////////////////////////////////////////////////////////////////////

-(id) initWithUserData:(NSDictionary*)userData
{
    self = [super init];
    
    if (self) {

        email   = [[userData objectForKey:@"email"] retain];
		userId	  = [[userData objectForKey:@"user_id"] retain];
        firstName = [[userData objectForKey:@"first_name"] retain];
		lastName  = [[userData objectForKey:@"last_name"] retain];
		signedUp  = [[userData objectForKey:@"signed_up"] retain];
        emailVarified = [[userData objectForKey:@"email_verified"] retain];
		profileImageVersion = [[userData objectForKey:@"profile_image_version"] retain];
        profileImageType = [[userData objectForKey:@"profile_image_type"] retain];
		
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [email release];
    [userId release];
    [firstName release];
    [lastName release];
    [signedUp release];
    [emailVarified release];
    [profileImageType release];
    [profileImageType release];
    
    
    [super dealloc];
}
@end
