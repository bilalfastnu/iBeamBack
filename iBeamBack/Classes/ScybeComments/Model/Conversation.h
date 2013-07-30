//
//  Comment.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ResourceLink.h"

#import "Resource.h"
#import "SnippetData.h"
#import "ResourcePath.h"
#import "CollaborationInfo.h"

extern NSString * const NOTE_SNIPPET;

extern NSString * const IMAGE_SNIPPET;


@interface Conversation : NSObject {
    

    NSString *summery;
    NSInteger feedId;
    NSString *comments;
	NSString *postDate;
	NSString *updatedBy;
    NSString *cItemUId;
    NSString *resourceId;
    NSInteger updateKind;
	NSString *initiatedBy;
    NSString *conversationId;
    NSString *collaborators;
	NSNumber *updatedTimeStamp;
	NSNumber *creationTimeStamp;
    
    ResourceLink *resourceLink;
    
}

@property (nonatomic, retain) NSString *summery;
@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, retain) NSString *comments;
@property (nonatomic, retain) NSString *updatedBy;
@property (nonatomic, retain) NSString *postDate;
@property (nonatomic, retain) NSString *cItemUId;
@property (nonatomic, retain) NSString *resourceId;
@property (nonatomic, assign) NSInteger updateKind;
@property (nonatomic, retain) NSString *initiatedBy;
@property (nonatomic, retain) NSString *collaborators;
@property (nonatomic, retain) NSString *conversationId;
@property (nonatomic, retain) NSNumber *creationTimeStamp;
@property (nonatomic, retain) NSNumber *updatedTimeStamp;

@property (nonatomic, retain) ResourceLink *resourceLink;

//Actions
-(id) initWithConversationData:(NSDictionary*)commentData;

-(NSMutableDictionary*) createValueObjectForServer;
@end

