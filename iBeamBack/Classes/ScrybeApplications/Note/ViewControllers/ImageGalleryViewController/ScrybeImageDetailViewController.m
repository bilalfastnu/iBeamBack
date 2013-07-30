//
//  ScrybeImageDetailViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeImageDetailViewController.h"
#import "ScrybePhotoView.h"
#import "NoteApplicationState.h"
#import "Photo.h"
#import <QuartzCore/QuartzCore.h>
#import "NoteManagerViewController.h"
#import "PostCommentViewController.h"
#import "CONSTANTS.h"
#import "SnippetFactory.h"

#import "UIImage+Resize.h"
////////////////////////// Drawing////////////
#import "PencilTool.h"
#import "LineTool.h"
#import "RectangleTool.h"
#import "EllipseTool.h"
#import "FreehandTool.h"
//////////////////////////////////////////////


#import "SnippetData.h"
#import "Resource.h"
#import "ResourcePath.h"
#import "CollaborationInfo.h"


#define MAX_SNIPPET_WIDTH   200
#define MAX_SNIPPET_HEIGHT  56

@implementation ScrybeImageDetailViewController

@synthesize managerViewControllerDelegate;

@synthesize currentTool, fillColor, strokeColor, strokeWidth;
@synthesize dudelView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithFeedItem:(FeedItem*)p_FeedItem ResourceLink:(ResourceLink*)p_resourceLink;
{
    self = [super init];
    if (self) {

        managerViewControllerDelegate = nil;
        resourceLink = [p_resourceLink retain];
        feedItem = p_FeedItem;
        
    }
    return self;
}

-(TTPhotoView*)createPhotoView
{
    ScrybePhotoView *scrybeDetailImage = [[[ScrybePhotoView alloc] init] autorelease];
    scrybeDetailImage.scrybeImageDelegate = self;
    return scrybeDetailImage;
}

#pragma -
#pragma mark Collaboration Mechanism

-(void)moveToImage:(id<TTPhoto>)photo
{

    //Photo *detailPhoto = (Photo*)photo;
    
    if (photo == nil) {
		//[super moveToPhotoAtIndex:0 withDelay:NO];
        [self setCenterPhoto:nil];
    }
    else{
        
        //[super moveToPhotoAtIndex:detailPhoto.index withDelay:NO];
		[self setCenterPhoto:photo];
        
    }
}




