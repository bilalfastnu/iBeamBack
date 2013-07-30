//
//  NSArray+PerformSelector.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector;

@end

