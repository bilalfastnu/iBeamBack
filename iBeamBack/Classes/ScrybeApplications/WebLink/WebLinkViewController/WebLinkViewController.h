//
//  WebViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@class FeedItem;
@class WebLink;
@class BadgeView;
@class ResourceLink;
@class ResourceHeaderView;
@class FeedSplitViewController;

@interface WebLinkViewController : TTWebController<UINavigationControllerDelegate,UIWebViewDelegate> {
    
    BadgeView *badgeView;
    UIToolbar *myToolbar;
    WebLink *webLinkFeedItem;
    ResourceLink *resourceLink;
    ResourceHeaderView *headerView;
    FeedSplitViewController *parentDelegate;
}

-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj;


@end
