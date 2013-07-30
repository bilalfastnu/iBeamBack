//
//  ScrybeImageDetailViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrybePhotoView.h"
#import "Tool.h"
#import "DrawingView.h"
#import "CustomToolBar.h"

#import "FeedItem.h"
#import "ResourceLink.h"


@class PhotoSet;


@interface ScrybeImageDetailViewController : TTPhotoViewController<ScrybeImageViewDelegate, ToolDelegate, DudelViewDelegate, 
UITableViewDelegate, UITableViewDataSource> {

    
    UIViewController *managerViewControllerDelegate;
    CustomToolBar *toolBar;
    
    BOOL shouldShowSnippetRect;
    
    NSMutableDictionary *snippetDictionary;
    
    /////////////////////// Drawing //////////////////
    
    id <Tool> currentTool;
	DrawingView *dudelView;
	UIColor *strokeColor;
	UIColor *fillColor;
	CGFloat strokeWidth;
    
    //UITableView *shapesTableView;
    UIPopoverController *shapesPopOverOptions;

    ResourceLink *resourceLink;
    FeedItem *feedItem;
}

@property (nonatomic, assign)UIViewController *managerViewControllerDelegate;

@property (nonatomic, retain) DrawingView *dudelView;
@property (retain, nonatomic) id <Tool> currentTool;
@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGFloat strokeWidth;

- (void)touchFreehandItem:(id)sender;
- (void)touchEllipseItem:(id)sender;
- (void)touchRectangleItem:(id)sender;
- (void)touchLineItem:(id)sender;
- (void)touchPencilItem:(id)sender;


-(void)showSnippetForPhoto:(id<TTPhoto>)photo snippetData:(NSDictionary*)snippetData;
-(void)annotateSnippetImage:(UIImage*)image forPhoto:(id<TTPhoto>)photo;


-(id)initWithFeedItem:(FeedItem*)feedItem ResourceLink:(ResourceLink*)p_resourceLink;
@end
