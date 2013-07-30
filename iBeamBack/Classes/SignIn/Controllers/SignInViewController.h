//
//  SignInViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignInDelegate.h"
#import "GroupManager.h"
#import "AccountsRemoteCaller.h"


@class SignInView;
@class GroupRemoteCaller;
@class SignInPHPServerRemoteCaller;
@class SignInJAVAServerRemoteCaller;

@interface SignInViewController : UIViewController<RemoteCallerDelegate,SignInDelegate,GroupsDataProcessorDelegate> {
    
    SignInView *signInView;
    
    AccountsRemoteCaller *accountRemoteCaller;
    
    BOOL isSignedAtFeedServer;
	BOOL isSignedAtPHPServer;
    
    GroupRemoteCaller *groupRemoteCaller;
    SignInPHPServerRemoteCaller *phpServerRemoteCaller;
    SignInJAVAServerRemoteCaller *javaServerRemoteCaller;
    
    id delegate;
}

@property (nonatomic, retain) id delegate;

@end
