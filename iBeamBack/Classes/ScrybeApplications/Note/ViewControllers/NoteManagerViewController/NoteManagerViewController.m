//
//  NoteManagerViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteManagerViewController.h"

#import "NSArray+PerformSelector.h"

#import "ICONS.h"
#import "CustomToolBar.h"
#import "NoteViewController.h"
#import "FeedSplitViewController.h"
#import "ScrybeThumbnailViewController.h"
#import "ResourceLink.h"
#import "NoteApplicationState.h"


#import "ScrybeResourceImage.h"
#import "Conversation.h"

#import "Photo.h"
#import "Resource.h"
#import "ResourcePath.h"
#import "ResourceLink.h"
///////////////////////////////////////////////////////////////////////////////////////////////////

@interface NoteManagerViewController ()

@property (nonatomic, retain, readwrite) UISegmentedControl * segmentedControl;
@property (nonatomic, retain, readwrite) UIViewController            * activeViewController;
@property (nonatomic, retain, readwrite) NSArray                     * segmentedViewControllers;

- (void)didChangeSegmentControl:(UISegmentedControl *)control;
- (NSArray *)createSegmentedControllers;


//////////////////////////////////////////
// add private methods
-(BOOL)shouldOpenSubResource;
-(NSDictionary*)getDiictonaryObjectForKey:(NSString*)key 
                                    value:(id)value fromItemsArray:(NSArray*)items;

-(void)configureViewStateFromState:(NoteAppState)fromState toViewState:(NoteAppState)toState;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NoteManagerViewController


@synthesize toolBar;
@synthesize segmentedControl, activeViewController, segmentedViewControllers;

///////////////////////////////////////////////////////////////////////////////////////////////////

-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj withCommentActions:(NSInteger) action
{
    self = [super init];
    if (self) {

        isShowAllComments = action == SHOW_ALL_COMMENTS ? YES : NO ;
        feedItem = (Note*) feedItemObject;
        parentDelegate = parentVC;
        resourceLink = [resourceLinkObj retain];
 
        if ([self shouldOpenSubResource]) {
            shouldLoadSubResource = YES;
        }else
            shouldLoadSubResource = NO;
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(updateCount:)
		 name:@"Update Comments Count"
		 object:nil ];

    }
    return self;
}
/*
-(Photo*)getTargetPhoto
{
    Resource *resource = [resourceLink.resourcePath.hierarchy objectAtIndex:1];
    
    NSDictionary *resourceObject = [self getDiictonaryObjectForKey:@"id" value:resource.uid fromItemsArray:feedItem.customPropertiesArray];
    NSLog(@"Resource Object:%@",resourceObject);
    
    NSString *urlLarge = [ScrybeResourceImage getScrybeImageForURLVersion:TTPhotoVersionLarge withResourceId:feedItem.resourceId withResourceUrl:[resourceObject valueForKey:@"original_name"]];
    
    NSString *urlSmall = [ScrybeResourceImage getScrybeImageForURLVersion:TTPhotoVersionSmall withResourceId:feedItem.resourceId withResourceUrl:[resourceObject valueForKey:@"preview_name"]];
    
    NSString *urlThumbnail = [ScrybeResourceImage getScrybeImageForURLVersion:TTPhotoVersionThumbnail withResourceId:feedItem.resourceId withResourceUrl:[resourceObject valueForKey:@"thumbnail_name"]];
    
    
    Photo *photo = [[Photo alloc] initWithCaption:[resourceObject valueForKey:@"name"] urlLarge:urlLarge urlSmall:urlSmall urlThumb:urlThumbnail size:CGSizeZero photoID:[resourceObject objectForKey:@"id"] itemID:[resourceObject objectForKey:@"item_id"]];
    
    return photo;
    
}

*/
#pragma mark -
#pragma mark View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.activeViewController viewWillAppear:animated];
    
    self.navigationController.delegate = self;

    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //[self.navigationController.navigationBar addSubview:toolBar];
	
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.activeViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.activeViewController viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect frame = self.navigationController.navigationBar.frame;
    toolBar.frame = CGRectMake((frame.size.width/2.0)+100, frame.origin.y, 200, frame.size.height-5);
    
    NSArray * viewControllers = [self segmentedViewControllers];
    
    for (UIViewController *viewController in viewControllers) {
        [viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
        
    }
    
    switch (interfaceOrientation) {
            
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
            
            toolBar.commentButton.hidden = NO;
            toolBar.badgeView.hidden = NO;
            
			break;
			
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationLandscapeLeft:
            
			toolBar.badgeView.hidden = YES;
			toolBar.commentButton.hidden = YES;
			
			break;
	}
	
    
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) updateCount:(id) sender
{
    feedItem.conversationsCount+=1;
    toolBar.badgeView.value = feedItem.conversationsCount;
}
////////////////////////////////////////////////////
#pragma -
#pragma Private Methods


