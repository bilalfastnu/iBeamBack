//
//  PostCommentViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConversationsRemoteCaller.h"

@class FeedItem;
@class ResourceLink;
@class CustomUITextView;
@class FeedSplitViewController;
@class ConversationsRemoteCaller;


@interface PostCommentViewController : UIViewController<RemoteCallerDelegate>  {
    
    
    FeedItem *feedItem;
    ResourceLink *resourceLink;
    CustomUITextView *commentBox;
    FeedSplitViewController *parentDelegate;
    ConversationsRemoteCaller *remoteCaller;
}

-(id) initWithParentViewController:(FeedSplitViewController*)parentVC withFeedItem:(id)feedItemData resourceLink:(ResourceLink*)p_resourceLink withCommentActions:(NSInteger) action;

@end
