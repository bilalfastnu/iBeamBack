//
//  FilterFeedRemoteCaller.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RemoteCaller.h"



@interface FilterFeedRemoteCaller : RemoteCaller {
   

}




-(void)pollFeed:(NSArray *)groupIDsArray withFiltersObject:(NSDictionary*)filtersObject;

-(void)fetchFeedForFilter:(NSDictionary *) filterDictionary ofPageNumber:(NSInteger) page;

@end
