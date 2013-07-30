//
//  MilestoneViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/22/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MilestoneViewController.h"

#import "ICONS.h"
#import "Milestone.h"
#import "CONSTANTS.h"
#import "DateManager.h"
#import "ScrybeUserImage.h"
#import "ResourceHeaderView.h"
#import "TKCalendarMonthView.h"
#import "Three20/Three20+Additions.h"
#import "FeedSplitViewController.h"

//static int calendarShadowOffset = (int)-20;

#define X_POSTION		20.0f

#define Y_POSTION		170.0f

@implementation MilestoneViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj
{
    self = [super init];
    if (self) {
        
        milestoneFeedItem = (Milestone*)feedItemObject;
        parentDelegate = parentVC;
        resourceLink = resourceLinkObj;
        
        headerView = [[ResourceHeaderView alloc] initWithFrame:CGRectZero];
        calendar = 	[[TKCalendarMonthView alloc] init];
    }
    return self;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UINavigationControllerDelegate control

// Required to ensure we call viewDidAppear/viewWillAppear on ourselves (and the active view controller)
// inside of a navigation stack, since viewDidAppear/willAppear insn't invoked automatically. Without this
// selected table views don't know when to de-highlight the selected row.

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewWillAppear:animated];
	
	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
            NSLog(@"FORWARD");
        } else {
            NSLog(@"Milestone BACKWARD");
            // Do exciting back button pressed stuff here.
			[parentDelegate closeApplication];
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    NSString *url =[ScrybeUserImage getScrybeUserImageUrl:milestoneFeedItem.createdBy imageSize:@"48x48"];
    
    [headerView.userImageView setImage:url forState:UIControlStateNormal];
    
    headerView.sharingInfoLabel.text = [milestoneFeedItem.sharingInfo stringByRemovingHTMLTags];
    headerView.titleLabel.text = [milestoneFeedItem.title stringByRemovingHTMLTags];
    
    [self.view addSubview:headerView];

    ///////////////////////// initialize milestone view
    
    NSDate *date = [[DateManager sharedDateManager] localTimeZoneDateFrom:milestoneFeedItem.customProperty.dueOn];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE,MMMM d"];
	NSString *dateString = [dateFormatter stringFromDate:date];  
	
	UILabel *dueMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_POSTION+10, 100, 300, 30)];
	dueMonthLabel.textColor = [UIColor whiteColor];
	dueMonthLabel.font = [UIFont systemFontOfSize:16];
	
	dueMonthLabel.text = dateString;
    
    int days = [[DateManager sharedDateManager] getHowManyDaysHavePased:milestoneFeedItem.customProperty.dueOn];
    dueMonthLabel.backgroundColor = ([milestoneFeedItem.customProperty.status isEqualToString:@"done"]?
                    [UIColor colorWithRed:70.0f/255.0f green:130.0f/255.0f blue:70.0f/255.0f alpha:1.0]:
                    (days > 0 ?[UIColor colorWithRed:154.0f/255.0f green:30.0f/255.0f blue:32.0f/255.0f alpha:1.0]:[UIColor colorWithRed:232.0f/255.0f green:146.0f/255.0f blue:25.0f/255.0f alpha:1.0]));
	
	
	[dueMonthLabel sizeToFit];
	[self.view addSubview:dueMonthLabel];

    UILabel *dueDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dueMonthLabel.frame.size.width+50, dueMonthLabel.frame.origin.y, 200, 20)];
	dueDayLabel.textColor = [UIColor grayColor];
    
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X_POSTION+10, 125, 30, 30)];
	imageView.image = [UIImage imageNamed:UnCompleteTaskIcon];
	
    if ([milestoneFeedItem.customProperty.status isEqualToString:@"pending"]) {

        dueDayLabel.text = ( days > 0 ?[NSString stringWithFormat:@"%d days ago",days]:days == 0 ?@"Today":[NSString stringWithFormat:@"In %d days",-days]);

	}else
	{
		imageView.image = [UIImage imageNamed:CompleteTaskIcon];
		dueDayLabel.text = @"Completed";
	}
	[self.view addSubview:imageView];
	[imageView release];
    
	[self.view addSubview:dueDayLabel];
	[dueDayLabel release];
	[dueMonthLabel release];
	

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_POSTION+40, 130, self.view.frame.size.width, 30)];
	titleLabel.font = [UIFont boldSystemFontOfSize:16];
	titleLabel.text = milestoneFeedItem.customProperty.title;
	
	[titleLabel sizeToFit];
	[self.view addSubview:titleLabel];
	[titleLabel release];
	
	TTStyledTextLabel *detailedTextLabel = [[TTStyledTextLabel alloc] init];
	detailedTextLabel.font = [UIFont systemFontOfSize:16];
	CGSize constraintsLabel = CGSizeMake(300, 1000);
    
	NSString *text = @"<b>Description</b>";
	text = [text stringByAppendingString:[NSString stringWithFormat:@"\n%@",milestoneFeedItem.customProperty.text]];
	detailedTextLabel.text = [TTStyledText textFromXHTML:text lineBreaks:YES URLs:NO];
	CGSize sizeLabel = [text sizeWithFont:detailedTextLabel.font constrainedToSize:constraintsLabel lineBreakMode:UILineBreakModeWordWrap];
	detailedTextLabel.frame = CGRectMake(360, Y_POSTION, 340, sizeLabel.height);
    
	[self.view addSubview:detailedTextLabel];
  
	[detailedTextLabel release];

   // 

     ////////////////////////////////////////////
    //calendar
    calendar.frame = CGRectMake(X_POSTION,Y_POSTION,calendar.frame.size.width,calendar.frame.size.height);
    //calendar.userInteractionEnabled = NO;
    [self.view addSubview:calendar];
	[calendar reload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.delegate = self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect frame = self.view.frame;
    
	headerView.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, RESOURCE_HEADER_VIEW_HEIGHT);

    // Return YES for supported orientations
	return YES;
}

@end
