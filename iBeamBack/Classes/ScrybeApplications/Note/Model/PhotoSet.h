//
//  PhotoSet.h
//  PhotoViewer
//
//  Created by Ray Wenderlich on 6/30/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Photo.h"
@interface PhotoSet : TTURLRequestModel <TTPhotoSource> {
    NSString *_title;
    NSArray *_photos;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, readonly) NSInteger numberOfPhotos;

- (id) initWithTitle:(NSString *)title photos:(NSArray *)photos;

-(Photo*)getPhotoForPhotoID:(NSString*)photoId;

+ (PhotoSet *)samplePhotoSet;

@end

