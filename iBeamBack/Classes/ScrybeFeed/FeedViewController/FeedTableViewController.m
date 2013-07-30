//
//  FeedTableViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedTableViewController.h"

#import "CONSTANTS.h"
#import "APPLICATIONS.h"
#import "FeedDataSource.h"


@implementation FeedTableViewController

@synthesize filterTabBar;
///////////////////////////////////////////////////////////////////////////

-(id) init
{
    self = [super init];
    
    if (self) {
        
        self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;
		
        filterTabBar =[[FilterTabBar alloc] init];
		filterTabBar.delegate = self;
		[filterTabBar setSelectedItem:[filterTabBar.items objectAtIndex:0]];
        
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(hideTabBar:)
		 name:@"HideTabBar"
		 object:nil ];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(showTabBar:)
		 name:@"ShowTabBar"
		 object:nil ];

		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(updateFeed:)
		 name:@"Update Feed"
		 object:nil ];
        /////////////////////////////////////////
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(addBadgeView:)
		 name:@"ChatNotificationReceived"
		 object:nil ];
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(getNotifierInfo:)
		 name:@"GetLastNotifierMessage"
		 object:nil ];
        
        //////////////////////////////////////////


    }
    return self;
}

///////////////////////////////////////////////////////////////////////////
-(void) updateFeed:(id) sender
{
  	[self.tableView reloadData];
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TabBar Hidden or ShowTabBar

-(void) showTabBar:(id) sender
{
	filterTabBar.hidden = NO;
}
-(void) hideTabBar:(id) sender
{
	filterTabBar.hidden = YES;
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////Chat Methods /////////////////////////////////

-(void)getNotifierInfo:(NSNotification*)notif
{
    notifSession =nil;
    notifSession = [notif object];
    
}

-(void)openChat
{
    
    chatVC = [[ChatViewController alloc] init];
	UINavigationController *chatViewNavController = [[UINavigationController alloc] initWithRootViewController:chatVC];
	chatViewNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	chatViewNavController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:chatViewNavController animated:YES];
    
    
    if (filterTabBar.badgeView.value >0) {
        if (notifSession!=nil) {
            [chatVC setCurrentUser:notifSession.sessionUser];
            filterTabBar.badgeView.value = 0;
            filterTabBar.badgeView.hidden =YES;
        }
        
    }
    [chatViewNavController release];
    
}


-(void)addBadgeView:(NSNotification*)notif
{
    NSString *count = [notif object];
    filterTabBar.badgeView.value = [count intValue];
    filterTabBar.badgeView.hidden =NO;
    
}


///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark  UITabBar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	
	[filterTabBar setSelectedItem:item];

	NSString *applicationResourceType = nil;
    
	
	switch (item.tag) {
		case 0://all feed 
			
			applicationResourceType = @"null";
			break;
		case 1:
            
			applicationResourceType = [NSString stringWithFormat:@"%d", NOTES];
            
			break;
		case 2:
			applicationResourceType = [NSString stringWithFormat:@"%d", MESSAGES];
            
			break;
		case 3:
			applicationResourceType = [NSString stringWithFormat:@"%d", WEBLINKS];
            
			break;
		case 4:
			applicationResourceType = [NSString stringWithFormat:@"%d", MILESTONES];
            
			break;
        case 5:
            
            [self openChat];
           
            break;
            
		default:
			break;
	}
	
    if (item.tag != 5 ) { //if chat
        
        NSArray *keys = [NSArray arrayWithObjects:@"description", @"id",@"nature",@"type",@"value", nil];
        NSArray *objects = [NSArray arrayWithObjects:@"note", @"filter_0.4585668961517513",@"PERMANENT",@"is",applicationResourceType, nil];
        
        NSDictionary *filterDict0 = [NSDictionary dictionaryWithObjects:objects forKeys:keys];	
        
        NSArray *filters = [NSArray arrayWithObjects:filterDict0,nil];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"AND filters chain",@"description",
                                @"filter_0.652161231264472", @"id",
                                @"PERMANENT", @"nature",
                                @"AND_CHAIN", @"type",
                                @"1",		@"noOfFilters",
                                filters, @"values",
                                filters, @"filters",nil];
        
        //NSLog(@"filterDictionary %@",filterDictionary);
        
        FeedDataSource *feedDataSource = [FeedDataSource sharedFeedDataSource];
        [feedDataSource fetchFeedForFilter:params forFilterType:item.tag];
        
        [self reload];
        
    }
    
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark TTTableView 

- (void)loadView {
	[super loadView];
	self.tableView.allowsSelection = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
    
    CGRect frame = self.tableView.frame;
    frame.size.height-=40;
    frame.origin.y = 5;
    self.tableView.frame = frame;
    
}

#pragma mark --
#pragma mark TTModelViewController methods

- (void)createModel {
	
	FeedDataSource *feedDataSource = [FeedDataSource sharedFeedDataSource];
	
	self.dataSource = feedDataSource;
	
	TT_RELEASE_SAFELY(feedDataSource);
}
- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

///////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [filterTabBar release];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[self.navigationController.navigationBar addSubview:filterTabBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect frame = [[UIScreen mainScreen] bounds];
	filterTabBar.frame = CGRectMake(frame.origin.x, frame.origin.y, self.navigationController.navigationBar.frame.size.width, 50.0f);
	
	switch (interfaceOrientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
			
			filterTabBar.filterButton.hidden = NO;
            
			break;
			
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationLandscapeLeft:
			
			filterTabBar.filterButton.hidden = YES;
			break;
	}
    // Return YES for supported orientations
	return YES;
}

@end
