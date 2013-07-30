//
//  MilestoneViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/22/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>



@class FeedItem;
@class Milestone;
@class ResourceLink;
@class TKCalendarMonthView;
@class ResourceHeaderView;
@class FeedSplitViewController;


@interface MilestoneViewController : UIViewController<UINavigationControllerDelegate> {
    
    Milestone *milestoneFeedItem;
    ResourceLink *resourceLink;
    ResourceHeaderView *headerView;
    FeedSplitViewController *parentDelegate;

    TKCalendarMonthView *calendar;	
}

-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj;

@end