#pragma -
#pragma mark Collaboration
////////////////////////////////////////////
-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIView*)imageView
{
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

-(CGRect)frameForDrawingViewForImage:(UIImage*)image
{
    UIImageView *aspectFitImageView = [[UIImageView alloc] initWithImage:image];
    aspectFitImageView.backgroundColor = [UIColor redColor];
    //CGSize size = myImage.size;
    
    
    
    aspectFitImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGPoint superCenter = CGPointMake([self.view bounds].size.width / 2.0, [self.view bounds].size.height / 2.0);
    [aspectFitImageView setCenter:superCenter];
    
    
    //CGRect frame =  CGRectMake(0, aspectFitImageView.frame.origin.y, size.width, size.height);
    CGRect frame =  CGRectMake(0, 0, 768, 1024);
    aspectFitImageView.frame = frame;
    
    
    frame = [self frameForImage:image inImageViewAspectFit:aspectFitImageView];
    //[self frameForImage:myImage inImageViewAspectFit:aspectFitImageView];
    //frame = CGRectMake(0, 0, myImage.size.width, myImage.size.height);
    aspectFitImageView.frame = frame;
    
    NSLog(@"Bounds of current Photo: bounds(%f,%f,%f,%f)",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height );
    [aspectFitImageView release];
    
    return frame;
}

-(void)showSnippetForPhoto:(id<TTPhoto>)photo snippetData:(NSDictionary*)snippetData
{
    shouldShowSnippetRect = YES;
    
    Photo *snippetPhoto = (Photo*)photo;
    
    [self moveToImage:snippetPhoto];
/* */   
    if ([[TTURLCache sharedCache] hasDataForURL:snippetPhoto.urlLarge]) {
        NSLog(@"Yes found image...");
        
        NSData *data = [[TTURLCache sharedCache] dataForURL:snippetPhoto.urlLarge];
        
        UIImage *myImage = [UIImage imageWithData:data];
        
        snippetDictionary = nil;
        snippetDictionary = [[NSMutableDictionary alloc] initWithDictionary:snippetData];

        [self annotateSnippetImage:myImage forPhoto:photo];
    }

    snippetDictionary = nil;
    snippetDictionary = [[NSMutableDictionary alloc] initWithDictionary:snippetData];

}

-(void)annotateSnippetImage:(UIImage*)image forPhoto:(id<TTPhoto>)photo
{
    if (shouldShowSnippetRect && snippetDictionary) {
       // NSLog(@"Snippet Dictionary:%@",snippetDictionary);
        
        Photo *loadedPhoto = (Photo*)photo;
        NSString *loadedPhotoId = loadedPhoto.photoId;
        
        NSString *snippetPhotoId = [snippetDictionary objectForKey:@"file_id"];
        
        if ([snippetPhotoId isEqualToString:loadedPhotoId]) {
           
            
           // ScrybePhotoView *currentPhotoView = (ScrybePhotoView*)_scrollView.centerPage; 
            
            
            CGRect frame = [self frameForDrawingViewForImage:image];

            
            CGRect drawingFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            ScrybePhotoView *currentPhotoView = (ScrybePhotoView*)_scrollView.centerPage;
            
            UIView *transparentDrawingView = [[UIView alloc] initWithFrame:drawingFrame];
            transparentDrawingView.backgroundColor = [UIColor colorWithRed:1.0 green:0.1 blue:1.0 alpha:0.0];
            //transparentDrawingView.backgroundColor = [UIColor redColor];
            
//            CGFloat widthScaleFactor = 1;//CGRectGetWidth(self.view.bounds) / image.size.width;
//            CGFloat heightScaleFactor = 1;//CGRectGetHeight(self.view.bounds) / image.size.height;
            CGFloat widthScaleFactor = CGRectGetWidth(frame) / image.size.width;
            CGFloat heightScaleFactor = CGRectGetHeight(frame) / image.size.height;
            
            CALayer *snippetRectLayer = [CALayer layer];
            
            CGFloat scaleVal = 1.0;//0.93333333;
            
            
            NSDictionary *selectionRectDict = (NSDictionary *)[snippetDictionary objectForKey:@"selectionRect"];
            NSLog(@"selection Rect:%@",snippetDictionary);
            NSLog(@"Image Size(%f, %f)",image.size.width, image.size.height);
            
            CGFloat x = [[selectionRectDict objectForKey:@"x"] floatValue];
            CGFloat y = [[selectionRectDict objectForKey:@"y"] floatValue];
            CGFloat width = [[selectionRectDict objectForKey:@"width"] floatValue];
            CGFloat height = [[selectionRectDict objectForKey:@"height"] floatValue];
            
            CGRect snippetFrame =  CGRectZero;
            
            
            snippetFrame = CGRectMake(x * scaleVal * widthScaleFactor, y * scaleVal * widthScaleFactor, width * scaleVal * widthScaleFactor, height * scaleVal * heightScaleFactor);
  
            
            //snippetFrame = CGRectMake(135.35f *scaleVal, 98.65f *scaleVal, 415.0f *scaleVal * widthScaleFactor, 273.0f*scaleVal *heightScaleFactor);
            snippetRectLayer.frame = snippetFrame;
            snippetRectLayer.borderColor = [UIColor redColor].CGColor;
            snippetRectLayer.borderWidth = 2.0;
            
            //add selection rect to the view
            [transparentDrawingView.layer addSublayer:snippetRectLayer];

            [currentPhotoView addSubview:transparentDrawingView];
            
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeRect:) userInfo:transparentDrawingView repeats:NO]; 

                    
            shouldShowSnippetRect = NO;
            snippetDictionary = nil;
        }
                
    }
}
    
-(void)removeRect:(NSTimer*)timer { 
	UIView *snippetView = (UIView*)[timer userInfo];
	[snippetView removeFromSuperview];
} 


