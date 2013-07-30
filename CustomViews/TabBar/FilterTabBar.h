//
//  FilterTabBar.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"

@interface FilterTabBar : UITabBar {
    
    UIButton * filterButton;
    

    
    BadgeView *badgeView;
}

@property (nonatomic,retain) UIButton *filterButton;

@property (nonatomic,retain) BadgeView *badgeView;

@end
