//
//  GroupManager.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "GroupManager.h"

#import "Group.h"
#import "UserManager.h"


@implementation GroupManager

@synthesize groupsDataProcessorDelegate;

///////////////////////////////////////////////////////////////////////////

-(id)init 
{
	self = [super init];
	if (self != nil) {
		// initialize stuff here
		groupsProfiles =[[NSMutableDictionary alloc] init];
		///groupsNames =[[NSMutableDictionary alloc] init];
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////

+(GroupManager *)sharedGroupManager
{
	return (GroupManager *)[super sharedInstance];
}

///////////////////////////////////////////////////////////////////////////

-(void) processGroupsData:(NSDictionary *)data
{
    NSMutableDictionary *groupsData = [data objectForKey:@"groups_data"];
	NSArray *groupProfilesData = [groupsData objectForKey:@"all_profile_groups_in_account_along_with_their_respective_owners"];
	
	//groupsNames = [NSMutableDictionary dictionaryWithDictionary:[groupsData objectForKey:@"groups_names"]];
	groupsNames = [[groupsData objectForKey:@"groups_names"] retain];
	
    Group *group = nil;
	for (NSString *key in groupsNames){
		
		group = [[Group alloc] init];
		group.name = [[groupsNames objectForKey:key] retain];
		group.ID = key;
	    group.type = @"REGULAR";
		[groupsProfiles setObject:group forKey:group.ID];
		[group release];
	}
    
	for(NSDictionary *tempDictionary in groupProfilesData){
        
		group = [[Group alloc] init];
		group.ID = [[tempDictionary objectForKey:@"group_id"] retain];
		group.name =  [[tempDictionary objectForKey:@"title"] retain];
		group.createdBy = [[tempDictionary objectForKey:@"created_by"] retain];
		group.type = @"PROFILE";
	    [groupsProfiles setObject:group forKey:group.ID];
	    [group release];
	}

}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Group Manager methods

-(NSString *) getGroupsIDs
{  

    NSString *groupsIDs = @"";
	for (NSString *key in groupsNames){
        
		groupsIDs = [groupsIDs stringByAppendingString:key];
		groupsIDs = [groupsIDs stringByAppendingString:@","];
	}

    if ([groupsIDs length]) {
        
        NSRange range;
        
        range.length = 2;
        range.location = [groupsIDs length]-2;
        
        groupsIDs =  [groupsIDs stringByReplacingOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:range];
    }
    
   return groupsIDs;
}

-(NSString *)getGroupTitle:(NSString*)groupID
{
    if (groupID != (NSString*)[NSNull null]) {
        
		Group *groupObj = [groupsProfiles objectForKey:groupID];
		
		UserManager *userManager = [UserManager sharedUserManager];
        
		if ([groupObj.createdBy isEqualToString:userManager.currentUser.userId] == TRUE) {
			
			return @"My Feed";
		}
		else if ([groupObj.type isEqualToString:@"REGULAR"]) {
			
			return groupObj.name;
		}
		else if ([groupObj.type isEqualToString:@"PROFILE"]) {
			
			return [[userManager getFirstName:groupObj.createdBy] stringByAppendingFormat:@"'s Feed"];
		}
	}
	return (NSString*)[NSNull null];

}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark RemoteCall Delegate methods

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    @try {
        
       // NSLog(@"in Group Manager %@",object);
        ASObject *response = (ASObject *)object;
        
        NSDictionary *data = [response.properties objectForKey:@"data"];
        
        [self processGroupsData:data];
        
        [[UserManager sharedUserManager] processUsersData:data];
        
        [groupsDataProcessorDelegate groupsDataDidFinishProcessing:self];
        
    }
    @catch (NSException *exception) {
        
        [groupsDataProcessorDelegate groupsDataProcessing:self didFailWithError:(NSError*)exception];
    }
    @finally {
        
    }
    
}
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Server Error in Group Manager"  message:@"Data is Null" 
                                                            delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [errorAlertView show];
    [errorAlertView release];
}

///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [groupsProfiles release];
    [groupsNames release];
    [super dealloc];
}

@end
