//
//  ChatUser.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h" 


@interface ChatUser : NSObject {
	
	NSString * userName;
	UIImage *userProfileImage;
	NSString *userId;
	
	enum  UserStatus status;
	
	
}
@property(nonatomic,retain)NSString *userId;
@property(nonatomic)enum UserStatus status;
@property(nonatomic,retain)	NSString * userName;
@property(nonatomic,retain)UIImage *userProfileImage;



-(id)init;


@end
