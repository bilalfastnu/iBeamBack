//
//  BadgeView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BadgeView : UIView 
{
	NSUInteger _value;
	
	UIFont* _font;
	UIColor* _fillColor;
	UIColor* _strokeColor;
	UIColor* _textColor;
	NSUInteger _pad;
	
	BOOL _shadow;
	BOOL _shine;
	
	UITextAlignment _alignment;
}

// The current value displayed in the badge. Updating the value will update the view's display
@property (assign,nonatomic) NSUInteger value;

// Indicates whether the badge view draws a dhadow or not.
@property (assign,nonatomic) BOOL shadow;

// Indicates whether the badge view should be drawn with a shine
@property (assign,nonatomic) BOOL shine;

// The font to be used for drawing the numbers. NOTE: not all fonts are created equal for this purpose.
// Only "system fonts" should be used.
@property (retain,nonatomic) UIFont* font;

// The color used for the background of the badge.
@property (retain,nonatomic) UIColor* fillColor;

// The color to be used for drawing the stroke around the badge.
@property (retain,nonatomic) UIColor* strokeColor;

// The color to be used for drawing the badge's numbers.
@property (retain,nonatomic) UIColor* textColor;

// How the badge image hould be aligned horizontally in the view. 
@property (assign,nonatomic) UITextAlignment alignment;

// Returns the visual size of the badge for the current value. Not the same hing as the size of the view's bounds.
// The badge view bounds should be wider than space needed to draw the badge.
@property (readonly,nonatomic) CGSize badgeSize;

// The number of pixels between the number inside the badge and the stroke around the badge. This value 
// is approximate, as the font geometry might effectively slightly increase or decrease the apparent pad.
@property (nonatomic) NSUInteger pad;

@end
