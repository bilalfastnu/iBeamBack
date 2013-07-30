//
//  FeedTableViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>
#import "ChatViewController.h"
#import "FilterTabBar.h"

@class FilterTabBar;

@interface FeedTableViewController : TTTableViewController<UITabBarDelegate> {
       
    FilterTabBar *filterTabBar;
    /////////////////////////////chat variables
    ChatViewController *chatVC;
    
    ChatSession *notifSession;
    //////////////////////////////

}

@property (nonatomic, retain) FilterTabBar *filterTabBar;

@end
