//
//  UserListView.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/22/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "UserListView.h"

#define FONT_SIZE 14.0
@implementation UserListView
@synthesize userName;
@synthesize profileImageView;
@synthesize statusImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        profileImageView = [[TTImageView alloc] initWithFrame:CGRectZero];
        statusImageView= [[UIImageView alloc] initWithFrame:CGRectZero];
        userName = [[UILabel alloc]initWithFrame:CGRectZero];
        
        userName.backgroundColor =[UIColor clearColor];
		self.tag =0;
		profileImageView.tag = 1;
		userName.tag =2;
		statusImageView.tag=3;
		userName.numberOfLines =0;
        
		userName.lineBreakMode = UILineBreakModeWordWrap;
		userName.font = [UIFont systemFontOfSize:FONT_SIZE];

        
        
        
        [self addSubview:profileImageView];
        [self addSubview:statusImageView];
        [self addSubview:userName];
    }
    return self;
}

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
    [profileImageView release];
    [statusImageView release];
    [userName release];
    [super dealloc];
}

@end
