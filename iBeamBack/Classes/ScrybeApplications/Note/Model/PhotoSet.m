//
//  PhotoSet.m
//  PhotoViewer
//
//  Created by Ray Wenderlich on 6/30/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"

@implementation PhotoSet
@synthesize title = _title;
@synthesize photos = _photos;
@synthesize numberOfPhotos;


- (id) initWithTitle:(NSString *)title photos:(NSArray *)photos {
    if ((self = [super init])) {
        self.title = title;
        self.photos = photos;
        for(int i = 0; i < _photos.count; ++i) {
            Photo *photo = [_photos objectAtIndex:i];
            photo.photoSource = self;
            photo.index = i;
        }        
    }
    return self;
}

- (void) dealloc {
    self.title = nil;
    self.photos = nil;    
    [super dealloc];
}

#pragma mark TTModel

- (BOOL)isLoading { 
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return _photos.count;
}

- (NSInteger)maxPhotoIndex {
    return _photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < _photos.count) {
        return [_photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}


-(Photo*)getPhotoForPhotoID:(NSString*)p_photoId
{
    
    NSEnumerator *photosEnumerator = [_photos objectEnumerator];
    Photo *srcPhoto = nil;
    //NSLog(@"Large URL:%@",photo.urlLarge);
    while (srcPhoto = [photosEnumerator nextObject]) {      
        
        //NSLog(@"THis URL:%@",srcPhoto.urlLarge);

        if ([srcPhoto.photoId isEqualToString:p_photoId] /* &&  [srcPhoto.urlLarge isEqualToString:photo.urlLarge] */ ) {
            
            //NSLog(@"yes photo found...");
            return srcPhoto;
        }
    }
    return nil;
}

#pragma mark Singleton

static PhotoSet *samplePhotoSet = nil;

+ (PhotoSet *) samplePhotoSet {
	
	NSArray *imagesURLs = [[NSArray alloc] initWithObjects:
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/A8D684ED-5111-274D-3A4D-30448CEB394A-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/E96A4AD3-37A0-777D-0120-30448CEC2773-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/A9D9DB51-174E-9F71-0D33-304C4979A893-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/113411D7-AE75-43C7-77D9-304C497C9233-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C75BF9FD-ECE6-1979-81DD-3042287A1973-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C6A7FB16-6376-F826-8EC8-303A66B9A4B4-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C3652CA3-8F77-183F-636F-304C497D22B7-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/6A994B74-390D-7921-9701-30448CED3D97-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/4D2781DA-E003-2659-ABF2-30448CEE270C-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/E5A1D1D3-40CD-AFBE-35AD-303A66D4631C-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/2347D1DF-4BA8-8DC0-AB34-30448CEEFDE2-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/00223A4C-FF79-CA0B-3D35-3042287C0665-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/468ED49C-A86C-67D5-401A-3042287C53DE-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/9F8F4B0B-4372-F73B-47A0-3042287D2DC3-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/EF2A0DD5-CC86-43A3-936C-303A66D63719-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/762090A2-C630-AE58-78DF-3042287EC4BD-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/5F4C21AB-522B-EA5F-E425-303A66D7C904-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/08D53D5D-3BFE-F0D6-243E-30448CEF2238-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/59D26B0A-AD03-CFF5-2F21-303A66D70AB2-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/176668D3-6044-47A1-B9CB-304C497E85A2-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/CFDE23C8-CAD5-8A67-B320-303A66D80969-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C74507FD-6A79-7738-9AAA-30448CF02951-orignal.png",
						   @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/06A6AB0D-4DC7-167C-90D8-29E9FD4CAF91-orignal.jpg",
						   nil];
	NSArray *thumbnailURLs = [[NSArray alloc] initWithObjects:
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/A8D684ED-5111-274D-3A4D-30448CEB394A-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/E96A4AD3-37A0-777D-0120-30448CEC2773-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/A9D9DB51-174E-9F71-0D33-304C4979A893-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/113411D7-AE75-43C7-77D9-304C497C9233-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/C75BF9FD-ECE6-1979-81DD-3042287A1973-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/C6A7FB16-6376-F826-8EC8-303A66B9A4B4-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/C3652CA3-8F77-183F-636F-304C497D22B7-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/6A994B74-390D-7921-9701-30448CED3D97-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/4D2781DA-E003-2659-ABF2-30448CEE270C-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/E5A1D1D3-40CD-AFBE-35AD-303A66D4631C-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/2347D1DF-4BA8-8DC0-AB34-30448CEEFDE2-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/00223A4C-FF79-CA0B-3D35-3042287C0665-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/468ED49C-A86C-67D5-401A-3042287C53DE-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/9F8F4B0B-4372-F73B-47A0-3042287D2DC3-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/EF2A0DD5-CC86-43A3-936C-303A66D63719-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/762090A2-C630-AE58-78DF-3042287EC4BD-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/5F4C21AB-522B-EA5F-E425-303A66D7C904-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/08D53D5D-3BFE-F0D6-243E-30448CEF2238-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/59D26B0A-AD03-CFF5-2F21-303A66D70AB2-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/176668D3-6044-47A1-B9CB-304C497E85A2-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/CFDE23C8-CAD5-8A67-B320-303A66D80969-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/C74507FD-6A79-7738-9AAA-30448CF02951-thumbnail-165x125.jpg",
							  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/thumbnails/06A6AB0D-4DC7-167C-90D8-29E9FD4CAF91-thumbnail-165x125.jpg",
							  nil];
	NSArray *previewImagesURLs = [[NSArray alloc] initWithObjects:
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/A8D684ED-5111-274D-3A4D-30448CEB394A-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/E96A4AD3-37A0-777D-0120-30448CEC2773-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/A9D9DB51-174E-9F71-0D33-304C4979A893-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/113411D7-AE75-43C7-77D9-304C497C9233-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C75BF9FD-ECE6-1979-81DD-3042287A1973-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C6A7FB16-6376-F826-8EC8-303A66B9A4B4-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C3652CA3-8F77-183F-636F-304C497D22B7-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/6A994B74-390D-7921-9701-30448CED3D97-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/4D2781DA-E003-2659-ABF2-30448CEE270C-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/E5A1D1D3-40CD-AFBE-35AD-303A66D4631C-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/2347D1DF-4BA8-8DC0-AB34-30448CEEFDE2-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/00223A4C-FF79-CA0B-3D35-3042287C0665-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/468ED49C-A86C-67D5-401A-3042287C53DE-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/9F8F4B0B-4372-F73B-47A0-3042287D2DC3-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/EF2A0DD5-CC86-43A3-936C-303A66D63719-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/762090A2-C630-AE58-78DF-3042287EC4BD-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/5F4C21AB-522B-EA5F-E425-303A66D7C904-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/08D53D5D-3BFE-F0D6-243E-30448CEF2238-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/59D26B0A-AD03-CFF5-2F21-303A66D70AB2-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/176668D3-6044-47A1-B9CB-304C497E85A2-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/CFDE23C8-CAD5-8A67-B320-303A66D80969-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/C74507FD-6A79-7738-9AAA-30448CF02951-preview.png",
								  @"http://s3.amazonaws.com/dev-scrybe-files/acc-55162df4-ebf0-11df-a892-000f2075d66f/note4BBBD14F8630AC9C4A8043CE451CE106/06A6AB0D-4DC7-167C-90D8-29E9FD4CAF91-preview.jpg",
								  nil];
	
    @synchronized(self) {
		
		
        if (samplePhotoSet == nil) {
			
			NSMutableArray *photosArray = [[NSMutableArray alloc] init];
			
			for (int i = 0; i < [imagesURLs count]; i++) {
				Photo *photo = [[Photo alloc] initWithCaption:@"Math Ninja" 
															  urlLarge:[imagesURLs objectAtIndex:i] 
															  urlSmall:[previewImagesURLs objectAtIndex:i] 
															  urlThumb:[thumbnailURLs objectAtIndex:i] 
                                                         size:CGSizeMake(1024, 768) photoID:[imagesURLs objectAtIndex:i] itemID:@"123"];
                photo.index = i;
                [photosArray addObject:photo];
                [Photo release];
			}
			
			/*
			 Photo *mathNinja = [[[Photo alloc] initWithCaption:@"Math Ninja" 
			 urlLarge:@"http://www.raywenderlich.com/downloads/math_ninja_large.png" 
			 urlSmall:@"bundle://math_ninja_small.png" 
			 urlThumb:@"bundle://math_ninja_thumb.png" 
			 size:CGSizeMake(1024, 768)] autorelease];
			 Photo *instantPoetry = [[[Photo alloc] initWithCaption:@"Instant Poetry" 
			 urlLarge:@"http://www.raywenderlich.com/downloads/instant_poetry_large.png" 
			 urlSmall:@"bundle://instant_poetry_small.png" 
			 urlThumb:@"bundle://instant_poetry_thumb.png" 
			 size:CGSizeMake(1024, 748)] autorelease];
			 Photo *rpgCalc = [[[Photo alloc] initWithCaption:@"RPG Calc" 
			 urlLarge:@"http://www.raywenderlich.com/downloads/rpg_calc_large.png" 
			 urlSmall:@"bundle://rpg_calc_small.png" 
			 urlThumb:@"bundle://rpg_calc_thumb.png" 
			 size:CGSizeMake(640, 920)] autorelease];
			 Photo *levelMeUp = [[[Photo alloc] initWithCaption:@"Level Me Up" 
			 urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
			 urlSmall:@"bundle://level_me_up_small.png" 
			 urlThumb:@"bundle://level_me_up_thumb.png" 
			 size:CGSizeMake(1024, 768)] autorelease];
			 NSArray *photos = [NSArray arrayWithObjects:mathNinja, instantPoetry, rpgCalc, levelMeUp, nil];
			 samplePhotoSet = [[self alloc] initWithTitle:@"My Apps" photos:photos];
			 */
			samplePhotoSet = [[self alloc] initWithTitle:@"My Photos" photos:photosArray];
			
        }
		
    }
    return samplePhotoSet;
}

/*
#pragma mark Singleton

static PhotoSet *samplePhotoSet = nil;

+ (PhotoSet *) samplePhotoSet {
    @synchronized(self) {
        if (samplePhotoSet == nil) {
            Photo *mathNinja = [[[Photo alloc] initWithCaption:@"Math Ninja" 
                                                      urlLarge:@"http://www.raywenderlich.com/downloads/math_ninja_large.png" 
                                                      urlSmall:@"bundle://math_ninja_small.png" 
                                                      urlThumb:@"bundle://math_ninja_thumb.png" 
                                                          size:CGSizeMake(1024, 768)] autorelease];
            Photo *instantPoetry = [[[Photo alloc] initWithCaption:@"Instant Poetry" 
                                                          urlLarge:@"http://www.raywenderlich.com/downloads/instant_poetry_large.png" 
                                                          urlSmall:@"bundle://instant_poetry_small.png" 
                                                          urlThumb:@"bundle://instant_poetry_thumb.png" 
                                                              size:CGSizeMake(1024, 748)] autorelease];
            Photo *rpgCalc = [[[Photo alloc] initWithCaption:@"RPG Calc" 
                                                    urlLarge:@"http://www.raywenderlich.com/downloads/rpg_calc_large.png" 
                                                    urlSmall:@"bundle://rpg_calc_small.png" 
                                                    urlThumb:@"bundle://rpg_calc_thumb.png" 
                                                        size:CGSizeMake(640, 920)] autorelease];
            Photo *levelMeUp = [[[Photo alloc] initWithCaption:@"Level Me Up" 
                                                      urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
                                                      urlSmall:@"bundle://level_me_up_small.png" 
                                                      urlThumb:@"bundle://level_me_up_thumb.png" 
                                                          size:CGSizeMake(1024, 768)] autorelease];
		
			Photo *photo1 = [[[Photo alloc] initWithCaption:@"Level Me Up" 
                                                      urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
                                                      urlSmall:@"bundle://level_me_up_small.png" 
                                                      urlThumb:@"bundle://level_me_up_thumb.png" 
                                                          size:CGSizeMake(1024, 768)] autorelease];
			Photo *photo2 = [[[Photo alloc] initWithCaption:@"Level Me Up" 
												   urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
												   urlSmall:@"bundle://level_me_up_small.png" 
												   urlThumb:@"bundle://level_me_up_thumb.png" 
													   size:CGSizeMake(1024, 768)] autorelease];
			Photo *photo3 = [[[Photo alloc] initWithCaption:@"Level Me Up" 
												   urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
												   urlSmall:@"bundle://level_me_up_small.png" 
												   urlThumb:@"bundle://level_me_up_thumb.png" 
													   size:CGSizeMake(1024, 768)] autorelease];
			Photo *photo4 = [[[Photo alloc] initWithCaption:@"Level Me Up" 
												   urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
												   urlSmall:@"bundle://level_me_up_small.png" 
												   urlThumb:@"bundle://level_me_up_thumb.png" 
													   size:CGSizeMake(1024, 768)] autorelease];
			
            NSArray *photos = [NSArray arrayWithObjects:mathNinja, instantPoetry, rpgCalc, levelMeUp,photo1, photo2, photo3, photo4,mathNinja, instantPoetry, rpgCalc, levelMeUp, nil];
            samplePhotoSet = [[self alloc] initWithTitle:@"My Apps" photos:photos];
        }
    }
    return samplePhotoSet;
}
*/
@end
