//
//  FeedTableViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemoteCaller.h"

@class FeedItem;
@class FeedSplitViewController;
@class ConversationsRemoteCaller;

@interface CommentsTableViewController : UITableViewController<RemoteCallerDelegate> {
    
    
    CGFloat cellMaxWidth;
    FeedItem *feedItem;
    UIBarButtonItem *commentButton;
    UIBarButtonItem *closeButton;
    FeedSplitViewController *parentDelegate;
    
    id managerViewControllerDelegate;
    
    NSMutableArray *commentsArray;
    NSMutableArray *allCommentsArray;
    BOOL isMoreCommentCell;
    int commentsCount;
    
    ConversationsRemoteCaller *conversationsRemoteCaller;
    
    UIActivityIndicatorView *loadingInIndicator;
}
@property (nonatomic, assign) id managerViewControllerDelegate;
 
-(id) initWithParentViewController:(FeedSplitViewController*)parentVC withFeedItem:(id)feedItemData withMaxWidth:(CGFloat)width withCommentActions:(NSInteger) action;


@end
