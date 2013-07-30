//
//  Account.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Account.h"


@implementation Account

@synthesize paid, revision, imageType, creatorId;
@synthesize accountId, accountName, accountType;
@synthesize creationDate, feedRevision, imageVersion;
@synthesize accountStatus,processSignIn,userEmailDomain;

///////////////////////////////////////////////////////////////////////////

-(id) initWithUserAccountData:(NSDictionary*)accountData
{
    self = [super init];
    
    if (self) {

        paid = [[accountData objectForKey:@"paid"] retain];
        revision = [[accountData objectForKey:@"revision"] retain];
        imageType = [[accountData objectForKey:@"image_type"] retain];
        creatorId = [[accountData objectForKey:@"creator_id"] retain];
        accountId = [[accountData objectForKey:@"account_id"] retain];
        accountName = [[accountData objectForKey:@"account_name"] retain];
        accountType = [[accountData objectForKey:@"account_type"] retain];
        creationDate = [[accountData objectForKey:@"creation_date"] retain];
        feedRevision = [[accountData objectForKey:@"feed_revision"] retain];
        imageVersion = [[accountData objectForKey:@"image_version"] retain];
        accountStatus = [[accountData objectForKey:@"account_status"] retain];
        processSignIn = [[accountData objectForKey:@"process_sign_in"] retain];
        userEmailDomain = [[accountData objectForKey:@"user_email_domain"] retain];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [paid release];
    [revision release];
    [imageType release];
    [creatorId release];
    [accountId release];
    [accountName release];
    [accountType release];
    [creationDate release];
    [feedRevision release];
    [imageVersion release];
    [accountStatus release];
    [processSignIn release];
    [userEmailDomain release];
    
    [super dealloc];
}
@end
