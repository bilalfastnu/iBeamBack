//
//  SignInDelegate.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SignInDelegate <NSObject>

@required

-(void) didSignInSuccessfullyWithObject:(NSString*)object;
-(void) didSignInFailWithError:(NSError*)error;

@end