#pragma -
#pragma mark TTImageView Delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)scrybeImageViewDidStartLoad {
    //[super imageViewDidStartLoad];
    
    NSLog(@"Scrybe ImageViewDidStarted called...");
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)scrybeImageViewDidLoadImage:(UIImage*)image forView:(ScrybePhotoView*)photoView {
    //[super imageViewDidLoadImage:image];
    NSLog(@"Scrybe imageViewDidLoadImage called...");
    
    shouldShowSnippetRect = YES;
    [self annotateSnippetImage:image forPhoto:photoView.photo];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrybeImageViewDidFailLoadWithError:(NSError*)error {
    //[super imageViewDidFailLoadWithError:error];
    
    NSLog(@"Scrybe imageViewDidFailLoadWithError :%@",error);
    
}






////////////////////////////////////////////////////////////////

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

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.fillColor = [UIColor lightGrayColor];
	self.strokeColor = [UIColor redColor];
	self.strokeWidth = 4.0;
    
    
    //////////// Shapes Tool popover //////////////
	
	//shapesPopOverOptions;
	UITableView *shapesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 140, 102)];
    shapesTableView.delegate = self;
    shapesTableView.dataSource = self;
	shapesTableView.scrollEnabled = NO;
	
	UIViewController *shapesContentController = [[UIViewController alloc] init];
	shapesContentController.title = @"Shapes";
	shapesContentController.view = shapesTableView;
	
	UINavigationController *shapesNavController = [[UINavigationController alloc] initWithRootViewController:shapesContentController];
	
	shapesPopOverOptions = [[UIPopoverController alloc] initWithContentViewController:shapesNavController];
	shapesPopOverOptions.popoverContentSize = CGSizeMake(300, 350);
	
	
	[shapesTableView release];
	[shapesContentController release];
	[shapesNavController release];
     
}

-(void)showDrawingShapes:(id)sender
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sender];
	[shapesPopOverOptions presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	//[commentsPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [toolBar.drawingShapes removeFromSuperview];
    [toolBar.editButton removeFromSuperview];
    toolBar.drawingShapes = nil;
    toolBar.editButton = nil;
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //_toolbar.frame = CGRectMake(0, 600, 768, 44.0f);
    
    
    toolBar = (CustomToolBar*)[(NoteManagerViewController*)managerViewControllerDelegate toolBar];
    
    if (toolBar.drawingShapes == nil) {
        
        toolBar.drawingShapes = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBar.drawingShapes.frame = CGRectMake(100, 0, 50.0, 40.0);
        
        [toolBar.drawingShapes setImage:[UIImage imageNamed:@"draw.png"] forState:UIControlStateNormal];
        //[ toolBar.drawingShapes setTitle:@"draw" forState:UIControlStateNormal];
        [ toolBar.drawingShapes addTarget:self action:@selector(showDrawingShapes:) forControlEvents:UIControlEventTouchUpInside];
        
        toolBar.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolBar.editButton.frame = CGRectMake(50, 0, 50.0, 40.0);
        
        [toolBar.editButton setImage:[UIImage imageNamed:@"Feed.png"] forState:UIControlStateNormal];
        [ toolBar.editButton addTarget:self action:@selector(drawingDone:) forControlEvents:UIControlEventTouchUpInside];

        [toolBar addSubview:toolBar.editButton];
        [toolBar addSubview:toolBar.drawingShapes];
        
        UIBarButtonItem *commentsButton = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
        self.navigationItem.rightBarButtonItem = commentsButton;
    }
    

    
    [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];

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
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    NSLog(@"image detailview controller rotatd...");
    /*
    CGRect frame = _toolbar.frame;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            
            //NSLog(@"Frame of toolbar:CGRectMake(%f,%f,%f,%f)",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height );

            _toolbar.frame = CGRectMake(0, 600, 768, 44.0f);
            NSLog(@"in portrait mode....");
            break;
            
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
            
            _toolbar.frame = CGRectMake(0, 600, frame.size.width - NOTE_MASTER_VIEW_WIDTH , 44.0f);
            
            NSLog(@"Frame of toolbar:CGRectMake(%f,%f,%f,%f)",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height );

            NSLog(@"in landscape mode....");
        default:
            break;
    }
   */
	return YES;
}


#pragma mark -
#pragma mark Shapes tableView delegate & dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		
	}
	
	switch (indexPath.row) {
            
		case 0:
			cell.imageView.image = [UIImage imageNamed:@"button_line.png"];
			cell.textLabel.text = @"Line";
			break;				
		case 1:
			cell.imageView.image = [UIImage imageNamed:@"button_ellipse.png"];
			cell.textLabel.text  = @"Ellipse";
			break;
		case 2:
			cell.imageView.image = [UIImage imageNamed:@"button_rectangle.png"];
			cell.textLabel.text = @"Rectangle";
			break;
		case 3:
			cell.imageView.image = [UIImage imageNamed:@"button_cdots.png"];
			cell.textLabel.text = @"Free hand";
			break;	
			
		default:
			break;
	}
	
	
	return cell;
}

