//
//  FilterTabBar.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FilterTabBar.h"

#import "ICONS.h"

@implementation FilterTabBar

@synthesize filterButton;
@synthesize badgeView;
///////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UITabBarItem *allBarButton = [[UITabBarItem alloc] initWithTitle:@"All" image:
                                      [UIImage imageNamed:AllFeedIcon] tag:0];
		UITabBarItem *noteBarButton = [[UITabBarItem alloc] initWithTitle:@"Notes & Images" image:
                                       [UIImage imageNamed:NotePadIcon] tag:1];
		UITabBarItem *messageBarButton = [[UITabBarItem alloc] initWithTitle:@"Messages" image:
                                          [UIImage imageNamed:MessageIcon] tag:2];
		UITabBarItem *webLinkBarButton = [[UITabBarItem alloc] initWithTitle:@"WebLinks" image:
                                       [UIImage imageNamed:WebLinkIcon] tag:3];
		UITabBarItem *milestoneBarButton = [[UITabBarItem alloc] initWithTitle:@"Milestones" image:
                                       [UIImage imageNamed:ListIcon] tag:4];
        UITabBarItem *chatBarButton = [[UITabBarItem alloc] initWithTitle:@"Chat" image:
                                       [UIImage imageNamed:ChatIcon] tag:5];
		
		self.items = [NSArray arrayWithObjects:allBarButton,noteBarButton,
                      messageBarButton,webLinkBarButton,milestoneBarButton,chatBarButton,nil];
		
		
		[allBarButton release];
		[noteBarButton release];
		[messageBarButton release];
		[webLinkBarButton release];
		[milestoneBarButton release];
        [chatBarButton release];
		
		//custom ButtonrefreshIcon
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
		refreshButton.frame = CGRectMake(700, -10, 70.0, 70.0);
		[refreshButton setShowsTouchWhenHighlighted:YES];
		[refreshButton setImage:[UIImage imageNamed:refreshIcon] forState:UIControlStateNormal];
		[self addSubview:refreshButton];
		
        //
		filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
		filterButton.frame = CGRectMake(0, -10, 70.0, 70.0);
        [filterButton setShowsTouchWhenHighlighted:YES];
		[filterButton setImage:[UIImage imageNamed:FilterIcon] forState:UIControlStateNormal];
        
		[self  addSubview:filterButton];
      
          
        badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(675,-2,30.0, 30.0)];
        badgeView.fillColor = [UIColor blueColor];
        badgeView.hidden = YES;
        [self addSubview:badgeView];
        
        ///////////////////////////////////////////////////////

        

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
    [badgeView release];
    [super dealloc];
}

@end
