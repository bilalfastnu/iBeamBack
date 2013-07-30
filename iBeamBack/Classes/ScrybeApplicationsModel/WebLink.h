//
//  WebLink.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeedItem.h"
#import "WebLinkCustomProperties.h"

@interface WebLink : FeedItem {
    
    FeedItem *feedItem;
    WebLinkCustomProperties *customProperty;
}
@property (nonatomic, retain) WebLinkCustomProperties *customProperty;


//Actions
-(id)initWithFeedData:(NSDictionary*)data;

@end
