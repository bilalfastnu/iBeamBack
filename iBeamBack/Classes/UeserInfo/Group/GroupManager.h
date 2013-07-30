//
//  GroupManager.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "NSSingleton.h"
#import "RemoteCaller.h"

@protocol GroupsDataProcessorDelegate;

@interface GroupManager : NSSingleton<RemoteCallerDelegate> {
    
    NSMutableDictionary *groupsProfiles;
	NSMutableDictionary *groupsNames;
    
    NSObject <GroupsDataProcessorDelegate> *groupsDataProcessorDelegate;

}

@property (nonatomic, retain) NSObject <GroupsDataProcessorDelegate> *groupsDataProcessorDelegate;


-(NSString *) getGroupsIDs;

+(GroupManager *)sharedGroupManager;

-(NSString *)getGroupTitle:(NSString*)groupID;

@end


@protocol GroupsDataProcessorDelegate<NSObject>

- (void)groupsDataDidFinishProcessing:(GroupManager *)groupsDataProcessing;
- (void)groupsDataProcessing:(GroupManager *)groupsDataProcessing didFailWithError:(NSError *)error;

@end