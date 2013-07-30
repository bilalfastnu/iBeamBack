//
//  FeedItem.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedItem.h"

#import "UserManager.h"
#import "GroupManager.h"
#import "NAVIGATOR.h"
#import "ResourceLink.h"
#import "Resource.h"
#import "ResourcePath.h"
#import "extThree20JSON/JSON.h"
#import "Three20/Three20+Additions.h"
#import "Resource.h"
#import "CollaborationInfo.h"


@interface FeedItem (PRIVATE)

-(NSString*)fixupTextForStyledTextLabel:(NSString*)text;

@end

@implementation FeedItem

///////////////////////////////////////////////////////////////////////////////////////////////////
@synthesize  appInstanceId, lastAction;

@synthesize title, details, createdBy, updatedBy,resourceId, sharingInfo;

@synthesize feedId,timeStamp,conversationsCount;

@synthesize resourceType, resourceDepth,createdDate, lastModifiedBy, lastModifiedDate;

@synthesize conversationsArray;
@synthesize hierarchy;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithFeedData:(NSDictionary*)data
{
    self = [super init];
	if (self) {
		
        createdBy = [[data objectForKey:@"created_by"] retain];
        feedId = [[data objectForKey:@"feed_id"] intValue];
        updatedBy = [[data objectForKey:@"updated_by"] retain];
        resourceId = [[data objectForKey:@"resource_id"] retain];
        createdDate = [[data objectForKey:@"created_date"] retain];
        timeStamp = [[data objectForKey:@"time_stamp"] retain];
        resourceDepth = [[data objectForKey:@"resource_depth"] intValue];
        lastModifiedBy = [[data objectForKey:@"last_modified_by"] retain];
        appInstanceId = [[data objectForKey:@"app_instance_id"] intValue];
        conversationsCount = [[data objectForKey:@"conversations_count"] intValue];
        lastAction = [data objectForKey:@"last_action"];
        
        title = [[[[data objectForKey:@"path_names"] JSONValue] objectAtIndex:resourceDepth] retain];

   
        details = [[self fixupTextForStyledTextLabel:[data objectForKey:@"details"]] retain];
        
        hierarchy = [Resource createHierarchyWithPathIDs:[data objectForKey:@"path_ids"] 
                                           jsonPathTypes:[data objectForKey:@"path_types"]
                                           jsonPathNames:[data objectForKey:@"path_names"]
                                        jsonPathVersions:[data objectForKey:@"path_versions"]
                                       jonPathCreatedBys:[data objectForKey:@"path_created_by"]
                                            jsonPathData:[data objectForKey:@"path_data"]];
        
	}
	return self;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)fixupTextForStyledTextLabel:(NSString*)text { 
    
    text = [text stringByRemovingHTMLTags];
	text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]; 
	text = [text stringByReplacingOccurrencesOfString:@"*" withString:@"&#42;"]; 
	text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]; 
	text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
	return text; 
}
/////////////////////////////////////////////////////////////////////////////////////////

-(ResourceLink *) getResourceLink
{
   
    ResourcePath *resourcePath = [[ResourcePath alloc] init];
    resourcePath.hierarchy = [[NSMutableArray alloc] initWithArray:hierarchy];
    resourcePath.appInstaceID = appInstanceId;
    
    ResourceLink *resourceLink = [[[ResourceLink alloc] init] autorelease];
    resourceLink.resourcePath = resourcePath;
    resourceLink.collaborationInfo = [[CollaborationInfo alloc] initWithSnippetData:nil parentResourceIndex:resourceDepth];
    
    [resourcePath release];
    
    return resourceLink;

}
/////////////////////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [title release];
	[details release];
    [createdBy release];
	[updatedBy release];
    [createdDate release];
    [timeStamp release];
    [resourceId release];
	[sharingInfo release];
	[lastModifiedBy release];
	[lastModifiedDate release];
    [conversationsArray release];

	[super dealloc];
}

@end
