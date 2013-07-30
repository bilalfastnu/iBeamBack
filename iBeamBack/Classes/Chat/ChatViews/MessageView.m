//
//  MessageView.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MessageView.h"
#define FONT_SIZE 14

@implementation MessageView
@synthesize balloonView;
@synthesize userImageView;
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
		label = [[UILabel alloc]initWithFrame:CGRectZero ];
		balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
		userImageView = [[TTImageView alloc] initWithFrame:CGRectZero];
        
        
		label = [[UILabel alloc]initWithFrame:CGRectZero ];
		label.backgroundColor =[UIColor clearColor];
		self.tag =0;
		balloonView.tag = 1;
		label.tag =2;
		userImageView.tag=3;
		label.numberOfLines =0;
        
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.font = [UIFont systemFontOfSize:FONT_SIZE];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.autoresizesSubviews = YES;
		[self addSubview:userImageView];
		[self addSubview:balloonView];
		[self addSubview:label];
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

- (void)dealloc {
	[userImageView release];
	[balloonView release];
	[label release];
    [super dealloc];
    
}


@end
