//
//  NoteViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteViewController.h"


#import "Note.h"
#import "FeedItem.h"
#import "CONSTANTS.h"
#import "SnippetFactory.h"
#import "SnippetData.h"
#import "ScrybeUserImage.h"
#import "CollaborationInfo.h"
#import "UIWebView+Additions.h"
#import "ResourceHeaderView.h"
#import "NoteCustomProperties.h"
#import "Three20/Three20+Additions.h"
#import "PostCommentViewController.h"

@implementation NoteViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem resourceLink:(ResourceLink*)resourceLinkObj
{
    self = [super init];
    if (self) {
        self.title = @"Note";
        
        noteFeedItem = feedItem;
        resourceLink = resourceLinkObj;
        
		headerView = [[ResourceHeaderView alloc] initWithFrame:CGRectZero];
        
		//send request to sever for full Note Data
		noteRemoteCaller = [[NoteRemoteCaller alloc] init];
		noteRemoteCaller.delegate = self;
		[noteRemoteCaller getNoteDetails:feedItem.resourceId];
        conntentHtml = nil;
        
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [_toolbar setHidden:YES];
    [_toolbar removeFromSuperview];
    
    
    /*CGRect frame = _webView.frame;
    frame.size.height += 2*_toolbar.frame.size.height;
    _webView.frame = frame;*/

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"loading web view contents");
    NSString *webText = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText;"];

    if ([webText isEqualToString:@""] || webText == nil ) {
        [_webView loadHTMLString:conntentHtml baseURL:nil];
    }
}

#pragma mark -
#pragma mark RemoteCaller Delegates

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(ASObject *)object
{
	NSMutableDictionary *actualData = [object.properties objectForKey:@"data"];
	
	NSLog(@"Note Data %@",actualData);
	NSMutableDictionary *noteData = [actualData objectForKey:@"item"];
	
	NSString *content = [noteData objectForKey:@"complete_text"];
	content = [content stringByReplacingOccurrencesOfString:@"SIZE=\"13\"" withString:@"SIZE=\"5\""];
	
    conntentHtml = [content retain];
	[_webView loadHTMLString:content baseURL:nil];
	//NSLog(@"Note Data:%@",content);
	//[noteWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"displayNote('%@')",content]];
	
	[noteRemoteCaller release];
	
	NSMutableDictionary  *filesDictionary  = [actualData objectForKey:@"files"];
	
    if ([filesDictionary count] > 0) {

        NSArray *files = [filesDictionary objectForKey:[@"files_" stringByAppendingString:[actualData objectForKey:@"item_id"]]];
        
        [((Note *)noteFeedItem).imagesArray removeAllObjects];
        
        for (NSDictionary *noteCustomProperties in files) {
            
            if ([[noteCustomProperties objectForKey:@"file_format"] isEqualToString:@"IMAGE"]) {
                
                [((Note *)noteFeedItem).imagesArray addObject:[[NoteCustomProperties alloc ] initWithCustomProperty:noteCustomProperties]];
            }
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MoreImagesArrived" object:((Note *)noteFeedItem).imagesArray ];

    }
    
}	
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
	//NSLog(@"Notes Data  Error : %@",error);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Note Data  Error"  message:[NSString stringWithFormat:@"%@", error] 
													   delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}


#pragma -
#pragma mark Provide collaboration

-(void) annotateToTextSnippet:(SnippetData*)snippetData
{
    NSLog(@"Annotated on Text data:%@",snippetData.data);
    NSString *text = [snippetData.data objectForKey:@"text"];
    
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(removeHighligedText:) userInfo:nil repeats:NO]; 

    int count = [_webView highlightAllOccurencesOfString:text];
	NSLog(@"highlighted count:%d",count);

    
}
-(void)removeHighligedText:(NSTimer*)timer
{
    [_webView removeAllHighlights];
}


#pragma -
#pragma mark UIMenu Controller Itmes

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if ( action == @selector( postComment: ) )
    {
        return YES; // logic here for context menu show/hide
    }
    
    if ( action == @selector( copy: ) )
    {
        // turn off copy: if you like:
        return YES;
    }
    
    return [super canPerformAction: action withSender: sender];
}

