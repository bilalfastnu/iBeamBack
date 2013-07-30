//
//  Comment.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Conversation.h"

#import "extThree20JSON/JSON.h"


@implementation Conversation

@synthesize summery, feedId,comments, postDate,updatedBy;

@synthesize cItemUId,resourceId,resourceLink;

@synthesize updateKind,initiatedBy,conversationId;

@synthesize collaborators,updatedTimeStamp,creationTimeStamp;

///////////////////////////////////////////////////////////////////////////

NSString * const NOTE_SNIPPET = @"scrybe.components.snippet.NotesSnippet";

NSString * const IMAGE_SNIPPET = @"scrybe.components.snippet.MarkupBitmapSnippet";

///////////////////////////////////////////////////////////////////////////

-(id) initWithConversationData:(NSDictionary*)conversation
{
    self = [super init];
	if (self) {
        
        //NSLog(@"Snippet %@",conversation);
        
        feedId = [[conversation objectForKey:@"feed_id"] intValue];
        summery = [[conversation objectForKey:@"summery"] retain];
        comments = [[conversation objectForKey:@"comments"] retain];
        postDate = [[conversation objectForKey:@"post_date"] retain];
        updatedBy = [[conversation objectForKey:@"updated_by"] retain];
        cItemUId = [[conversation objectForKey:@"citem_uid"] retain];
        initiatedBy = [[conversation objectForKey:@"initiated_by"] retain];
        resourceId = [[conversation objectForKey:@"resource_id"] retain];
        updateKind = [[conversation objectForKey:@"update_kind"] intValue];
        collaborators = [[conversation objectForKey:@"collaborators"] retain];
        conversationId = [[conversation objectForKey:@"conversation_uid"] retain];
        creationTimeStamp = [[conversation objectForKey:@"creation_timestamp"] retain];
        updatedTimeStamp = [[conversation objectForKey:@"update_timestamp"] retain];

        NSMutableArray *hierarchy = [Resource createHierarchyWithPathIDs:
                                        [conversation objectForKey:@"path_ids"] 
                                           jsonPathTypes:[conversation objectForKey:@"path_types"]
                                           jsonPathNames:[conversation objectForKey:@"path_names"]
                                        jsonPathVersions:[conversation objectForKey:@"path_versions"]
                                       jonPathCreatedBys:[conversation objectForKey:@"path_created_by"]
                                            jsonPathData:[conversation objectForKey:@"path_data"]];
        
        
        ResourcePath *resourcePath = [[ResourcePath alloc] initWithAppInstanceID:[[conversation objectForKey:@"app_instance_id"]intValue] hierarchy:hierarchy];
        
        NSMutableDictionary *linkData = nil;

        if (![[conversation objectForKey:@"link_data"] isEqualToString:@"null"]) {
           
            linkData = [[conversation objectForKey:@"link_data"]JSONValue];
        }

        NSString *collaborationInfoJSON = [conversation objectForKey:@"collaboration_info"];
        CollaborationInfo *info = nil;
        if ([collaborationInfoJSON length]) {
            
            info = [CollaborationInfo createFromJSON:[conversation objectForKey:@"collaboration_info"]];
        }

       resourceLink = [[ResourceLink alloc] initWithResourcePath:resourcePath collaborationInfo:info data:linkData];
        
        [resourcePath release];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////

-(NSMutableDictionary*) createValueObjectForServer
{
    NSMutableDictionary *vo = [[[NSMutableDictionary alloc] init] autorelease];
    
    [vo setValue:conversationId forKey:@"conversation_uid"];
    [vo setValue:[NSNumber numberWithInt:resourceLink.resourcePath.appInstaceID] forKey:@"app_instance_id"];
    [vo setValue:resourceId forKey:@"resource_id"];
    [vo setValue:initiatedBy forKey:@"initiated_by"];
    
    NSMutableDictionary *properties = [resourceLink.resourcePath getJSONProperties];
    
    NSMutableDictionary *conversationItem = [[[NSMutableDictionary alloc] init] autorelease];
    [conversationItem setValue:cItemUId forKey:@"citem_uid"];
    [conversationItem setValue:conversationId forKey:@"conversation_uid"];
    [conversationItem setValue:initiatedBy forKey:@"from_user"];
    [conversationItem setValue:comments forKey:@"comments"];
    [conversationItem setValue:[NSNumber numberWithInt:resourceLink.resourcePath.appInstaceID] forKey:@"app_instance_id"];
    
    [conversationItem setValue:[resourceLink.resourcePath getPathIDs] forKey:@"path_ids"];
    [conversationItem setValue:[properties objectForKey:@"titles"] forKey:@"path_names"];
    [conversationItem setValue:[properties objectForKey:@"types"] forKey:@"path_types"];
    [conversationItem setValue:[properties objectForKey:@"versions"] forKey:@"path_versions"];
    [conversationItem setValue:[properties objectForKey:@"datas"] forKey:@"path_data"];
    [conversationItem setValue:[properties objectForKey:@"createdBys"] forKey:@"path_created_by"];
    [conversationItem setValue:[properties objectForKey:@"createdBys"] forKey:@"path_created_by"];

    if (resourceLink.data) {
        [conversationItem setValue:[resourceLink.data JSONRepresentation] forKey:@"link_data"];
    }
    else
    {
        [conversationItem setValue:@"null" forKey:@"link_data"];
 
    }

    [conversationItem setValue:[resourceLink.collaborationInfo getJSONRepresentation] forKey:@"collaboration_info"];
    
    
    [vo setValue:conversationItem forKey:@"conversationItem"];

    return vo;
}

///////////////////////////////////////////////////////////////////////////
-(void) dealloc
{
    [resourceLink release];
    [summery release];
	[resourceId release];
    [cItemUId release];
	[updatedBy release];
	[initiatedBy release];
	[postDate release];
	[resourceId release];
	[comments release];
	[conversationId release];
	[collaborators release];
	[creationTimeStamp release];
	[updatedTimeStamp release];

	[super dealloc];
}

@end
