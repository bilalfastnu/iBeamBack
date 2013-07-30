//
//  Photo.h
//  PhotoViewer
//
//  Created by Ray Wenderlich on 6/30/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface Photo : NSObject <TTPhoto> {
    NSString *_caption;
    NSString *_urlLarge;
    NSString *_urlSmall;
    NSString *_urlThumb;
    id <TTPhotoSource> _photoSource;
    CGSize _size;
    NSInteger _index;
    
    NSString *photoId;
    NSString *itemId;
}
@property (nonatomic, retain) NSString *photoId;
@property (nonatomic, retain) NSString *itemId;

@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *urlLarge;
@property (nonatomic, copy) NSString *urlSmall;
@property (nonatomic, copy) NSString *urlThumb;
@property (nonatomic, assign) id <TTPhotoSource> photoSource;
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger index;

- (id)initWithCaption:(NSString *)caption urlLarge:(NSString *)urlLarge urlSmall:(NSString *)urlSmall urlThumb:(NSString *)urlThumb size:(CGSize)size photoID:(NSString*)p_photoId itemID:(NSString*)itme_Id;

@end