-(NSDictionary*)getDiictonaryObjectForKey:(NSString*)key value:(id)value fromItemsArray:(NSArray*)dictionaryItems
{
    for(int i = 0 ; i < [dictionaryItems count] ; i++)
    {
        NSDictionary *item = [dictionaryItems objectAtIndex:i];
        id tmpValue = [item objectForKey:key];
        if ([tmpValue isEqual:value]) {
            return item;
        }
    }
    return nil;
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (shouldLoadSubResource) {
        UIViewController *thumbsViewController = [self.segmentedViewControllers objectAtIndex:1];
        if ([thumbsViewController respondsToSelector:@selector(moveToDetailPhoto:)]) {
            
            
            Resource *resource = [resourceLink.resourcePath.hierarchy objectAtIndex:1];
            NSDictionary *resourceObject = [self getDiictonaryObjectForKey:@"id" value:resource.uid fromItemsArray:feedItem.customPropertiesArray];
            
            NSString *photo_Id = [resourceObject objectForKey:@"id"]; //[self getTargetPhoto];
            [(ScrybeThumbnailViewController*)thumbsViewController moveToDetailPhoto:photo_Id];
        }
        
        shouldLoadSubResource = NO;
    }
    [self.activeViewController viewDidAppear:animated];
    
    //to open popover automatically
    if (isShowAllComments) {
        [self performSelector:@selector(showCommentPopover:) withObject:toolBar.commentButton];
        isShowAllComments = NO;
    }

}	


-(BOOL)shouldOpenSubResource
{
    // if contains info for subresource
    NSLog(@"Resource Heirarchy count:%d",[resourceLink.resourcePath.hierarchy count]);
    if (([resourceLink.resourcePath.hierarchy count] > 1) 
        && (resourceLink.collaborationInfo == nil)) {
        
        return YES;
    }
    return NO;
}




#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.segmentedViewControllers = [self createSegmentedControllers];
	
    NSArray * segmentTitles = [self.segmentedViewControllers arrayByPerformingSelector:@selector(title)];
	
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTitles];
    
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
    [self.segmentedControl addTarget:self
                              action:@selector(didChangeSegmentControl:)
                    forControlEvents:UIControlEventValueChanged];
	
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl release];
	
    
    
    ///////////////////////// toolbar //////////////////////////////
    toolBar = [[CustomToolBar alloc] initWithFrame:CGRectZero];
    toolBar.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolBar.commentButton.frame = CGRectMake(150, 0, 30.0, 40.0);
    
    [toolBar.commentButton setImage:[UIImage imageNamed:CommentWhitIcon] forState:UIControlStateNormal];
    [toolBar.commentButton addTarget:self action:@selector(showCommentPopover:) forControlEvents:UIControlEventTouchUpInside];

    
    [toolBar addSubview:toolBar.commentButton];
    
    toolBar.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(165, -8, 35, 35)];
	toolBar.badgeView.fillColor = [UIColor blueColor];
    toolBar.badgeView.value = feedItem.conversationsCount;
    
    [toolBar addSubview:toolBar.badgeView];
    
  
    if ([self shouldOpenSubResource]) {
        self.segmentedControl.selectedSegmentIndex = 1;
        
 
    }else
            self.segmentedControl.selectedSegmentIndex = 0;
    
    [self didChangeSegmentControl:self.segmentedControl]; // kick everything off
    
    /////////////////////////////////////////////////////////////////////
       
}

- (NSArray *)createSegmentedControllers {
	
	ScrybeThumbnailViewController *imageGalleryViewController = [[ScrybeThumbnailViewController alloc] initWithParentViewController:self withNoteObject:feedItem resourceLink:resourceLink];
    
    NoteViewController * noteViewController = [[NoteViewController alloc] initWithParentViewController:self withNoteObject:feedItem resourceLink:resourceLink];
	
    NSArray * controllers = [NSArray arrayWithObjects:noteViewController, imageGalleryViewController, nil];
	
    [noteViewController release];
    [imageGalleryViewController release];
	
    return controllers;
}
#pragma mark -
#pragma mark tool bar button handler

