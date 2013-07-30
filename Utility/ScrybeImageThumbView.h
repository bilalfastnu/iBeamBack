//
//  ScrybeImageThumbView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>

@interface ScrybeImageThumbView : TTButton {
    id tag;
    
}
@property (nonatomic, retain) UIImage *thumbViewImage;
@property (nonatomic, copy) id tag;
@property (nonatomic, copy) NSString* thumbURL;

//Actions
-(void) setThumbViewImage:(UIImage*)image;
-(BOOL) setIsDrawBoundray:(BOOL) isDraw;


@end

