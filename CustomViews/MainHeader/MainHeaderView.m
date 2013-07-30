//
//  MainHeaderView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MainHeaderView.h"

#import "ICONS.h"

@implementation MainHeaderView

///////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor darkGrayColor];
		
        /*searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(250, 15, 250, 25)];
		
        for (UIView *view in searchBar.subviews)
		{
			if ([view isKindOfClass:NSClassFromString
				 (@"UISearchBarBackground")])
			{
				[view removeFromSuperview];
				break;
			}
		}
		//[self addSubview:searchBar];
         //[searchBar release];*/
        
		applicationNameLabel = [[UILabel alloc] init];
		applicationNameLabel.backgroundColor = [UIColor clearColor];
		applicationNameLabel.textColor = [UIColor whiteColor];
		applicationNameLabel.text = @"iBeamBack";
        [self addSubview:applicationNameLabel];
        [applicationNameLabel release];
		
		homeButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
		homeButton.titleLabel.font = [UIFont systemFontOfSize:14];
		homeButton.backgroundColor = [UIColor clearColor];
		[homeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
		UIImage *buttonImageNormal = [UIImage imageNamed:HomeButtonIcon];
		
		UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		[homeButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
		
		[self addSubview:homeButton];

    }
    return self;
}
///////////////////////////////////////////////////////////////////////////
-(void) layoutSubviews
{
	[super layoutSubviews];
	
	homeButton.frame = CGRectMake(5.0, 8.0, 35.0, 35.0);
	applicationNameLabel.frame = CGRectMake(40.0, 8.0, 90.0, 30.0);
	
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
