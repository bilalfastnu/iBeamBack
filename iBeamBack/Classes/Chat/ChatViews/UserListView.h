//
//  UserListView.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/22/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>


@interface UserListView : UIView {
    
    UIImageView *statusImageView;
    TTImageView *profileImageView;
    UILabel *userName;
    
}
@property(nonatomic,retain)UILabel *userName;
@property(nonatomic,retain)TTImageView *profileImageView;
@property(nonatomic,retain)UIImageView *statusImageView;
@end
