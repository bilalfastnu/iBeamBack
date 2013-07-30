//
//  SignInView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShadowView;

@interface SignInView : UIView {
    
    ShadowView *shadowView;
	UIButton *signInButton;
    UITextField *usernameField;
	UITextField *passwordField;
	UILabel *applicationNameLabel;
	UIImageView *applicationImageView;
	UIActivityIndicatorView *waitingIndicator;
}

@property (nonatomic, retain) UIButton *signInButton;
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIActivityIndicatorView *waitingIndicator;

@end
