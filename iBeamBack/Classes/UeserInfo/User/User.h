//
//  User.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {

    
    NSString *email;
	NSString *userId;
	NSString *firstName,*lastName;
    NSNumber *emailVarified,*signedUp;
    NSNumber *profileImageType,*profileImageVersion;
}
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSNumber *signedUp;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSNumber *emailVarified;
@property (nonatomic, retain) NSNumber *profileImageType;
@property (nonatomic, retain) NSNumber *profileImageVersion;

-(id) initWithUserData:(NSDictionary*)userData;

@end
