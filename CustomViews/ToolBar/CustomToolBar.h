//
//  CustomToolBar.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BadgeView.h"

@interface CustomToolBar : UIView {
    
    BadgeView *badgeView;
    UIButton *editButton;
    UIButton *commentButton;
    
    UIButton *drawingShapes;
}

@property (nonatomic, retain) BadgeView *badgeView;
@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIButton *drawingShapes;
@end
