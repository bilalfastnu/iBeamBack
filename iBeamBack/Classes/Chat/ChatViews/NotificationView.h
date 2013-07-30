//
//  NotificationView.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>




@interface NotificationView : UIView {
	UILabel *userNameLabel;
	UILabel *messageLabel;
    TTImageView *notifierImageView;
    NSString *notifierId;
    
    
    
}
@property(nonatomic,retain) NSString *notifierId;
@property(nonatomic,retain) TTImageView *notifierImageView;
@property(nonatomic,retain)UILabel *userNameLabel;
@property(nonatomic,retain)UILabel *messageLabel;


@end
