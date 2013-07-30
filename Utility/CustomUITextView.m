//
//  CustomUITextView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "CustomUITextView.h"

@implementation CustomUITextView

@synthesize placeholder, placeholderColor;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self setPlaceholder:@""];
	    [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
		self.font = [UIFont systemFontOfSize:14];

    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)textChanged:(NSNotification*)notif {
    if ([[self placeholder] length]==0)
        return;
    if ([[self text] length]==0) {
        [[self viewWithTag:999] setAlpha:1];
    } else {
        [[self viewWithTag:999] setAlpha:0];
    }
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if ([[self placeholder] length]>0) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 0, 0)];
		[l setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        [l setTextColor:self.placeholderColor];
        [l setText:self.placeholder];
        [l setAlpha:0];
        [l setTag:999];
        [self addSubview:l];
        [l sizeToFit];
        [self sendSubviewToBack:l];
        [l release];
    }
    if ([[self text] length]==0 && [[self placeholder] length]>0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
