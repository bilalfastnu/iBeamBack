//
//  SignInJAVAServerRemoteCaller.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemoteCaller.h"
#import "SignInDelegate.h"

@interface SignInJAVAServerRemoteCaller : RemoteCaller<RemoteCallerDelegate>  {
    
    NSObject <SignInDelegate> *signInDelegate;
}
@property (nonatomic, retain) NSObject <SignInDelegate> *signInDelegate;

//Actions
-(void)SignInWithUserName:(NSString *)userName AndPassword:(NSString *)pass;

@end
