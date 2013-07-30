//
//  ScrybeImageThumbView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeImageThumbView.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

@implementation ScrybeImageThumbView

@synthesize tag;
@synthesize thumbViewImage;
//////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = TTSTYLEVAR(thumbnailBackgroundColor);
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setStylesWithSelector:@"thumbView:"];
        tag = nil;
        thumbViewImage = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Properties


//////////////////////////////////////////////////////////////////////////////
- (NSString*)thumbURL {
    return [self imageForState:UIControlStateNormal];
}


//////////////////////////////////////////////////////////////////////////////
- (void)setThumbURL:(NSString*)URL {
    [self setImage:URL forState:UIControlStateNormal];
}
//////////////////////////////////////////////////////////////////////////////
-(void) setThumbViewImage:(UIImage*)image
{
    [self setThumbImage:image forState:UIControlStateNormal];
}

//////////////////////////////////////////////////////////////////////////////
-(BOOL) setIsDrawBoundray:(BOOL) isDraw
{
   return [super setIsDrawOuterBoundray:isDraw];
}
//////////////////////////////////////////////////////////////////////////////



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
