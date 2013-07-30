//
//  DudelView.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DudelViewDelegate
- (void)drawTemporary;
@end

@interface DrawingView : UIView {
  NSMutableArray *drawables;
  id <DudelViewDelegate> delegate;
	
	CGRect boundingRect;	
}
@property (nonatomic, assign) CGRect boundingRect;
@property (nonatomic, retain) id <DudelViewDelegate> delegate;
@property (readonly) NSMutableArray *drawables;

@end
