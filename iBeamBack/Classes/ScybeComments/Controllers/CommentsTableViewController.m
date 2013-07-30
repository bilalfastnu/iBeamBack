//
//  CommentsTableViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "CommentsTableViewController.h"

#import "CELL.h"
#import "UserManager.h"
#import "CONSTANTS.h"
#import "FeedItem.h"
#import "DateManager.h"
#import "Conversation.h"
#import "ConversationTableViewCell.h"
#import "extThree20JSON/JSON.h"
#import "PostCommentViewController.h"
#import "FeedSplitViewController.h"
#import "Three20/Three20+Additions.h"
#import "ConversationsRemoteCaller.h"

@interface CommentsTableViewController(PRIVATE)

-(void) fetchAllConversations;
-(void) updateTableView;

@end

@implementation CommentsTableViewController

@synthesize managerViewControllerDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style 
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithParentViewController:(FeedSplitViewController*)parentVC withFeedItem:(id)feedItemData withMaxWidth:(CGFloat)width withCommentActions:(NSInteger) action
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        
        feedItem = feedItemData;
        //feedItem = (FeedItem*)[feedItemData retain];
        cellMaxWidth = width;
        parentDelegate = parentVC;
       
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(updateComment:)
		 name:@"Update Comment"
		 object:nil ];

        allCommentsArray = nil;
       
        commentsArray = [[NSMutableArray alloc] initWithArray:feedItem.conversationsArray];
        commentsCount = [commentsArray count];

        if (action == SHOW_ALL_COMMENTS) {
            
            isMoreCommentCell = YES;
            //fetch all comments first and then show popover
 
            [self fetchAllConversations];
            
        }else
        {
           // isMoreCommentCell = ([commentsArray count] > (MAX_CONVERSATIONS_DISPLAY+1) ? YES : NO);
            isMoreCommentCell = (([commentsArray count] < feedItem.conversationsCount)? YES : NO); 
        }
    }
    return self;
}


- (void)dealloc
{
    [allCommentsArray release];
    [commentsArray release];
    [closeButton release];
    [commentButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma PopOver Buttons handlers

-(void) commentButtonClicked:(id) sender
{
    PostCommentViewController *viewController = [[[PostCommentViewController alloc] initWithParentViewController:parentDelegate withFeedItem:feedItem resourceLink:nil withCommentActions:0] autorelease];
    
    UINavigationController *modalViewNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
    modalViewNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    modalViewNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:modalViewNavController animated:YES];
}

-(void) closeButtonClicked:(id) sender
{
    [[parentDelegate popoverController] dismissPopoverAnimated:YES];
   // [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void) updateComment:(NSNotification *) pNotification
{
    Conversation *conversation = [pNotification object];
    
    [commentsArray addObject:conversation];
    if ([commentsArray count] > 3) {
        [commentsArray removeObjectAtIndex:0];
    }
    [allCommentsArray addObject:conversation];
    [self.tableView reloadData];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma Fetch Conversations
-(NSString*) joinConversationsIDs:(NSMutableArray *) conversations
{
	NSString *jointConversationsIDs = @"";
	
	for (Conversation *conversation  in conversations) {
		jointConversationsIDs = [jointConversationsIDs stringByAppendingString:conversation.conversationId];
		jointConversationsIDs = [jointConversationsIDs stringByAppendingString:@","];
	}
	
	NSRange range;
	
	range.length = 2;
	range.location = [jointConversationsIDs length]-2;
	
	jointConversationsIDs =  [jointConversationsIDs stringByReplacingOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:range];
	
	return jointConversationsIDs;
}
-(void) fetchAllConversations
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1",@"all",
							[self joinConversationsIDs:feedItem.conversationsArray], @"excludedDiscussionIDs",
							[NSString stringWithFormat:@"%@",feedItem.resourceId], @"absoluteItemID",
							[NSNumber numberWithInt:feedItem.feedId], @"feedID",
							[NSNumber numberWithInt:feedItem.appInstanceId], @"appInstanceID",
							nil];
	
	//NSLog(@"%@",params);
	conversationsRemoteCaller = [[ConversationsRemoteCaller alloc] init];
	conversationsRemoteCaller.delegate = self;
	[conversationsRemoteCaller fetchDiscussionsAndCount:params];
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) processConversations:(NSArray*)conversations
{
    NSMutableDictionary *conversationDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *converationDic in conversations) {
        
        Conversation *conversation = [[Conversation alloc] initWithConversationData:converationDic];
        [conversationDictionary setValue:conversation forKey:conversation.conversationId];
		[conversation release];
    }
    
    NSSortDescriptor *feedItemSorter = [[NSSortDescriptor alloc] initWithKey:@"creationTimeStamp" ascending:YES];
	
	NSArray *feedItemsSortedArray = [[conversationDictionary allValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:feedItemSorter]];
	[feedItemSorter release];

    allCommentsArray=[[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:feedItemsSortedArray]];

   // feedItem.conversationsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:feedItemsSortedArray]];

}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#define ConversationsRemoteCaller Delegates

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    [loadingInIndicator stopAnimating];
	NSDictionary *discussions = (NSDictionary*)object;
	//NSLog(@"Comments %@",discussions);
	[self processConversations:[discussions objectForKey:@"discussions"]];
	feedItem.conversationsCount = [[discussions objectForKey:@"discussionsCounts"] intValue];

    [commentsArray release];
    commentsArray = [[NSMutableArray alloc] initWithArray:allCommentsArray];

   // [self.tableView reloadData];

   [self updateTableView];
}
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
	//NSLog(@"Notes Data  Error : %@",error);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Conversation Data  Error"  message:       [NSString stringWithFormat:@"%@", error] 													   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	
    [alertView show];
	[alertView release];
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    commentButton = [[UIBarButtonItem alloc] init];
	commentButton.title = @"+Comments";
	commentButton.target = self;
	commentButton.action = @selector(commentButtonClicked:);
	
    closeButton = [[UIBarButtonItem alloc] init];
	closeButton.title = @"Close";
	closeButton.target = self;
	closeButton.action = @selector(closeButtonClicked:);
    
	self.navigationItem.rightBarButtonItem = closeButton;
	self.navigationItem.leftBarButtonItem = commentButton;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
   // int count = [feedItem.conversationsArray count];
  
	if(isMoreCommentCell)
       return [commentsArray count]+1;
    
    return [commentsArray count];

}

