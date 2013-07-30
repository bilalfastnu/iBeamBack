//
//  FeedItem.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Three20/Three20.h>
#import "ResourceLink.h"

@interface FeedItem : TTTableLinkedItem {
    
	id resourceId;
    
	NSInteger feedId;

    NSString *title;
	NSString *details;
	NSString *createdBy;
	NSString *updatedBy;
    NSNumber *timeStamp;
    NSString *sharingInfo;
	NSString *createdDate;
	NSString *lastModifiedBy;
    NSInteger appInstanceId;
    NSString *lastAction;
    NSInteger resourceType;
    NSInteger resourceDepth;
	NSString *lastModifiedDate;
	NSInteger conversationsCount;
	
    NSMutableArray *conversationsArray;
    NSMutableArray *hierarchy;
}
@property (nonatomic, retain) id resourceId;

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * lastAction;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * timeStamp;
@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSString * updatedBy;
@property (nonatomic, assign) NSInteger resourceType;
@property (nonatomic, retain) NSString * sharingInfo;
@property (nonatomic, retain) NSString * createdDate;
@property (nonatomic, assign) NSInteger appInstanceId;
@property (nonatomic, assign) NSInteger resourceDepth;
@property (nonatomic, retain) NSString * lastModifiedBy;
@property (nonatomic, retain) NSString * lastModifiedDate;
@property (nonatomic, assign) NSInteger conversationsCount;

@property (nonatomic, retain) NSMutableArray *conversationsArray;
@property (nonatomic, retain) NSMutableArray *hierarchy;

-(id)initWithFeedData:(NSDictionary*)data;

-(ResourceLink *) getResourceLink;
@end
