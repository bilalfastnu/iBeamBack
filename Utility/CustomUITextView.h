//
//  CustomUITextView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/23/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <QuartzCore/QuartzCore.h>

@interface CustomUITextView : UITextView <UITextViewDelegate> {
	NSString *placeholder;
	UIColor *placeholderColor;
}

@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notif;

@end
