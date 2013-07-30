//
//  ScrybeThumbnailViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeThumbnailViewController.h"
#import "PhotoSet.h"
#import "Photo.h"
#import "Note.h"
#import "AccountManager.h"
#import "NoteCustomProperties.h"
#import "NoteApplicationState.h"

#import "SnippetData.h"

@implementation ScrybeThumbnailViewController

@synthesize noteItem;
@synthesize imageDetailViewController;
@synthesize managingViewController;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem resourceLink:(ResourceLink*)resourceLinkObj
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(processImagesData:)
		 name:@"MoreImagesArrived"
		 object:nil ];
		
        managingViewController = aViewController;
        self.title = @"Image Gallery";
        
        self.noteItem = (Note*)feedItem;
        
        isAlreadyVisited  =  NO;        
        [self processImagesArray:noteItem.imagesArray];
        
        resourceLink = [resourceLinkObj retain];
        
        
        imageDetailViewController = [[ScrybeImageDetailViewController alloc] initWithFeedItem:noteItem ResourceLink:resourceLink];

    }
    return self;
}


- (id)initWithParentViewController:(UIViewController *)aViewController withNoteObject:(FeedItem*)feedItem
{
    self = [super init];
    if (self) {
		
 		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(processImagesData:)
		 name:@"MoreImagesArrived"
		 object:nil ];
		
        managingViewController = aViewController;
        self.title = @"Image Gallery";
        
        self.noteItem = (Note*)feedItem;

        isAlreadyVisited  =  NO;        
        //[self processImagesArray:noteItem.imagesArray];

    }
    return self;
}

-(void)processImagesArray:(NSArray*)imagesArray
{
    //NSArray *photosInfoArray = ((Note*)noteItem).imagesArray;
	NSMutableArray *photos = [[NSMutableArray alloc] init];
	
	NSString *amazonS3PathOffset = [AccountManager sharedAccountManager].amazonWebService.accountS3Path;
	//url = [url stringByAppendingString:@"note"];
	//url = [url stringByAppendingString:[NSString stringWithFormat:@"%@",note.resourceID]];
	//url = [url stringByAppendingString:@"/thumbnails/"];
	
	
	for (int i = 0; i < [imagesArray count]; i++) {
		NoteCustomProperties *noteProperty = ((NoteCustomProperties*)[imagesArray objectAtIndex:i]);
		
		NSString *largeURL = [amazonS3PathOffset stringByAppendingFormat:@"note%@/%@",noteItem.resourceId,noteProperty.originalName];
		NSString *previewURL = [amazonS3PathOffset stringByAppendingFormat:@"note%@/%@",noteItem.resourceId,noteProperty.previewName];
		NSString *thumbnailURL = [amazonS3PathOffset stringByAppendingFormat:@"note%@/thumbnails/%@",noteItem.resourceId,noteProperty.thumbnailName];
		
		//NSLog(@"Img Name:%@\nwidth:%d\nheight:%d",noteProperty.name,noteProperty.width,noteProperty.height);
		
		Photo *photo = [[Photo alloc] initWithCaption:noteProperty.name 
											 urlLarge:largeURL 
											 urlSmall:previewURL
											 urlThumb:thumbnailURL 
												 size:CGSizeMake(noteProperty.width, noteProperty.height) photoID:noteProperty.file_Id itemID:noteProperty.item_Id];
		
		[photos addObject:photo];
		[photo release];
		
		
	}
    
  
    /**/
    @synchronized(self){
        [_photoSet release];
        _photoSet = [[PhotoSet alloc] initWithTitle:@"Image Gallery" photos:photos];
	}
    
    [photos release];
    self.photoSource = _photoSet;
    imageDetailViewController.photoSource = self.photoSource;
	[_tableView reloadData];
    
}

-(void)processImagesData:(NSNotification*)notification
{
	NSArray* photosInfoArray = (NSArray*)[notification object];
    [self processImagesArray:photosInfoArray];
	
}


