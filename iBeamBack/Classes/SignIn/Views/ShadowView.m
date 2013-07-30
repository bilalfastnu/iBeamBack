//
//  ShadowView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ShadowView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ShadowView

///////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
		[self setAlpha:1];
		[[self layer] setCornerRadius:8];
		[[self layer] setMasksToBounds:NO]; 
		[[self layer] setShadowColor:[UIColor blackColor].CGColor];
		[[self layer] setShadowOpacity:1.f];
		[[self layer] setShadowRadius:10.0f];
		[[self layer] setShadowOffset:CGSizeMake(0, 3)];

    }
    return self;
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
    [super dealloc];
}

@end
