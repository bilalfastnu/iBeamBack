//
//  ScrybeThumbnailViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrybeImageDetailViewController.h"
#import "Note.h"
#import "ResourceLink.h"

@class FeedItem;

@interface ScrybeThumbnailViewController : TTThumbsViewController<TTThumbsViewControllerDelegate> {
    
    
    PhotoSet *_photoSet;
    
   	Note *noteItem;
    
    ScrybeImageDetailViewController *imageDetailViewController;
    
    UIViewController * managingViewController;
   
    BOOL isAlreadyVisited;
    
    ResourceLink *resourceLink;
    
}
@property (nonatomic, retain) UIViewController     * managingViewController;
@property (nonatomic, retain) ScrybeImageDetailViewController *imageDetailViewController;

@property (nonatomic, assign) Note *noteItem;

- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem;
-(void)processImagesArray:(NSArray*)imagesArray;

- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem resourceLink:(ResourceLink*)resourceLinkObj;

-(void)moveToDetailPhoto:(NSString*)photoId;

@end
