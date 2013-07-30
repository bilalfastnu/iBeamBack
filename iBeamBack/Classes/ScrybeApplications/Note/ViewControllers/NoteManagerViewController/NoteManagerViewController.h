//
//  NoteManagerViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"


@class FeedItem;
@class CustomToolBar;
@class ResourceLink;
@class FeedSplitViewController;


@interface NoteManagerViewController :  UIViewController<UINavigationControllerDelegate> {
    
    UISegmentedControl    * segmentedControl;
	UIViewController      * activeViewController;
	NSArray               * segmentedViewControllers;
    
    CustomToolBar * toolBar;
    ResourceLink *resourceLink;
    Note *feedItem;
    FeedSplitViewController *parentDelegate;
    
    BOOL shouldLoadSubResource;
    BOOL isShowAllComments;
    
}
@property (nonatomic, retain)    CustomToolBar * toolBar;

-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj withCommentActions:(NSInteger) action;

@end
