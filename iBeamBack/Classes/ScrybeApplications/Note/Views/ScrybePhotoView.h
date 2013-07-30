//
//  ScrybePhotoView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@protocol ScrybeImageViewDelegate;



@interface ScrybePhotoView : TTPhotoView<TTImageViewDelegate> {
    id<ScrybeImageViewDelegate> _scrybeImageDelegate;

}
@property(nonatomic, assign) id<ScrybeImageViewDelegate> scrybeImageDelegate;
@end


@protocol ScrybeImageViewDelegate <NSObject>

-(void)scrybeImageViewDidStartLoad;
-(void)scrybeImageViewDidLoadImage:(UIImage*)image forView:(ScrybePhotoView*)view;
-(void)scrybeImageViewDidFailLoadWithError:(NSError*)error;

@end