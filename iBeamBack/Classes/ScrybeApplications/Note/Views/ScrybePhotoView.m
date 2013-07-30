//
//  ScrybePhotoView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "ScrybePhotoView.h"


@implementation ScrybePhotoView

@synthesize scrybeImageDelegate = _scrybeImageDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self)
    {
        self.delegate = self;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/**/
#pragma -
#pragma mark TTImageView Delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidStartLoad {
    //[super imageViewDidStartLoad];
    
    NSLog(@"ImageViewDidStarted called...");
    
    if ([_scrybeImageDelegate respondsToSelector:@selector(scrybeImageViewDidStartLoad)]) {
        [_scrybeImageDelegate performSelector:@selector(scrybeImageViewDidStartLoad)];
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidLoadImage:(UIImage*)image {
    //[super imageViewDidLoadImage:image];
    NSLog(@"imageViewDidLoadImage called...");
    
    if ([_scrybeImageDelegate respondsToSelector:@selector(scrybeImageViewDidLoadImage:forView:)]) {
        [_scrybeImageDelegate performSelector:@selector(scrybeImageViewDidLoadImage:forView:) withObject:image withObject:self];
    }

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imageViewDidFailLoadWithError:(NSError*)error {
    //[super imageViewDidFailLoadWithError:error];
    
    NSLog(@"imageViewDidFailLoadWithError :%@",error);
    
    if ([_scrybeImageDelegate respondsToSelector:@selector(scrybeImageViewDidFailLoadWithError:)]) {
        [_scrybeImageDelegate performSelector:@selector(scrybeImageViewDidFailLoadWithError:) withObject:error];
    }

}


- (void)dealloc
{
    [super dealloc];
}

@end