////////////// Calculate Height of Cell with size ////////////////////

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isMoreCommentCell && indexPath.row == 0)
	{
		return 50;
	}

    CGFloat cellHeight = VERTICAL_DIFERENCE_LABEL;
    //Conversation *conversation = [feedItem.conversationsArray objectAtIndex:indexPath.row];
    
    //if more comments is selected than take first comment from array
   Conversation *conversation = (isMoreCommentCell == YES ? [commentsArray objectAtIndex:indexPath.row-1]:[commentsArray objectAtIndex:indexPath.row]);

    CGSize constraints = CGSizeMake(cellMaxWidth-(CONVERSATIONS_USER_ICON_WIDTH+10),CELL_CONTENT_MAX_HEIGHT);
    
    CGSize size = CGSizeZero;
    
    NSInteger parentResourceIndex =  conversation.resourceLink.collaborationInfo.parentResourceIndex;
    NSInteger hierarcyCount = [conversation.resourceLink.resourcePath.hierarchy count];
    
    //calculate height of subresource title
    if (parentResourceIndex != -1 &&(parentResourceIndex+1) < hierarcyCount)
    {
        Resource *resource =[conversation.resourceLink.resourcePath.hierarchy objectAtIndex:hierarcyCount-1];
        size = [resource.title sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
        cellHeight+=size.height;
    }

    NSString *creationInfo = [[[UserManager sharedUserManager] getFullName:conversation.initiatedBy] stringByAppendingString:@", "];
    
    if ([conversation.updatedBy length]) {
        creationInfo = [creationInfo stringByAppendingString:@"Updated "];
    }
    
    creationInfo = [creationInfo stringByAppendingString:[[DateManager sharedDateManager] getReletiveDate:conversation.postDate]];
    
    NSString *commentText = [conversation.comments stringByRemovingHTMLTags];
    
    size = [[commentText stringByAppendingString:creationInfo] sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
    
    cellHeight+=size.height;
 
    SnippetData *snippetData = conversation.resourceLink.collaborationInfo.snippetData;
    if (snippetData.data != (NSMutableDictionary*) [NSNull null]) {
        
        cellHeight+=VERTICAL_DIFERENCE_LABEL;
        
        if ([snippetData.type isEqualToString:NOTE_SNIPPET])
        {
            NSString *textSnippet = [snippetData.data objectForKey:@"text"];
            
            textSnippet = ([textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? [textSnippet substringToIndex:MAX_TEXT_SNIPPET_LENGTH] :textSnippet);
            
            size = [textSnippet sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:CGSizeMake(TEXT_SNIPPET_WIDTH, TEXT_SNIPPET_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
            
            cellHeight+=size.height;
            
            cellHeight+=([textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? 2*VERTICAL_DIFERENCE_LABEL: VERTICAL_DIFERENCE_LABEL);
            
        }
        else if ([snippetData.type isEqualToString:IMAGE_SNIPPET])
        {
            cellHeight+=[[snippetData.data objectForKey:@"height"] intValue];
            
        }
    }
    cellHeight+=VERTICAL_DIFERENCE_LABEL;
   

    return (cellHeight > 35 ? cellHeight : cellHeight+10);
   // return cellHeight+VERTICAL_DIFERENCE_LABEL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ConversationTableViewCell *cell = (ConversationTableViewCell*)
                                    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else
    {
        [cell.conversationView removeFromSuperview];
	 	 cell.conversationView = nil;
		[cell.moreCommentsLabel removeFromSuperview];
		 cell.moreCommentsLabel = nil;
        cell.backgroundView = nil;
        cell.selectedBackgroundView = nil;
    }
    
    // Configure the cell...
    
    if (isMoreCommentCell && indexPath.row == 0 ) {
		
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.backgroundView =[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topAndBottomRow.png"]] autorelease];
		cell.selectedBackgroundView =[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topRowSelected.png"]] autorelease];
		
		cell.moreCommentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.view.frame.size.width-40, 20)]; 
		cell.moreCommentsLabel.backgroundColor = [UIColor clearColor];
		cell.moreCommentsLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		cell.moreCommentsLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		cell.moreCommentsLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    	
		cell.moreCommentsLabel.text = (([commentsArray count] < feedItem.conversationsCount )? [NSString stringWithFormat:@"Show all %d discussions",feedItem.conversationsCount]:
                                       [NSString stringWithFormat:@"%d discussions: show latest only",feedItem.conversationsCount]);
		[cell.contentView addSubview:cell.moreCommentsLabel];
	}
    else
    {
        //Conversation *conversation = [commentsArray objectAtIndex:indexPath.row];

        Conversation *conversation = (isMoreCommentCell ? [commentsArray objectAtIndex:indexPath.row-1]:[commentsArray objectAtIndex:indexPath.row]);


        cell.conversationView = [[ConversationView alloc] initWithFrame:CGRectZero withConversationData:conversation withMaximumCellWidth:cellMaxWidth];
        
        cell.conversationView.cellDelegate = self;
        
        CGRect frame = cell.conversationView.frame;
        frame.origin.y = 5;
        frame.origin.x = 5;
        
        cell.conversationView.frame = frame;
        
        [cell.contentView addSubview:cell.conversationView];
        [cell.conversationView release];
        
    }
    return cell;
}


-(void) snippetViewTapped:(id) p_conversation
{
    //Conversation *conversation = (Conversation*) p_conversation;
    
    if ([managerViewControllerDelegate respondsToSelector:@selector(openSnippetCollaboration:)]) {
        [managerViewControllerDelegate performSelector:@selector(openSnippetCollaboration:) withObject:p_conversation];
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
////////////////////////////////////////////////////////////////////////////////////////////////
-(void) updateTableView
{
	/*
	 Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
	 */
	NSInteger countOfRowsToInsert = [commentsArray count]-commentsCount;
	NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
	for (NSInteger i = 1; i <= countOfRowsToInsert; i++) {
		[indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
	}
	UITableViewRowAnimation insertAnimation = UITableViewRowAnimationTop;
	
	// Apply the updates.
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
	[self.tableView endUpdates];
	
	[indexPathsToInsert release];
	
	ConversationTableViewCell *cell =(ConversationTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.moreCommentsLabel.text =  [NSString stringWithFormat:@"%d discussions: show latest only",feedItem.conversationsCount];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (isMoreCommentCell && indexPath.row ==0 ){
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
        ConversationTableViewCell *cell =(ConversationTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];

      // if([commentsArray count] < feedItem.conversationsCount ){	
        //if data is already stored in feedItem.comments array 
        
        if([commentsArray count] < feedItem.conversationsCount ){

            if ([allCommentsArray count] == feedItem.conversationsCount) {
                
                [commentsArray release];
                commentsArray = [[NSMutableArray alloc] initWithArray:allCommentsArray];
                [self updateTableView];
                return;
            }else{
                
                [self fetchAllConversations];
                
                loadingInIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(280, 10, 25, 25)];
                loadingInIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                loadingInIndicator.hidesWhenStopped = YES;
                [loadingInIndicator startAnimating];
                [cell.contentView addSubview:loadingInIndicator];
            }
			
        }//end if data is already
        else 
        {
			//NSRange range;
			//range.length = MAX_CONVERSATIONS_DISPLAY;
			//range.location = 0;
			//NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:range];
			
			NSInteger countOfRowsToDelete = [commentsArray count] - (MAX_CONVERSATIONS_DISPLAY+1);
			//[commentsArray removeObjectsAtIndexes:indexes];
			
			if (countOfRowsToDelete > 0)
            {
                int rowDelete = countOfRowsToDelete-1;
				NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
				for (NSInteger i = 1; i <= countOfRowsToDelete; i++)
                {
                    [commentsArray removeObjectAtIndex:rowDelete];
                   // [commentsArray removeObjectsAtIndexes:];
					[indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    rowDelete-=1;
                }

				[self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
				[indexPathsToDelete release];
				cell.moreCommentsLabel.text = [NSString stringWithFormat:@"Show all %d discussions",feedItem.conversationsCount];

			}
			
		}//end else

	}//end if (isMoreCommentCell && indexPath.row ==0 )   
}


@end
