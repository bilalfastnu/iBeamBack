//
//  FeedDataProcessor.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedDataProcessor.h"

#pragma mark -
#pragma mark Data Model

#import "FeedItem.h"
#import "Note.h"
#import "WebLink.h"
#import "Message.h"
#import "Milestone.h"

#pragma mark -
#pragma mark Helper Files

#import "UserManager.h"
#import "GroupManager.h"
#import "Conversation.h"

#import "NAVIGATOR.h"
#import "APPLICATIONS.h"
#import "extThree20JSON/JSON.h"
//#import "NoteCustomProperties.h"
//#import "WebLinkCustomProperties.h"
//#import "Three20/Three20+Additions.h"

@implementation FeedDataProcessor

@synthesize feedProcessorDelegate;

/////////////////////////////////////////////////////////////////////////////////////////

-(NSString*) getSharingInfo:(NSInteger) feedID withCreatedBy:(NSString*) createdBy
{
	NSDictionary *groupInfo = nil;
	
	UserManager *userManager = [UserManager sharedUserManager];
	GroupManager *groupManager = [GroupManager sharedGroupManager];
	
	NSInteger ID = 0;
	NSString *name = nil;
	
	NSString *sharingInfo = [NSString stringWithFormat:@"<a href=\"%@\">%@</a> to ",UserURL ,createdBy];
	for(groupInfo in feedGroupsInfo)
	{
		ID = [[groupInfo objectForKey:@"feed_id"]intValue];
		if (ID == feedID) {
			
			if ([[groupInfo objectForKey:@"type"]isEqualToString:@"USER" ]) {
				
				name = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",UserURL,[userManager getFullName:[groupInfo objectForKey:@"published_to"]]];
				
			}else {
				
				name = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",GroupURL,  [groupManager getGroupTitle:[groupInfo objectForKey:@"published_to"]]];
			}
			sharingInfo = [sharingInfo stringByAppendingString:name];
			sharingInfo = [sharingInfo stringByAppendingString:@", "];
			
		}
		
	}
	// removing last , from sharingInfo
	NSRange range;
	
	range.length = 2;
	range.location = [sharingInfo length]-2;
	
	sharingInfo =  [sharingInfo stringByReplacingOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:range];
	
	return sharingInfo;
	
} 

//////////////////////////// get Resource Conversation ///////////////////////////////
-(NSMutableArray *) getResourceConversations:(NSString*) feedId
{
	NSSortDescriptor *feedConversationSorter = [[NSSortDescriptor alloc] initWithKey:@"creationTimeStamp" ascending:YES];
	
	//NSMutableArray *commentsArray = [feedCommentsDataDictionary objectForKey:feedID];
	NSArray *sortedArray = [[conversationDictionary objectForKey:feedId] sortedArrayUsingDescriptors:[NSArray arrayWithObject:feedConversationSorter]];
	[feedConversationSorter release];
	
	NSMutableArray *feedConversationsSortedArray = [NSMutableArray arrayWithArray:sortedArray];
	
	return feedConversationsSortedArray;
	
}

/////////////////////////////////////////////////////////////////////////////////////////
-(void) processConversations:(NSArray*)conversations
{
    conversationDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *conversationArray = nil;
    
    for (NSDictionary *converationDic in conversations) {
    
        Conversation *conversation = [[Conversation alloc] initWithConversationData:converationDic];
       
        NSString *feedID =[NSString stringWithFormat:@"%d",conversation.feedId];
        //NSString *feedID = [NSString stringWithFormat:@"%d",[conversation.feedId integerValue]];

        //use NSMutableDictionary as multimap
		if ([conversationDictionary objectForKey:feedID] == nil) {
			
			conversationArray = [[NSMutableArray alloc] init];
			[conversationArray addObject:conversation];
            
			[conversationDictionary setValue:conversationArray forKey:feedID];
			[conversationArray release];
		}
		else {
			
			conversationArray = [conversationDictionary objectForKey:feedID];
			[conversationArray addObject:conversation];
			
			[conversationDictionary setValue:conversationArray forKey:feedID];
		}
		
		[conversation release];
    }
}

