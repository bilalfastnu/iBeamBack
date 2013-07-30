//
//  FeedSplitViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGSplitViewController.h"

@class MainHeaderView;
@class FeedTableViewController;
@class SidebarTableViewController;

@interface FeedSplitViewController : MGSplitViewController<UIPopoverControllerDelegate,MGSplitViewControllerDelegate> {
    
    FeedTableViewController *feedTableViewController;
	SidebarTableViewController *sidebarTableViewController;
    
    MGSplitViewController *splitController;
    
    UIPopoverController *popoverController;
    
    id detailItem;
    
    MainHeaderView *mainHeaderView;
    

    id detailedViewController;
    id masterViewController;
}

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) MGSplitViewController *splitController;

//Actions
-(void)closeApplication;

- (void)toggleMasterView:(id)sender;
- (void)toggleVertical:(id)sender;
- (void)toggleDividerStyle:(id)sender;
- (void)toggleMasterBeforeDetail:(id)sender;


@end
