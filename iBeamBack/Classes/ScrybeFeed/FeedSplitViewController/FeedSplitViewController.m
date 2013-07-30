//
//  FeedSplitViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedSplitViewController.h"

#import "FeedManager.h"
#import "URLParser.h"
#import "APPLICATIONS.h"
#import "ResourceLink.h"
#import "Resource.h"
#import "FeedItem.h"
#import "ResourcePath.h"
#import "MainHeaderView.h"

#pragma mark-
#pragma Applications View Controllers

#import "FeedTableViewController.h"
#import "CommentsTableViewController.h"
#import "NoteManagerViewController.h"
#import "SidebarTableViewController.h"
//
#import "NoteManagerViewController.h"
#import "CommentsTableViewController.h"
//
#import "WebLinkViewController.h"
//
#import "MilestoneViewController.h"
//
#import "PostCommentViewController.h"



@implementation FeedSplitViewController

@synthesize popoverController, detailItem,splitController;
///////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(resourceTaped:)
		 name:@"ResourceTaped"
		 object:nil ];

    }
    return self;
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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    feedTableViewController = [[FeedTableViewController alloc] init];
	sidebarTableViewController = [[SidebarTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
	self.masterViewController = sidebarTableViewController;
	self.detailViewController = feedTableViewController;
	
    self.delegate = self;
    
	sidebarTableViewController.title = @"Master";
    feedTableViewController.title = @"Feed";

    [feedTableViewController.filterTabBar.filterButton addTarget:self action:@selector(openFilterPopover:)
                        forControlEvents:UIControlEventTouchUpInside];

	UINavigationController *detailedController = [[UINavigationController alloc]
                                                  initWithRootViewController:feedTableViewController];
    
	UINavigationController *masterController = [[UINavigationController alloc] 
                                                initWithRootViewController:sidebarTableViewController];
    masterController.navigationBar.barStyle = UIBarStyleBlack;
	self.viewControllers = [NSArray arrayWithObjects:masterController,detailedController,nil];
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
	
	mainHeaderView = [[MainHeaderView alloc] init];
	mainHeaderView.frame = CGRectMake(0.0, 0.0, screenBounds.size.width, MAIN_HEADER_VIEW_HEIGHT);
	[self.view addSubview:mainHeaderView];
    
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark  MyTTStyledTextLinkLabel delegate

-(void)closeApplication {
	
	[self viewWillDisappear:YES];
	[super setSplitPosition:FEED_MASTER_VIEW_WIDTH];
    [self performSelector:@selector(toggleMasterBeforeDetail:)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabBar" object:nil];
	[[self.viewControllers objectAtIndex:0]popViewControllerAnimated:YES];	
	[[self.viewControllers objectAtIndex:1]popViewControllerAnimated:YES];	
	[self viewWillAppear:YES];
}



///////////////////////////////////////////////////////////////////////////
-(ResourceLink*) makeResourceLinkForHierarchy:(NSMutableArray*)hierarchy withResourceId:(id)resourceId withResourceType:(NSString*)type appInstanceId:(NSInteger) instanceId
{
    Resource *resource = [[Resource alloc] init];
    
    NSMutableArray *hierarchyClone = [[NSMutableArray alloc] initWithArray:hierarchy copyItems:YES];
    
    if ([type isEqualToString:@"jpeg"]) {//type already set this is for only IMAGE
        resource.type = @"IMAGE";
        
        [hierarchyClone addObject:resource];
    }
    resource.uid = resourceId;
    
    ResourcePath *resourcePath = [[ResourcePath alloc] init];
    resourcePath.hierarchy = [[NSMutableArray alloc] initWithArray:hierarchyClone];
    resourcePath.appInstaceID = instanceId;
    
    [hierarchyClone release];
    
    ResourceLink *resourceLink = [[[ResourceLink alloc] init] autorelease];
    resourceLink.resourcePath = [resourcePath retain];
    
    [resource release];
    [resourcePath release];
    
    return resourceLink;
}
///////////////////////////////////////////////////////////////////////////
-(void) openPostCommentView:(FeedItem*) feedItem
{
    
	PostCommentViewController *viewController = [[[PostCommentViewController alloc] initWithParentViewController:self withFeedItem:feedItem resourceLink:nil withCommentActions:0] autorelease];
	
    UINavigationController *modalViewNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
	modalViewNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	modalViewNavController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:modalViewNavController animated:YES];
}

///////////////////////////////////////////////////////////////////////////

-(void) openApplication:(NSString*)url
{
    URLParser *parser = [[URLParser alloc] initWithURLString:url];
    NSString *feeId = [parser valueForVariable:@"feedId"];
    id ID = [parser valueForVariable:@"ID"];
    NSString *type = [parser valueForVariable:@"type"];
    NSInteger action = [[parser valueForVariable:@"action"] intValue];
    
    FeedItem *feedItem = [[FeedManager sharedFeedManager] getObjectForFeedId:feeId];
    
    if (action == POST_COMMENT) {
        //open comment view

        [self openPostCommentView:feedItem];
        
        return;
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabBar" object:nil];

        ResourceLink *resourceLink = [self makeResourceLinkForHierarchy:feedItem.hierarchy withResourceId:ID withResourceType:type appInstanceId:feedItem.appInstanceId];
        
        [self setSplitPosition:DEFALUT_MASTER_VIEW_WIDTH];
        
        switch (feedItem.appInstanceId) {
            case NOTES:
                
                [self setSplitPosition:NOTE_MASTER_VIEW_WIDTH];
                [self performSelector:@selector(toggleMasterBeforeDetail:)];
                
                detailedViewController = [[NoteManagerViewController alloc]initWithParentViewController:self feedItem:feedItem resourceLink:resourceLink withCommentActions:action];
                
                masterViewController = [[CommentsTableViewController alloc]initWithParentViewController:self withFeedItem:feedItem withMaxWidth:NOTE_MASTER_VIEW_WIDTH withCommentActions: action];
                
                ((CommentsTableViewController*)masterViewController).managerViewControllerDelegate = detailedViewController;
                
                break;
                
            case WEBLINKS:
                
                
                [self performSelector:@selector(toggleMasterBeforeDetail:)];
                
                detailedViewController = [[WebLinkViewController alloc]initWithParentViewController:self feedItem:feedItem resourceLink:resourceLink];
                
                masterViewController = [[CommentsTableViewController alloc]initWithParentViewController:self withFeedItem:feedItem withMaxWidth:DEFALUT_MASTER_VIEW_WIDTH withCommentActions: action];
                
                    ((CommentsTableViewController*)masterViewController).managerViewControllerDelegate = detailedViewController;

                break;
                
            case 14: //for milestone
                
                [self performSelector:@selector(toggleMasterBeforeDetail:)];
                
                detailedViewController = [[MilestoneViewController alloc]initWithParentViewController:self feedItem:feedItem resourceLink:resourceLink];
                
                masterViewController = [[CommentsTableViewController alloc]initWithParentViewController:self withFeedItem:feedItem withMaxWidth:DEFALUT_MASTER_VIEW_WIDTH withCommentActions: action];
                
                break;

                
            default:
                break;
        }
        
        [self viewWillDisappear:YES];
        
        [[self.viewControllers objectAtIndex:0] pushViewController:masterViewController animated:YES];
        [[self.viewControllers objectAtIndex:1] pushViewController:detailedViewController animated:YES];
        
        [self viewWillAppear:YES];
 
    }
     
}

///////////////////////////////////////////////////////////////////////////
- (void)resourceTaped:(NSNotification *) pNotification
{
	NSString *fullPath = [pNotification object];
    [self openApplication:fullPath];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [detailedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [masterViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    // Return YES for supported orientations
	return YES;
}
///////////////////////////////////////////////////////////////////////////
-(void) openFilterPopover:(id) sender
{
    
	UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithCustomView:sender] autorelease];
	[self.popoverController presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark Managing the detail item


// When setting the detail item, update the view and dismiss the popover controller if it's showing.
- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
    }
	
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark Split view Delegates


- (void)splitViewController:(MGSplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc
{
    
    self.popoverController = pc;
    
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.popoverController = nil;
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MGSplit View Controller Delegates


- (void)toggleMasterView:(id)sender
{
	[super toggleMasterView:sender];
}

- (void)toggleVertical:(id)sender
{
	[super toggleSplitOrientation:self];
}

- (void)toggleDividerStyle:(id)sender
{
	MGSplitViewDividerStyle newStyle = ((super.dividerStyle == MGSplitViewDividerStyleThin) ? MGSplitViewDividerStylePaneSplitter : MGSplitViewDividerStyleThin);
	[super setDividerStyle:newStyle animated:YES];
}

- (void)toggleMasterBeforeDetail:(id)sender
{
	[super toggleMasterBeforeDetail:sender];
}

///////////////////////////////////////////////////////////////////////////

@end
