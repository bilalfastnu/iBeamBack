//
//  LineTool.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface LineTool : NSObject <Tool> {
  id <ToolDelegate> delegate;
  NSMutableArray *trackingTouches;
  NSMutableArray *startPoints;
	
	//CGPoint rectPoint1, rectPoint2;
}

+(LineTool*)sharedLineTool;

@end
