//
//  UserManager.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSSingleton.h"

#import "User.h"

@interface UserManager : NSSingleton {
    
    User *currentUser;
    NSMutableDictionary *usersGlobalProfiles;
}

@property (nonatomic, retain) User *currentUser;


//Actions

-(NSString *)getFirstName:(NSString*)userId;
-(NSString *)getLastName:(NSString*)userId;
-(NSString *)getFullName:(NSString *)userId;
-(NSNumber *)getImageVersion:(NSString *)userId;
-(NSString *)getCurrentUserId;
-(User*) getUserForUserId:(NSString*) userId;

+(UserManager *)sharedUserManager;


-(void) processUsersData:(NSDictionary *)data;

@end
