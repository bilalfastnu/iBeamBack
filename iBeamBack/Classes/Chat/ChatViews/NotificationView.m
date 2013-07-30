//
//  NotificationView.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NotificationView.h"
#import "QuartzCore/QuartzCore.h"


#define NOTIFICATION_BACKGROUND_COLOR [UIColor colorWithRed:0.68 green:0.76 blue:0.86 alpha:1.0]

@implementation NotificationView
@synthesize userNameLabel;
@synthesize messageLabel;
@synthesize notifierImageView;
@synthesize notifierId;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
        
		self.backgroundColor = [UIColor lightGrayColor];
		userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 150, 20)];
		messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, 150, 20)];
		
        
        userNameLabel.backgroundColor = [UIColor clearColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        
		userNameLabel.lineBreakMode = UILineBreakModeWordWrap;
		userNameLabel.numberOfLines = 1;
		
		messageLabel.lineBreakMode = UILineBreakModeWordWrap;
		messageLabel.numberOfLines = 4;
        
        notifierImageView = [[TTImageView alloc] initWithFrame:CGRectMake(20, 5, 32, 32)];
        
		notifierId = [[NSString alloc]init];
        self.backgroundColor = NOTIFICATION_BACKGROUND_COLOR;
        
        [self addSubview:userNameLabel];
        [self addSubview:notifierImageView];
        
		[self addSubview:messageLabel];
        
        self.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = 5.0;
        
        
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // NSLog(@"TappedOnNotificationView");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TappedOnNotificationView" object:nil];
}

- (void)dealloc {
    [notifierId release];
    [notifierImageView release];
	[userNameLabel release];
	[messageLabel release];
    [super dealloc];
}


@end