-(void) editNote:(id) sender
{
    
}
-(void) showCommentPopover:(id) sender
{
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sender];
	[[parentDelegate popoverController] presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
    [barButton release];
}

#pragma mark -
#pragma mark Segment control

- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    if (self.activeViewController) {
        [self.activeViewController viewWillDisappear:NO];
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController viewDidDisappear:NO];
    }
	NSLog(@"segment control index:%d",control.selectedSegmentIndex);
    self.activeViewController = [self.segmentedViewControllers objectAtIndex:control.selectedSegmentIndex];
	if (control.selectedSegmentIndex == 0) {
     [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:NOTE_VIEW];
     }
     else {
     [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:THUMB_VIEW];
     
     }
	
    [self.activeViewController viewWillAppear:NO];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController viewDidAppear:NO];
    
    NSString * segmentTitle = [control titleForSegmentAtIndex:control.selectedSegmentIndex];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:segmentTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate control

// Required to ensure we call viewDidAppear/viewWillAppear on ourselves (and the active view controller)
// inside of a navigation stack, since viewDidAppear/willAppear insn't invoked automatically. Without this
// selected table views don't know when to de-highlight the selected row.

/**/
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidAppear:animated];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
	
	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
            NSLog(@"FORWARD");
        } else {
            NSLog(@"Note BACKWARD");
            // Do exciting back button pressed stuff here.
			[parentDelegate closeApplication];
        }
    }
	
}
#pragma -
#pragma mark collaboration


-(void)openSnippetCollaboration:(Conversation*)p_conversation
{
    NoteAppState currentState = [[NoteApplicationState sharedNoteApplicationState] getNoteAppState];

    
    ResourceLink *commentResourceLink = p_conversation.resourceLink;
    if([commentResourceLink.collaborationInfo.snippetData.type isEqualToString:IMAGE_SNIPPET])
    {
        [self configureViewStateFromState:currentState toViewState:IMAGE_DETAIL_VIEW];
		[[self.segmentedViewControllers objectAtIndex:1] performSelector:
		 @selector(annotateImageSnippet:) withObject:commentResourceLink.collaborationInfo.snippetData];

    }else if([commentResourceLink.collaborationInfo.snippetData.type isEqualToString:NOTE_SNIPPET]){
        [self configureViewStateFromState:currentState toViewState:NOTE_VIEW];
		[[self.segmentedViewControllers objectAtIndex:0] performSelector:
		 @selector(annotateToTextSnippet:) withObject:commentResourceLink.collaborationInfo.snippetData];

    }
}



#pragma mark -
#pragma mark Managing the View State

-(void)configureViewStateFromState:(NoteAppState)fromState toViewState:(NoteAppState)toState{
	
	if (fromState == NOTE_VIEW) {
		
		switch (toState) {
			case NOTE_VIEW:
				
				break;
			case IMAGE_DETAIL_VIEW:
				
				
				[self.segmentedControl setSelectedSegmentIndex:1];
                /*
				[[self.segmentedViewControllers objectAtIndex:1] performSelector:@selector(thumbsViewController:didSelectPhoto:) 
                                                                      withObject:[self.segmentedViewControllers objectAtIndex:1] withObject:nil];
                
				[[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];
                */
				// TODO: push PhotoView Controller to the image
				break;
			default:
				break;
		}
		
	}else if (fromState == THUMB_VIEW) {
		
		switch (toState) {
			case NOTE_VIEW:
				[self.segmentedControl setSelectedSegmentIndex:0];
				break;
			case IMAGE_DETAIL_VIEW:
				/*
				[[self.segmentedViewControllers objectAtIndex:1] performSelector:@selector(thumbsViewController:didSelectPhoto:) 
																	  withObject:[self.segmentedViewControllers objectAtIndex:1] withObject:nil];
                
				[[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];
                 */
				// TODO: push PhotoViewController here
				break;
			default:
				break;
		}
		
	}else if (fromState == IMAGE_DETAIL_VIEW) {
		
		switch (toState) {
			case NOTE_VIEW:
				[self.navigationController popViewControllerAnimated:YES];
				[self.segmentedControl setSelectedSegmentIndex:0];
				break;
			case IMAGE_DETAIL_VIEW:
				/*
				[[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];
                */
				// TODO: push PhotoView Controller to the image
				
				break;
				
			default:
				break;
		}
		
	}
}

@end

