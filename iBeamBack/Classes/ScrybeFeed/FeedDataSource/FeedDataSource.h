//
//  FeedDataSource.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Three20/Three20.h>

@class FeedDataModel;


@interface FeedDataSource : TTListDataSource {
    
    FeedDataModel *feedDataModel;
}

+(FeedDataSource*)sharedFeedDataSource;

-(void) fetchFeedForFilter:(NSDictionary*)filterDictionary forFilterType:(NSInteger)index;

@end
