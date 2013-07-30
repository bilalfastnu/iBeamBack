//
//  Milestone.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeedItem.h"
#import "MilestoneCustomProperties.h"

@interface Milestone : FeedItem {
    
    MilestoneCustomProperties *customProperty;
}
@property (nonatomic, retain) MilestoneCustomProperties *customProperty;

//Actions
-(id)initWithFeedData:(NSDictionary*)data;

@end
