//
//  TTStyledTextLinkLabel.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>

@protocol TTStyledTextLinkLabelDelegate;

@interface TTStyledTextLinkLabel : TTStyledTextLabel {
    
	NSObject <TTStyledTextLinkLabelDelegate> *delegate;
    
}
@property (nonatomic,retain) NSObject <TTStyledTextLinkLabelDelegate> *delegate;

@end


@protocol TTStyledTextLinkLabelDelegate

- (void)resourceTaped:(TTStyledTextLabel *)label receivedObject:(NSObject *)object;

@end