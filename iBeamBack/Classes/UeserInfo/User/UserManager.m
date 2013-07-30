//
//  UserManager.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "UserManager.h"


@implementation UserManager

@synthesize  currentUser;

///////////////////////////////////////////////////////////////////////////

-(id) init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////

+(UserManager *)sharedUserManager
{
	return (UserManager *)[super sharedInstance];
}

///////////////////////////////////////////////////////////////////////////

-(void) processUsersData:(NSDictionary *)data
{

	NSMutableDictionary *usersProfile = [data objectForKey:@"account_users_global_profiles"];
	
 //NSLog(@"%@",data);
    
    usersGlobalProfiles =[[NSMutableDictionary alloc]init];

	for ( NSString *key in usersProfile)
	{
		User *user  = [[User alloc] initWithUserData:[usersProfile objectForKey:key]];
		
		[usersGlobalProfiles setObject:user forKey:user.userId];
		[user release];
	}

}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark  User Manager public Methodes

-(User*) getUserForUserId:(NSString*) userId
{
    if (userId != nil) {
        
		return [usersGlobalProfiles objectForKey:userId];
	}
	return nil;

}
-(NSNumber *)getImageVersion:(NSString *)userId
{
	if (userId != nil) {
		User *userObj = [usersGlobalProfiles objectForKey:userId];
		return userObj.profileImageVersion;
	}
	return nil;
}

-(NSString *)getFullName:(NSString*)userId
{
	if (userId != nil) {
		User *userObj = [usersGlobalProfiles objectForKey:userId];
		return [[userObj.firstName stringByAppendingString:@" "] stringByAppendingString:userObj.lastName ];
	}
	return nil;
}

-(NSString *)getFirstName:(NSString*)userId
{
	if (userId != nil) {
		User *userObj = [usersGlobalProfiles objectForKey:userId];
		return userObj.firstName;
	}
	return nil;
}

-(NSString *)getLastName:(NSString*) userId
{
	if (userId != nil) {
		User *userObj = [usersGlobalProfiles objectForKey:userId];
		return userObj.lastName;
	}
	return nil;
}

-(NSString *)getCurrentUserId {
    
    return currentUser.userId;
}

///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [currentUser release];
    [usersGlobalProfiles release];
    
    [super dealloc];
}
@end
