//
//  Message.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeedItem.h"

@interface Message : FeedItem {
    
}

//Actions
-(id)initWithFeedData:(NSDictionary*)data;

@end
