//
//  UsersViewController.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "UserListView.h"

@interface UsersViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
    
    id userChatViewController;
    NSMutableArray *myfriendList;
    
    UserListView *cellView;
}

-(NSString*)getUserId:(NSString*)userName;
@property(assign) id userChatViewController;
@end