///////////////////////////////////////////////////////////////////////////
-(void) openPostCommentView:(ResourceLink *)noteResourceLink
{
    SnippetFactory *snippetFactory = [[SnippetFactory alloc] init];
    NoteSnippetView *snippetView = [snippetFactory getNoteSnippetForData:noteResourceLink.collaborationInfo.snippetData.data];
    
	PostCommentViewController *viewController = [[[PostCommentViewController alloc] initWithParentViewController:nil withFeedItem:noteFeedItem resourceLink:noteResourceLink withCommentActions:0] autorelease];
    
    snippetView.frame = CGRectMake(100, 300, snippetView.frame.size.width, snippetView.frame.size.height);
    [viewController.view addSubview:snippetView];
    [snippetFactory release];
	
    UINavigationController *modalViewNavController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
	modalViewNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	modalViewNavController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:modalViewNavController animated:YES];
    
}

///////////////////////////////////////////////////////////////////////////

-(void)postComment:(id)sender
{
    NSString *selection = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected Text" message:selection delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
   // [alert show];
    //[alert release], alert = nil;
    //NSString *offsetStr = [_webView stringByEvaluatingJavaScriptFromString:@"window.getTextOffset()"];
   // NSLog(@"string offset:%@",offsetStr);
   
    ResourceLink *newResourceLink = [resourceLink copy];
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    //[dataDictionary setValue:[NSNumber numberWithInt:0] forKey:@"beginIndex"];
    //[dataDictionary setValue:[NSNumber numberWithInt:[selection length]] forKey:@"endIndex"];
    [dataDictionary setValue:selection forKey:@"text"];
   
    SnippetData *snippetData = [[SnippetData alloc] initWithType:@"scrybe.components.snippet.NotesSnippet" data:dataDictionary];
    
    CollaborationInfo *collaborationObj = [[CollaborationInfo alloc] initWithSnippetData:snippetData parentResourceIndex:noteFeedItem.resourceDepth]; 
    
    newResourceLink.collaborationInfo = collaborationObj;
    
    
    [self openPostCommentView:newResourceLink];
}

- (void)dealloc
{
    [conntentHtml release];
    [headerView release];
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

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *url = [ScrybeUserImage getScrybeUserImageUrl:noteFeedItem.createdBy imageSize:@"48x48"];
    
    [headerView.userImageView setImage:url forState:UIControlStateNormal];
    
    
    headerView.sharingInfoLabel.text = [noteFeedItem.sharingInfo stringByRemovingHTMLTags];
    headerView.titleLabel.text = [noteFeedItem.title stringByRemovingHTMLTags];

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *item = [[[UIMenuItem alloc] initWithTitle: @"Comment"
                                                   action: @selector(postComment:)] autorelease];
    [menuController setMenuItems: [NSArray arrayWithObject: item]];

    [self.view addSubview:headerView];
}

-(void) configureView
{
    
    CGRect frame = self.view.frame;
    
    //NSLog(@"in Notes View Controller Potrait :\n \t\tx:%f\n\t\ty:%f\n\t\twidht:%f\n\t\theight:%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
	frame.origin.y = (frame.origin.y < 0?-frame.origin.y :-frame.origin.y);
	frame.origin.x = (frame.origin.x > 0?-frame.origin.x :frame.origin.x);
	
	headerView.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, RESOURCE_HEADER_VIEW_HEIGHT);
    
    frame.size.height -=(TTToolbarHeight()+30);
    frame.origin.y = RESOURCE_HEADER_VIEW_HEIGHT;
    _webView.frame =frame;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self configureView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self configureView];
    /*CGRect frame = self.view.frame;

	frame.origin.y = (frame.origin.y < 0?-frame.origin.y :-frame.origin.y);
	frame.origin.x = (frame.origin.x > 0?-frame.origin.x :frame.origin.x);
	
	headerView.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, RESOURCE_HEADER_VIEW_HEIGHT);
    
    frame.size.height -=(TTToolbarHeight()+30);
    frame.origin.y = RESOURCE_HEADER_VIEW_HEIGHT;
    _webView.frame =frame;*/
    
    // Return YES for supported orientations
	return YES;
}

@end
