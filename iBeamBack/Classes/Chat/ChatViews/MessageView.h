//
//  MessageView.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface MessageView : UIView {
	UIImageView *balloonView;
	TTImageView*userImageView;
	UILabel *label;
    
}
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UIImageView *balloonView;
@property(nonatomic,retain)TTImageView*userImageView;


@end