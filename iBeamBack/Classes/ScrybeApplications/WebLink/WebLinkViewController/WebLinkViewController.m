//
//  WebViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "WebLinkViewController.h"

#import "CONSTANTS.h"

#import "WebLink.h"
#import "ICONS.h"
#import "BadgeView.h"
#import "ScrybeUserImage.h"
#import "ResourceHeaderView.h"
#import "FeedSplitViewController.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20/Three20+Additions.h"
#import "Three20UI/UIToolbarAdditions.h"
#import "Conversation.h"
#import "UIWebView+Additions.h"

@implementation WebLinkViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithParentViewController:(FeedSplitViewController*)parentVC feedItem:(FeedItem*)feedItemObject resourceLink:(ResourceLink*)resourceLinkObj
{
    self = [super init];
    if (self) {
        
        webLinkFeedItem = (WebLink*)feedItemObject;
        parentDelegate = parentVC;
        resourceLink = resourceLinkObj;
        
        headerView = [[ResourceHeaderView alloc] initWithFrame:CGRectZero];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [badgeView release];
    [headerView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
            NSLog(@"WebLink BACKWARD");
            // Do exciting back button pressed stuff here.
			[parentDelegate closeApplication];
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [super webViewDidStartLoad:webView];
	self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
    [myToolbar replaceItemWithTag:3 withItem:_refreshButton];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}
- (void)webViewDidStartLoad:(UIWebView*)webView {
	[super webViewDidStartLoad:webView];
	[myToolbar replaceItemWithTag:3 withItem:_stopButton];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
	
	if ([[[request URL] scheme] isEqualToString:@"coord"]) {
		NSLog(@":%@",[request URL]);
		// extracting the coordinates from the URL....
		//NSArray *chunks = [[[request URL] absoluteString] componentsSeparatedByString:@":"];
		
		/*
		CALayer *txtSelectionLayer = [CALayer layer];
		//sublayer.backgroundColor = [UIColor clearColor].CGColor;
		txtSelectionLayer.borderColor = [UIColor redColor].CGColor;
		txtSelectionLayer.borderWidth = 1.5f;
		
		
		CGRect toRect = CGRectZero;
		
		// to make correct rect on the text
		if ( ([[chunks objectAtIndex:1] intValue] + [[chunks objectAtIndex:3] intValue]) > 768) {
			toRect = CGRectMake(0, [[chunks objectAtIndex:2] intValue], [[chunks objectAtIndex:3] intValue], [[chunks objectAtIndex:4] intValue]);
			
			
		}else {
			toRect = CGRectMake([[chunks objectAtIndex:1] intValue], [[chunks objectAtIndex:2] intValue], [[chunks objectAtIndex:3] intValue], [[chunks objectAtIndex:4] intValue]);
			
		}
		
		// make rect so it fits to the device dimensions
		if (toRect.origin.y > 2*768) {
			toRect.origin.y = 0;
		}
		
		
		//[noteWebViewDelegate showAnnotationAtRect:toRect];
		
		[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeRect:) userInfo:txtSelectionLayer repeats:NO]; 
		toRect.origin.y = 0;
		txtSelectionLayer.frame = toRect;
		[webView.layer addSublayer:txtSelectionLayer];
		*/
		
		return NO;
	} 
	
    
	/*
	 if ( [request.mainDocumentURL.relativePath hasPrefix:@"/allCorrect/"] ) {
	 NSLog( @"You got them all!" );
	 NSLog(@":%@",request.mainDocumentURL.relativePath);
	 
	 return NO;
	 }
	 */
	return YES;		 
}

-(void)removeRect:(NSTimer*)timer { 

    [_webView removeAllHighlights];
	/*
	 for (CALayer *layer in [[mywebView.layer.sublayers copy] autorelease]) {
	 
	 if ([layer isEqual:klayer]) {
	 [klayer removeFromSuperlayer];
	 }
	 //[layer removeFromSuperlayer];
	 }
	 */
} 


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];

	_backButton = [[UIBarButtonItem alloc] initWithImage:
				   TTIMAGE(@"bundle://Three20.bundle/images/backIcon.png")
												   style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
	_backButton.tag = 2;
	_backButton.enabled = NO;
	_forwardButton = [[UIBarButtonItem alloc] initWithImage:
					  TTIMAGE(@"bundle://Three20.bundle/images/forwardIcon.png")
													  style:UIBarButtonItemStylePlain target:self action:@selector(forwardAction)];
	_forwardButton.tag = 1;
	_forwardButton.enabled = NO;
	_refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
					  UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
	_refreshButton.tag = 3;
	_stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
				   UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
	_stopButton.tag = 3;
	_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
					 UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
	
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	
	myToolbar = [[UIToolbar alloc] initWithFrame:
                 CGRectMake(0,(self.view.frame.size.height-55)- TTToolbarHeight(), self.view.frame.size.width, TTToolbarHeight())];
	myToolbar.autoresizingMask =
	UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	myToolbar.barStyle = UIBarStyleBlack;
    
	myToolbar.items = [NSArray arrayWithObjects:
                       _backButton, space, _forwardButton, space, _refreshButton, space, _actionButton, nil];
	[self.view addSubview:myToolbar];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self openURL:[NSURL URLWithString:webLinkFeedItem.customProperty.source]];
    
    NSString *url = [ScrybeUserImage getScrybeUserImageUrl:webLinkFeedItem.createdBy imageSize:@"48x48"];
    
    [headerView.userImageView setImage:url forState:UIControlStateNormal];

    
    headerView.sharingInfoLabel.text = [webLinkFeedItem.sharingInfo stringByRemovingHTMLTags];
    headerView.titleLabel.text = [webLinkFeedItem.title stringByRemovingHTMLTags];
    
    
    ///////////////////////// toolbar //////////////////////////////
    badgeView = badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(740, -5, 30, 30)];
    badgeView.fillColor = [UIColor blueColor];
    badgeView.value = webLinkFeedItem.conversationsCount;

    /////////////////////////////////////////////////////////////////////
    
    [self.view addSubview:headerView];
    
    _webView.delegate = self;
}

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    CGRect frame = self.view.frame;
    frame.origin.y = RESOURCE_HEADER_VIEW_HEIGHT;

    frame.size.height -=(2*TTToolbarHeight()+RESOURCE_HEADER_VIEW_HEIGHT);
    _webView.frame =frame;
    
       // frame.size.height -=(TTToolbarHeight()+2*RESOURCE_HEADER_VIEW_HEIGHT);
    /*_toolbar.height = TTToolbarHeight();
    _webView.height = self.view.height - _toolbar.height-44;
    _toolbar.top = self.view.height - _toolbar.height-MAIN_HEADER_VIEW_HEIGHT;*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateToolbarWithOrientation:self.interfaceOrientation];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [badgeView removeFromSuperview];
    badgeView = nil;
    
    [_webView stopLoading];
    _webView.delegate = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

} 

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

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
    
    [self updateToolbarWithOrientation:self.interfaceOrientation];
    UIButton * button = nil;
    switch (interfaceOrientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:

            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.bounds = CGRectMake(0, 5, 30.0, 30.0);
            
            [button setImage:[UIImage imageNamed:CommentWhitIcon] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showCommentPopover:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            self.navigationItem.rightBarButtonItem = barButton; 
            badgeView.hidden = NO;
            [self.navigationController.navigationBar addSubview:badgeView];
                    
			break;
			
		case UIInterfaceOrientationLandscapeRight:
		case UIInterfaceOrientationLandscapeLeft:
			badgeView.hidden = YES;
			self.navigationItem.rightBarButtonItem = nil;
			
			break;
	}
	

     // Return YES for supported orientations
	return YES;
}

//////////////////////////////////// Popover //////////////////////////////////
#pragma mark -
#pragma mark tool bar button handler
-(void) showCommentPopover:(id) sender
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sender];
	[[parentDelegate popoverController] presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    [barButton release];
}

//////////////////////////////////////////////////////////////////////////



#pragma -
#pragma mark collaboration


-(void)openSnippetCollaboration:(Conversation*)p_conversation
{
    
    
    ResourceLink *commentResourceLink = p_conversation.resourceLink;
    if([commentResourceLink.collaborationInfo.snippetData.type isEqualToString:IMAGE_SNIPPET])
    {
        
    }else if([commentResourceLink.collaborationInfo.snippetData.type isEqualToString:NOTE_SNIPPET]){
        
        SnippetData *snippetData = commentResourceLink.collaborationInfo.snippetData;
        NSString *txtSnippet = [snippetData.data objectForKey:@"text"];
        
        //[_webView removeAllHighlights];
        NSLog(@"search count:%d",[_webView highlightAllOccurencesOfString:txtSnippet]);
        
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeRect:) userInfo:nil repeats:NO]; 

    }
}
@end
