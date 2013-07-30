//
//  PathDrawingInfo.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"

@interface PathDrawingInfo : NSObject <Drawable> {
  UIBezierPath *path;
  UIColor *fillColor;
  UIColor *strokeColor;
	
	CGRect pathBounds;
}
@property (nonatomic, assign) CGRect pathBounds;
@property (retain, nonatomic) UIBezierPath *path;
@property (retain, nonatomic) UIColor *fillColor;
@property (retain, nonatomic) UIColor *strokeColor;


-(CGRect)getPathBounds;
- (id)initWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s;
+ (id)pathDrawingInfoWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s;

@end
