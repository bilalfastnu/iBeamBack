//
//  PostCommentViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "PostCommentViewController.h"

#import "FeedItem.h"
#import "Conversation.h"
#import "DateManager.h"
#import "UserManager.h"
#import "FeedManager.h"
#import "NSString+Additions.h"
#import "CustomUITextView.h"
#import "ConversationsRemoteCaller.h"


@implementation PostCommentViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithParentViewController:(FeedSplitViewController*)parentVC withFeedItem:(id)feedItemData  resourceLink:(ResourceLink*)p_resourceLink withCommentActions:(NSInteger) action
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        feedItem = (FeedItem*)[feedItemData retain];
        resourceLink = [p_resourceLink retain];
        
        commentBox = [[CustomUITextView alloc] initWithFrame:CGRectMake(20, 20, 500, 150)];
		commentBox.layer.borderWidth = 2.0f;
		commentBox.layer.borderColor = [UIColor grayColor].CGColor;
		commentBox.clipsToBounds = YES;
		commentBox.placeholder = @"What's in your mind ?";

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    //[remoteCaller release];
    [commentBox release];
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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Post Comment";
    
    [self.view addSubview:commentBox];
    
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donButtonClicked)];
    

}
-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
}
-(void) cancelButtonClicked
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
    
}


-(void) donButtonClicked
{
    
    /////////// Send comment on server 
	Conversation *conversation = [[Conversation alloc] init];
    conversation.feedId = feedItem.feedId;
   
    conversation.creationTimeStamp = [NSString stringWithFormat:@"%.0f",[[DateManager sharedDateManager] getNowTimeStamp]];
   
    conversation.summery = @"";
    conversation.updatedBy = @"";
    conversation.collaborators = nil;
    conversation.updateKind = 0;
    conversation.conversationId = [NSString stringWithUUID];
    conversation.cItemUId = [NSString stringWithUUID];
    conversation.comments = commentBox.text;
    conversation.resourceId = feedItem.resourceId;
    conversation.updatedTimeStamp = conversation.creationTimeStamp;
    conversation.postDate = [[DateManager sharedDateManager] getNowDate];
    conversation.initiatedBy = [UserManager sharedUserManager].currentUser.userId;
    
    if (resourceLink) {// if comment in applications 
        conversation.resourceLink = resourceLink;
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update Comment" object:conversation];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update Comments Count" object:nil];

    }else
    {
        conversation.resourceLink = [feedItem getResourceLink];
    }

    if (!feedItem.conversationsCount) {// if it is a first comment 
       
        feedItem.conversationsArray = [[NSMutableArray alloc] init];
        [feedItem.conversationsArray addObject:conversation];

    }else
    {
        [feedItem.conversationsArray addObject:conversation];
    }
    

	[self.parentViewController dismissModalViewControllerAnimated:YES];
    
    [[FeedManager sharedFeedManager] updateFeedItem:feedItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Update Feed" object:nil];
    
    remoteCaller = [[ConversationsRemoteCaller alloc] init];
    remoteCaller.delegate = self;
    [remoteCaller addComment:[conversation createValueObjectForServer]];
    
    
    [conversation release];
    
}

#pragma mark -
#pragma mark RemoteCaller Delegates

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(ASObject *)object
{
   NSLog(@"Post comment %@",object);
}
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
	//NSLog(@"Notes Data  Error : %@",error);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Post Data  Error"  message:[NSString stringWithFormat:@"%@", error] 
													   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