-(void)moveToDetailPhoto:(NSString*)p_photoId
{
    /*
    //NSLog(@"Move to photo Index:%d",targetPhoto.index);
    Photo *targetPhoto = [_photoSet getMatchingPhoto:photo];
    NSLog(@"Move to photo Index:%d",targetPhoto.index);
    //NSLog(@"Move to photo id:%d",targetPhoto.photoId);
    //[imageDetailViewController setCenterPhoto:targetPhoto];
    //Photo *trgtPhoto = (Photo*)photo;
    
    //NSLog(@"photo index:%d",trgtPhoto.index);
    [(TTPhotoViewController*)imageDetailViewController moveToPhotoAtIndex:targetPhoto.index withDelay:NO];
    //[(TTPhotoViewController*)imageDetailViewController refresh];
    [self.managingViewController.navigationController pushViewController:imageDetailViewController animated:YES];
    NSLog(@"thumb view to Image DetailView");
    */
    
    
    NoteAppState currentState = [[NoteApplicationState sharedNoteApplicationState] getNoteAppState];
    
    if (imageDetailViewController.managerViewControllerDelegate == nil) {
           imageDetailViewController.managerViewControllerDelegate = managingViewController;
    }
 

    
    
    
    Photo *targetPhoto = [_photoSet getPhotoForPhotoID:p_photoId];
    
    switch (currentState) {
        case IMAGE_DETAIL_VIEW:
            
            if ([imageDetailViewController respondsToSelector:@selector(moveToImage:)]) {
                [imageDetailViewController performSelector:@selector(moveToImage:) withObject:targetPhoto];
            } 
            
            break;
        case THUMB_VIEW:
        case NOTE_VIEW:
            if ([imageDetailViewController respondsToSelector:@selector(moveToImage:)]) {
                [imageDetailViewController performSelector:@selector(moveToImage:) withObject:targetPhoto];
            }
            [self.managingViewController.navigationController pushViewController:imageDetailViewController animated:YES];
            break;
        default:
            
            break;
    }
    
    


    
    /*
    if (currentState != IMAGE_DETAIL_VIEW) {
        
        
        
        // if already on that image no need to move any thing
        if ([targetPhoto isEqual:imageDetailViewController.centerPhoto]) {
            [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];
            return;
        }
        else
        {
            if ([imageDetailViewController respondsToSelector:@selector(moveToImage:)]) {
                [imageDetailViewController performSelector:@selector(moveToImage:) withObject:targetPhoto];
            }
            [self.managingViewController.navigationController pushViewController:imageDetailViewController animated:YES];
            
        }
 
    }
 	*/
 

}

////// Table view layout
- (void) updateTableLayout {
	[super updateTableLayout];
	self.tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(TTBarsHeight(),0, 0, 0);
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView reloadData];
    
    /*if (isAlreadyVisited) {
        [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:THUMB_VIEW];
    }
    */
    [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:THUMB_VIEW];
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

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.photoSource = _photoSet;//[PhotoSet samplePhotoSet];
	self.delegate = self; 
    

}


#pragma Mark -
#pragma mark TTThumbsViewController Delegate

- (void)thumbsViewController: (TTThumbsViewController*)controller
              didSelectPhoto: (id<TTPhoto>)photo;
{	
   
      
  // NoteAppState currentState = [[NoteApplicationState sharedNoteApplicationState] getNoteAppState];
    [[NoteApplicationState sharedNoteApplicationState] setNoteAppState:IMAGE_DETAIL_VIEW];

    
    if (imageDetailViewController.managerViewControllerDelegate == nil) {
        imageDetailViewController.managerViewControllerDelegate = managingViewController;
    }
    
    
    [imageDetailViewController setCenterPhoto:photo];
    [self.managingViewController.navigationController pushViewController:imageDetailViewController animated:YES];
        NSLog(@"thumb view to Image DetailView");

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];

    [imageDetailViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self updateTableLayout];
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark Collaboration

-(void)annotateImageSnippet:(SnippetData*)snippetData
{
	//NSString *name = [[snippet objectForKey:@"data"] objectForKey:@"pagename"];
	
	//NSLog(@"Recieved snippet:%@",snippetData.data);
	
    NSInteger fileId = [[snippetData.data objectForKey:@"fileId"] intValue];
    NSString *photoID = [NSString stringWithFormat:@"%d",fileId];
    NSLog(@"photo id :%@",photoID);
    
    //move to first photo so that current state can be set too
   [self moveToDetailPhoto:@""];

    NSDictionary *snippetSelectionRect = [snippetData.data objectForKey:@"selectionRect"];
    //NSDictionary *snippetRect =  [snippetData.data objectForKey:@"rect"];
    
    NSMutableDictionary *snippetInfo = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:photoID, snippetSelectionRect, nil] forKeys:[NSArray arrayWithObjects:@"file_id",@"selectionRect",nil]];
    
    Photo *targetPhoto = [_photoSet getPhotoForPhotoID:photoID];

    [imageDetailViewController showSnippetForPhoto:targetPhoto snippetData:snippetInfo];
	/*
	for (int i = 0; i<[_photoSet.photos count]; i++) {
		id<TTPhoto>photo = [_photoSet.photos objectAtIndex:i];
		if ([[photo caption] isEqualToString:name]) {
			myPhotoViewController.centerPhoto = photo;
			break;
		}
		
	}
	
	[imageDetailViewController performSelector:@selector(annotatePhotoWithRect:) withObject:snippet];
    */
}


@end
