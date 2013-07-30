//
//  NSArray+PerformSelector.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NSArray+PerformSelector.h"


@implementation NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector {
    NSMutableArray * results = [NSMutableArray array];
    
    for (id object in self) {
        id result = [object performSelector:selector];
        [results addObject:result];
    }
    
    return results;
}

@end