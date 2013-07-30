//
//  AccountManager.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "AccountManager.h"

#import "UserManager.h"
#import "ASObject.h"

@implementation AccountManager

@synthesize userAccount;
@synthesize amazonWebService;

///////////////////////////////////////////////////////////////////////////

-(id) init
{
    self = [super init];
    
    if (self) {

    }
    return self;
    
}
///////////////////////////////////////////////////////////////////////////

+(AccountManager *)sharedAccountManager
{
	return (AccountManager *)[super sharedInstance];
}

///////////////////////////////////////////////////////////////////////////

-(void) initilizeAmazonWebServiceData:(ASObject*) serviceDataObject
{
    NSDictionary *serviceData = [serviceDataObject.properties objectForKey:@"data"];
    NSDictionary *awsData = [serviceData objectForKey:@"aws_data"];
    
    [UserManager sharedUserManager].currentUser = [[User alloc] initWithUserData:[serviceData objectForKey:@"user"]];
    
   // [[DateManager sharedDateManager] setTime:[serviceData objectForKey:@"time"]];
    
    NSArray *array = [serviceData objectForKey:@"user_accounts"];
    //NSDictionary *userAccountData = [accountData objectAtIndex:0];
    userAccount = [[Account alloc] initWithUserAccountData:[array objectAtIndex:0]];
    
    amazonWebService = [[AmazonWebServiceData alloc] initWithAmazonWebServiceData:awsData withAccountId:userAccount.accountId];

}
///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [userAccount release];
    [amazonWebService release];
    
    [super dealloc];
}
@end
