//
//  SignInPHPServerRemoteCaller.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemoteCaller.h"
#import "SignInDelegate.h"

@class AccountsRemoteCaller;

@interface SignInPHPServerRemoteCaller : NSObject<RemoteCallerDelegate> {
    
    AccountsRemoteCaller *accountRemoteCaller;
    NSObject <SignInDelegate> *signInDelegate;
    double startMiliseconds;
}
@property (nonatomic, retain) NSObject <SignInDelegate> *signInDelegate;

//Actions
-(void)SignInWithUserName:(NSString *)userName AndPassword:(NSString *)password;

@end