-(void)addTransparentDrawingViewIfNeeded
{
    Photo *snippetPhoto = self.centerPhoto;
  
    if (dudelView == nil) {
        
        if ([[TTURLCache sharedCache] hasDataForURL:snippetPhoto.urlLarge]) {
            
            NSLog(@"Yes found image...");
            
            NSData *data = [[TTURLCache sharedCache] dataForURL:snippetPhoto.urlLarge];
            
            UIImage *image = [UIImage imageWithData:data];
            
            
            CGRect frame =  [self frameForDrawingViewForImage:image];
            
            CGRect drawingFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            self.dudelView = [[DrawingView alloc] initWithFrame:drawingFrame];
            
            //dudelView = [[DrawingView alloc] initWithFrame:self.view.frame];
            self.dudelView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
            self.dudelView.delegate = self;
            //self.dudelView.layer.borderColor = [UIColor redColor].CGColor;
            //self.dudelView.layer.borderWidth = 3.0f;
            
            
            
            ScrybePhotoView *currentPhotoView = (ScrybePhotoView*)_scrollView.centerPage;
            [currentPhotoView addSubview:dudelView];
            //[self.view addSubview:self.dudelView];
            
            _scrollView.scrollEnabled = NO;
        }

    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[self addTransparentDrawingViewIfNeeded];
    
    switch (indexPath.row) {
		case 0:
			[self touchLineItem:nil];
			break;
		case 1:
			[self touchEllipseItem:nil];
			break;
		case 2:
			[self touchRectangleItem:nil];
			break;
		case 3:
			[self touchPencilItem:nil];
			break;
		default:
			break;
	}
/*	*/
	[shapesPopOverOptions dismissPopoverAnimated:YES];
	
}


///////////////////////////////////////////////////////////////////////////
-(void) openPostCommentView:(ResourceLink *)noteResourceLink
{
    SnippetFactory *snippetFactory = [[SnippetFactory alloc] init];
    UIImage *snippetImage = [snippetFactory getImageSnippetForData:noteResourceLink.collaborationInfo.snippetData.data];
    
    UIImageView *imageSnippetView = [[UIImageView alloc] initWithImage:snippetImage];
    
	PostCommentViewController *viewController = [[[PostCommentViewController alloc] initWithParentViewController:nil withFeedItem:feedItem resourceLink:noteResourceLink withCommentActions:0] autorelease];
    
   imageSnippetView.frame = CGRectMake(100, 300, snippetImage.size.width, snippetImage.size.height);
    [viewController.view addSubview:imageSnippetView];
    [snippetFactory release];
	
    UINavigationController *modalViewNavController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
	modalViewNavController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	modalViewNavController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentModalViewController:modalViewNavController animated:YES];
    
}

///////////////////////////////////////////////////////////////////////////



#pragma mark -
#pragma mark Shapes Drawing

