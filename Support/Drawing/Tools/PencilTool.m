//
//  PencilTool.m
//  Dudel
//
//  Created by JN on 2/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PencilTool.h"
#import "PathDrawingInfo.h"

#import "SynthesizeSingleton.h"

@implementation PencilTool

@synthesize delegate;

SYNTHESIZE_SINGLETON_FOR_CLASS(PencilTool);

- init {
  if ((self = [super init])) {
    trackingTouches = [[NSMutableArray array] retain];
    startPoints = [[NSMutableArray array] retain];
    paths = [[NSMutableArray array] retain];
  }
  return self;
}


- (void)activate {
}

- (void)deactivate {
  [trackingTouches removeAllObjects];
  [startPoints removeAllObjects];
  [paths removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
	
	CGPoint location = CGPointMake(0, 0);
	
  for (UITouch *touch in [event allTouches]) {
    // remember the touch, and its original start point, for future
    [trackingTouches addObject:touch];
    location = [touch locationInView:touchedView];
    [startPoints addObject:[NSValue valueWithCGPoint:location]];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:location];
    [path setLineWidth:delegate.strokeWidth];
    [path addLineToPoint:location];
    [paths addObject:path];
  }
	//NSLog(@"Starting Point:( %f, %f )",location.x,location.y);
	rectPoint1 = location;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}
//
// Returns the 8x8 NSRect of the control point for a point specified by value.
//
- (CGRect)controlPointRectForPoint:(CGPoint)currentPoint
{
	const float CONTROL_POINT_SIZE = 8.0;
	
	CGRect controlPointRect =
	CGRectMake(
			   currentPoint.x - 0.5 * CONTROL_POINT_SIZE,
			   currentPoint.y - 0.5 * CONTROL_POINT_SIZE,
			   CONTROL_POINT_SIZE,
			   CONTROL_POINT_SIZE);
	
	return controlPointRect;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in [event allTouches]) {  
    // make a line from the start point to the current point
    NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      UIBezierPath *path = [paths objectAtIndex:touchIndex];
      PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:[UIColor clearColor] strokeColor:delegate.strokeColor];
      
		CGFloat width = fabs(rectPoint1.x - rectPoint2.x);
		CGFloat height = fabs(rectPoint1.y - rectPoint2.y);
		//NSLog(@"CGSize:( %f, %f )",width,height);
		/**/
		
		if ( (rectPoint1.x < rectPoint2.x) && (rectPoint1.y > rectPoint2.y)  ) {
			
			info.pathBounds = CGRectMake(rectPoint1.x ,rectPoint1.y - height, width,height);
			
		}else if ( (rectPoint2.x < rectPoint1.x) && (rectPoint1.y > rectPoint2.y)  ) {
			
			info.pathBounds = CGRectMake(rectPoint1.x - width ,rectPoint1.y - height, width,height);
			
		}else if ( (rectPoint2.x < rectPoint1.x) && (rectPoint2.y > rectPoint1.y)  ) {
			
			info.pathBounds = CGRectMake(rectPoint1.x - width ,rectPoint1.y , width,height);
		}
		else {
			info.pathBounds = CGRectMake(rectPoint1.x,rectPoint1.y, width,height);
		}

	  [delegate addDrawable:info];
      [trackingTouches removeObjectAtIndex:touchIndex];
      [startPoints removeObjectAtIndex:touchIndex];
      [paths removeObjectAtIndex:touchIndex];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];

	CGPoint location = CGPointMake(0, 0);
	
  for (UITouch *touch in [event allTouches]) {
    // make a line from the start point to the current point
    NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      location = [touch locationInView:touchedView];
      UIBezierPath *path = [paths objectAtIndex:touchIndex];
      [path addLineToPoint:location];
    }
  }
	
	//NSLog(@"Ending Point:( %f, %f )",location.x,location.y);
	//[boundingPoints addObject:[NSValue valueWithCGPoint:location]];
	
	rectPoint2 = location;
	
	//NSValue *val1 = [boundingPoints objectAtIndex:0];
	//NSValue *val2 = [boundingPoints objectAtIndex:[boundingPoints count]-1];
	
	//CGPoint p1 = [val1 CGPointValue];
	//CGPoint p2 = [val2 CGPointValue];
	//CGFloat width = fabs(rectPoint1.x - rectPoint2.x);
	//CGFloat height = fabs(rectPoint1.y - rectPoint2.y);
	//NSLog(@"CGSize:( %f, %f )",width,height);
	//NSLog(@"CGRect:( %f, %f, %f, %f  )",rectPoint1.x,rectPoint1.y, width,height);
}




- (void)drawTemporary {
  for (UIBezierPath *path in paths) {
    [delegate.strokeColor setStroke];
    [path stroke];
  }
	
}


- (void)dealloc {
  [trackingTouches release];
  [startPoints release];
  [paths release];
  self.delegate = nil;
  [super dealloc];
}

@end
