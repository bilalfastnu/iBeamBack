//
//  SignInView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SignInView.h"

#import "ICONS.h"
#import "ShadowView.h"

@implementation SignInView


@synthesize usernameField, passwordField;
@synthesize signInButton, waitingIndicator;
///////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        applicationNameLabel = [[UILabel alloc] init];
		applicationNameLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:40.0f];
		applicationNameLabel.text = @"iBeamBack";
		
		[self addSubview:applicationNameLabel];
		
		[applicationNameLabel release];

        shadowView = [[ShadowView alloc] init];
 		[self addSubview:shadowView];
		[shadowView release];

        usernameField = [[UITextField alloc] init];
		usernameField.text = @"bilal.nazirahmad@gmail.com";
		usernameField.placeholder = @"Enter email address";
		[usernameField setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:usernameField];
        
        
		passwordField = [[UITextField alloc] init];
		passwordField.secureTextEntry = YES;
		passwordField.text = @"bilal123";
		passwordField.placeholder = @"Password";
        [passwordField setBorderStyle:UITextBorderStyleRoundedRect];        
		[self addSubview:passwordField];
        

        signInButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
		[signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
        [self addSubview:signInButton];
		
		waitingIndicator = [[UIActivityIndicatorView alloc] init];
        waitingIndicator.hidesWhenStopped = YES;
		waitingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:waitingIndicator];
		
        applicationImageView = [[UIImageView alloc] init];
		applicationImageView.image = [UIImage imageNamed:ApplicationIcon];
		[self addSubview:applicationImageView];
		[applicationImageView release];

 
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	applicationImageView.frame = CGRectMake(self.frame.size.width/2.0f-100, self.frame.origin.y+50.0f , 170.0f, 170.0f);
    
	CGRect frame = applicationImageView.frame;
	frame.origin.y+=170.0f;
	applicationNameLabel.frame = CGRectMake(frame.origin.x, frame.origin.y , 300.0f, 130.0f);
	
	shadowView.frame = CGRectMake(self.frame.size.width/2.0f-450/2.0f, frame.origin.y+160.0f , 450.0f, 250.0f);
    
	frame = shadowView.frame;
	
	frame = CGRectMake(frame.origin.x+20.0f, frame.origin.y+30.0f , frame.size.width-40.0f, 30.0f);
	usernameField.frame = frame;
    
	frame.origin.y+=60.0f;
	passwordField.frame = frame;
	
	frame = CGRectMake(frame.origin.x+150.0f+30.0f, frame.origin.y+60.0f ,25.0f, 25.0f);
	waitingIndicator.frame= frame;
	
	frame = CGRectMake(frame.origin.x-20.0f, frame.origin.y+50.0f ,70.0f, 30.0f);
	signInButton.frame = frame;
	
}
///////////////////////////////////////////////////////////////////////////

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [usernameField release];
    [passwordField release];
    [waitingIndicator release];
    
    [super dealloc];
}

@end