-(void)drawingDone:(id)sender
{
    
    if (dudelView) {
        CGRect boundRect = self.dudelView.boundingRect;
        
        
        _scrollView.scrollEnabled = YES;
        [dudelView.drawables removeAllObjects];
        [dudelView setNeedsDisplay];
        
        [dudelView removeFromSuperview];
        
        
        Photo *currentPhoto = self.centerPhoto;
        
        if ([[TTURLCache sharedCache] hasDataForURL:currentPhoto.urlLarge]) {
            
            NSLog(@"Yes found image...");
            
            NSData *photoImageData = [[TTURLCache sharedCache] dataForURL:currentPhoto.urlLarge];
            
            UIImage *image = [UIImage imageWithData:photoImageData];
            
            
            CGRect frame =  [self frameForDrawingViewForImage:image];
            
            //CGRect drawingFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            CGFloat scaleFactor = fmax( CGRectGetWidth(frame) / image.size.width , CGRectGetHeight(frame) / image.size.height );
            //CGFloat heightScaleFactor = CGRectGetHeight(frame) / image.size.height;
            
            CGRect snippetFrame = CGRectMake(boundRect.origin.x / scaleFactor, boundRect.origin.y / scaleFactor, boundRect.size.width / scaleFactor, boundRect.size.height / scaleFactor);
            
            NSLog(@"Bounds of selection After scaling downl: bounds(%f,%f,%f,%f)",snippetFrame.origin.x, snippetFrame.origin.y, snippetFrame.size.width, snippetFrame.size.height );
            
            CGImageRef imageRef = image.CGImage;
            CGImageRef snippetImageRef = CGImageCreateWithImageInRect(imageRef, snippetFrame);
            
            UIImage *snippetImage = [[UIImage alloc] initWithCGImage:snippetImageRef];
            
            
            /////////////////////////////////////// Performing scaling operations ///////////////
            
            //CGFloat scaleVal = 1.0f;
            /**/
            CGFloat scaleW = 1.0f;        
            CGFloat scaleH = 1.0f;
            
            if(CGRectGetWidth(snippetFrame) > MAX_SNIPPET_WIDTH )
            {
                scaleW = MAX_SNIPPET_WIDTH / CGRectGetWidth(snippetFrame) ;
            }
            if (CGRectGetHeight(snippetFrame) > MAX_SNIPPET_HEIGHT) {
                scaleH = MAX_SNIPPET_HEIGHT / CGRectGetHeight(snippetFrame) ;
            }
            
            CGFloat scaleVal = fmax(scaleH,scaleW);
            CGSize targetSize = CGSizeMake(CGRectGetWidth(snippetFrame) * scaleVal, CGRectGetHeight(snippetFrame) * scaleVal);
            
            NSLog(@"Bounds scaled :%f, Image: bounds(%f,%f)",scaleVal, targetSize.width, targetSize.height );
            
            
            UIImage *scaledImage = [snippetImage imageByScalingProportionallyToSize:targetSize];
            NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.75);
            
            
            //////////////////////////////////////////////////////////////////////////////////////
            
            //Converting NSData to Byte array
            NSUInteger len = [imageData length];
            Byte *byteData = (Byte*)malloc(len);
            memcpy(byteData, [imageData bytes], len);
            
            NSMutableArray *pixels = [[NSMutableArray alloc] init];
            
            for (int i = 0 ; i < len ; i++) {
                
                unsigned char value = byteData[i];
                NSNumber *test = [NSNumber numberWithUnsignedChar:value];
                
                [pixels addObject:test];
                
            }
            free(byteData);
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            //[data setObject:pixels forKey:@"pixels"];
            
            NSNumber *scaledImageWidth = [NSNumber numberWithFloat:scaledImage.size.width];
            NSNumber *scaledImageHeight = [NSNumber numberWithFloat:scaledImage.size.height];
            
            //NSNumber *scaledImageWidth = [NSNumber numberWithFloat:snippetFrame.size.width];
            //NSNumber *scaledImageHeight = [NSNumber numberWithFloat:snippetFrame.size.height];
            
            [data setObject:scaledImageWidth forKey:@"width"];
            [data setObject:scaledImageHeight forKey:@"height"];
            
            [data setObject:currentPhoto.photoId forKey:@"fileId"]; 
            [data setObject:@"1" forKey:@"isJPG"];
            [data setObject:@"1" forKey:@"pageNo"];
            [data setObject:currentPhoto.caption forKey:@"pagename"];
            
            NSNumber *snippetScalVal = [NSNumber numberWithFloat:scaleVal];
            [data setObject:snippetScalVal forKey:@"scale"];
            //        NSNumber *snippetScalVal = [NSNumber numberWithFloat:scaleFactor];
            //        [data setObject:snippetScalVal forKey:@"scale"];
            
            
            ////////////////////////// prepare rect///////////////////////////
            NSMutableDictionary *drawingRect = [[NSMutableDictionary alloc] init];
            
            CGRect drawingViewRect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            [drawingRect setObject:[NSNumber numberWithFloat:drawingViewRect.origin.x] forKey:@"x"];
            [drawingRect setObject:[NSNumber numberWithFloat:drawingViewRect.origin.y] forKey:@"y"];
            [drawingRect setObject:[NSNumber numberWithFloat:CGRectGetWidth(drawingViewRect)] forKey:@"width"];
            [drawingRect setObject:[NSNumber numberWithFloat:CGRectGetHeight(drawingViewRect)] forKey:@"height"];
            
            [data setObject:drawingRect forKey:@"rect"];
            
            
            ////////////////////////// prepare selectionRect //////////////////////
            NSMutableDictionary *selectionRect = [[NSMutableDictionary alloc] init];
            
            [selectionRect setObject:[NSNumber numberWithFloat:snippetFrame.origin.x] forKey:@"x"];
            [selectionRect setObject:[NSNumber numberWithFloat:snippetFrame.origin.y] forKey:@"y"];
            [selectionRect setObject:[NSNumber numberWithFloat:CGRectGetWidth(snippetFrame)] forKey:@"width"];
            [selectionRect setObject:[NSNumber numberWithFloat:CGRectGetHeight(snippetFrame)] forKey:@"height"];
            
            [data setObject:selectionRect forKey:@"selectionRect"];
            ////////////////////////////////////////////////////////////
            
            
            NSLog(@"snippetData %@", data);
            /*//////////////////////////////  Now make complete snippet data ////////////*/
            [data setObject:pixels forKey:@"pixels"];
            
            SnippetData *imageSnippetData = [[SnippetData alloc] initWithType:@"scrybe.components.snippet.MarkupBitmapSnippet" data:data];
            
            //scrybe.components.snippet.BitmapSnippet
            
            ResourceLink *newResourceLink = [resourceLink copy];
            
            Resource *resource = [[Resource alloc] init];
            
            resource.type = @"IMAGE";
            resource.uid = currentPhoto.photoId;
            resource.title = currentPhoto.caption;
            
            NSMutableArray *hierarchyClone = [[NSMutableArray alloc] initWithArray:newResourceLink.resourcePath.hierarchy copyItems:YES];
            
            //NSLog(@"heirarchy length:%d",[hierarchyClone count]);
            if ([hierarchyClone count] == 2) {
                [hierarchyClone replaceObjectAtIndex:1 withObject:resource];
            }else if ([hierarchyClone count] < 2)
                [hierarchyClone addObject:resource];
            
            
            newResourceLink.resourcePath.hierarchy = hierarchyClone;
            
            
            CollaborationInfo *collaborationObj = [[CollaborationInfo alloc] initWithSnippetData:imageSnippetData parentResourceIndex:feedItem.resourceDepth]; 
            
            newResourceLink.collaborationInfo = collaborationObj;
            
            
            [self openPostCommentView:newResourceLink];
            
            dudelView = nil;
        }

    }
    
 
}