////////////////////////////////////////////////////////////////////////////////////////

-(NSArray*) getUpdatedFeedItems:(NSMutableArray*)newFeed withOldFeed:(NSMutableDictionary*)oldFeed
{
    
    NSMutableArray *updatedItemsArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *feedID = nil;
    for (NSDictionary *newFeedItem in newFeed) {
        feedID = [NSString stringWithFormat:@"%d",[[newFeedItem objectForKey:@"feed_id"] intValue]];
        FeedItem *feeItem = [oldFeed objectForKey:feedID];
        if (feeItem) {
            
             double oldTimestamp = [feeItem.timeStamp doubleValue] ;
             double newTimestamp = [[newFeedItem objectForKey:@"time_stamp"] doubleValue];
            if ( newTimestamp > oldTimestamp) {
                
                [updatedItemsArray addObject:newFeedItem];
            }
        }
    }
    
    return updatedItemsArray;
}
/////////////////////////////////////////////////////////////////////////////////////////
-(void) processFeedData:(NSObject *) feedDataObject withPreviousFeedData:(NSMutableDictionary*)oldFeedData
{
    NSDictionary *feedDataDictionary = (NSDictionary*)feedDataObject;
    NSMutableArray *unProcessedFeedData = nil; 
    
    if( [feedDataDictionary objectForKey:@"feedData"] ) {
        
        feedDataDictionary = [ feedDataDictionary objectForKey:@"feedData"];
        unProcessedFeedData = [[NSMutableArray alloc ] initWithArray:[self getUpdatedFeedItems:[feedDataDictionary objectForKey:@"feed"] withOldFeed:oldFeedData]];
       
    } else
		unProcessedFeedData = [feedDataDictionary objectForKey:@"feed"];

    feedGroupsInfo = [feedDataDictionary objectForKey:@"groupsInfo"];
    
    [self processConversations:[feedDataDictionary objectForKey:@"conversations"]];
    
    NSMutableDictionary *feedProcessedData = [[NSMutableDictionary alloc] init];
    
    int resourceType = 0;
    FeedItem *feedItem = nil;

    for (NSDictionary *newFeedItem in unProcessedFeedData) {
        
        resourceType = [[newFeedItem objectForKey:@"resource_type"] intValue];
        if (resourceType == NOTES||  resourceType == WEBLINKS  || resourceType == MESSAGES ||
             resourceType == MILESTONES)
        {
            switch (resourceType) {
                    
                case NOTES:
                    
                    feedItem = [[Note alloc] initWithFeedData:newFeedItem];
                    
                    break; 
                    
                case WEBLINKS:
                    
                    feedItem = [[WebLink alloc] initWithFeedData:newFeedItem];
                    
                    break;
                    
                case MESSAGES:
					
					feedItem = [[Message  alloc] initWithFeedData:newFeedItem];
                    
                    break;
                
                case MILESTONES:
					
					feedItem = [[Milestone  alloc] initWithFeedData:newFeedItem];
                    
                    break;

            }//end switch
             
            
             feedItem.resourceType = resourceType;
            
            if (feedItem.conversationsCount) {
 
                feedItem.conversationsArray = [[NSMutableArray alloc] initWithArray:[self getResourceConversations:[NSString stringWithFormat:@"%d",feedItem.feedId] ] ];
            }

            // get sharing info 
            feedItem.sharingInfo = [[self getSharingInfo:feedItem.feedId  withCreatedBy:[[UserManager sharedUserManager] getFullName:feedItem.createdBy]] retain];

             [feedProcessedData setObject:feedItem forKey:[NSString stringWithFormat:@"%d",feedItem.feedId ]];
            
           // [feedItem release];
            
        }//end if
    }//end for
    
    [feedProcessorDelegate scrybeFeedDataDidFinishProcessing:self processedData:feedProcessedData];
    [feedProcessedData release];
    
}
@end

