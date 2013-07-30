//
//  NoteViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoteRemoteCaller.h"

#import <Three20/Three20.h>


@class FeedItem;
@class ResourceLink;
@class ResourceHeaderView;

@interface NoteViewController : TTWebController<RemoteCallerDelegate> {
    
    
    FeedItem *noteFeedItem;
    ResourceLink *resourceLink;
    ResourceHeaderView *headerView;
	NoteRemoteCaller *noteRemoteCaller;
    NSString *conntentHtml;
}

- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem resourceLink:(ResourceLink*)resourceLinkObj;

@end