- (void)deselectAllToolButtons {
	//[freehandButton setImage:[UIImage imageNamed:@"button_bezier.png"]];
	//[ellipseButton setImage:[UIImage imageNamed:@"button_ellipse.png"]];
	//[rectangleButton setImage:[UIImage imageNamed:@"button_rectangle.png"]];
	//[lineButton setImage:[UIImage imageNamed:@"button_line.png"]];
	//[pencilButton setImage:[UIImage imageNamed:@"button_cdots.png"]];
}


- (void)setCurrentTool:(id <Tool>)t {
	[currentTool deactivate];
	if (t != currentTool) {
		[currentTool release];
		currentTool = [t retain];
		currentTool.delegate = self;
		[self deselectAllToolButtons];
	}
	[currentTool activate];
	[dudelView setNeedsDisplay];
}


- (void)touchFreehandItem:(id)sender {
	self.currentTool = [FreehandTool sharedFreehandTool];
	//[freehandButton setImage:[UIImage imageNamed:@"button_bezier_selected.png"]];
}

- (void)touchEllipseItem:(id)sender {
	self.currentTool = [EllipseTool sharedEllipseTool];
	//[ellipseButton setImage:[UIImage imageNamed:@"button_ellipse_selected.png"]];
}
- (void)touchRectangleItem:(id)sender {
	self.currentTool = [RectangleTool sharedRectangleTool];
	//[rectangleButton setImage:[UIImage imageNamed:@"button_rectangle_selected.png"]];
}
- (void)touchLineItem:(id)sender {
	self.currentTool = [LineTool sharedLineTool];
	//[lineButton setImage:[UIImage imageNamed:@"button_line_selected.png"]];
}
- (void)touchPencilItem:(id)sender {
	self.currentTool = [PencilTool sharedPencilTool];
	//[pencilButton setImage:[UIImage imageNamed:@"button_cdots_selected.png"]];
}

#pragma mark ToolDelegate

- (void)addDrawable:(id <Drawable>)d {
	[dudelView.drawables addObject:d];
	[dudelView setNeedsDisplay];
}

- (UIView *)viewForUseWithTool:(id <Tool>)t {
	//return self.view;
    return self.dudelView;
}

#pragma mark DudelViewDelegate

- (void)drawTemporary {
	[self.currentTool drawTemporary];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTool touchesBegan:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTool touchesCancelled:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTool touchesEnded:touches withEvent:event];
	[dudelView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTool touchesMoved:touches withEvent:event];
	[dudelView setNeedsDisplay];
}



@end
