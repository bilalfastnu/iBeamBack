//
//  DudelView.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DrawingView.h"

#import "Drawable.h"
#import "PathDrawingInfo.h"

@implementation DrawingView

@synthesize drawables, delegate;
@synthesize boundingRect;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    drawables = [[NSMutableArray alloc] initWithCapacity:100];
	  
	  boundingRect = CGRectZero;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    drawables = [[NSMutableArray alloc] initWithCapacity:100];    
  }
  return self;
}

- (void)drawRect:(CGRect)rect {

	CGRect unionRect = CGRectZero;
	if ([drawables count] > 0) {
		
		PathDrawingInfo *info = ((PathDrawingInfo *)[drawables objectAtIndex:0]);
		unionRect = [info getPathBounds];

	}
	
	
  for (id<Drawable> d in drawables) {
    [d draw];
	  PathDrawingInfo *info = ((PathDrawingInfo *)d);
	  unionRect = CGRectUnion(unionRect, [info getPathBounds]);
  }

	
       
    if (!CGRectIsEmpty(unionRect) && !(CGRectEqualToRect(boundingRect,unionRect))) {
        boundingRect = unionRect;
        NSLog(@"Bounding CGRect:( %f, %f, %f, %f  )",unionRect.origin.x,unionRect.origin.y, unionRect.size.width,unionRect.size.height);
    }
    
  /**/
	// Drawing code here.
	CGContextRef context = UIGraphicsGetCurrentContext();
	//CGContextSetRGBFillColor(c, 1.0, 0.0, 0.5, 1.0);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	//Define a rectangle
	CGContextAddRect(context, unionRect);

	//Draw it
	CGContextStrokePath(context);
	
  [delegate drawTemporary];
	
	
}


- (void)dealloc {
  [drawables release];
  [super dealloc];
}


@end
