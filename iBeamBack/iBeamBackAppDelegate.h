//
//  iBeamBackAppDelegate.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignInViewController;

@class FeedSplitViewController;

@interface iBeamBackAppDelegate : NSObject <UIApplicationDelegate> {

    SignInViewController *signInViewController;
    FeedSplitViewController *feedSplitViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
