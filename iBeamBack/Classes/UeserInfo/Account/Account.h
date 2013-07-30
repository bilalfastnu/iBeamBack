//
//  Account.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject {
    
    NSNumber *paid;
    NSNumber *revision;
    NSNumber *imageType;
    NSString *creatorId;
    NSString *accountId;
    NSString *accountName;
    NSString *accountType;
    NSString *creationDate;
    NSNumber *feedRevision;
    NSNumber *imageVersion;
    NSString *accountStatus;
    NSNumber *processSignIn;
    NSString *userEmailDomain;
}

@property (nonatomic, retain) NSNumber *paid;
@property (nonatomic, retain) NSNumber *revision;
@property (nonatomic, retain) NSNumber *imageType;
@property (nonatomic, retain) NSString *creatorId;
@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *accountName;
@property (nonatomic, retain) NSString *accountType;
@property (nonatomic, retain) NSString *creationDate;
@property (nonatomic, retain) NSNumber *feedRevision;
@property (nonatomic, retain) NSNumber *imageVersion;
@property (nonatomic, retain) NSString *accountStatus;
@property (nonatomic, retain) NSNumber *processSignIn;
@property (nonatomic, retain) NSString *userEmailDomain;

-(id) initWithUserAccountData:(NSDictionary*)accountData;

@end
