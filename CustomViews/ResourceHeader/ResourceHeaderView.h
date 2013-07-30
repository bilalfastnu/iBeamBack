//
//  ResourceHeaderView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>
#import "ScrybeImageThumbView.h"

@interface ResourceHeaderView : UIView {
 	UILabel *titleLabel;
	UILabel *sharingInfoLabel;
	ScrybeImageThumbView *userImageView;
}

@property (nonatomic, retain) UILabel		*titleLabel;
@property (nonatomic, retain) UILabel		*sharingInfoLabel;
@property (nonatomic, retain) ScrybeImageThumbView	*userImageView;

@end