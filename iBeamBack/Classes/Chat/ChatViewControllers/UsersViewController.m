//
//  UsersViewController.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "UsersViewController.h"

#import "ChatViewController.h"

#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPUserCoreDataStorage.h"
#import "XMPPResourceCoreDataStorage.h"

#import "DDLog.h"
#import "ChatManager.h"
#import "UserManager.h"
#import "ScrybeUserImage.h"
#import "ICONS.h"



// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


@implementation UsersViewController

@synthesize userChatViewController;
///////////////////////////////////////////////
#pragma mark ChatManagerDelegate

- (XMPPStream *)xmppStream
{
	return [[ChatManager sharedChatManager] xmppStream];
}

- (XMPPRoster *)xmppRoster
{
	return [[ChatManager sharedChatManager] xmppRoster];
}

- (XMPPRosterCoreDataStorage *)xmppRosterStorage
{
	return [[ChatManager sharedChatManager] xmppRosterStorage];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext
{
	if (managedObjectContext == nil)
	{
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		
		NSPersistentStoreCoordinator *psc = [[self xmppRosterStorage] persistentStoreCoordinator];
		[managedObjectContext setPersistentStoreCoordinator:psc];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(contextDidSave:)
		                                             name:NSManagedObjectContextDidSaveNotification
		                                           object:nil];
	}
	
	return managedObjectContext;
}

- (void)contextDidSave:(NSNotification *)notification
{
	NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
	
	if (sender != managedObjectContext)
	{
		DDLogError(@"%@: %@", THIS_FILE, THIS_METHOD);
		
		[managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
		                                       withObject:notification
		                                    waitUntilDone:NO];
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorage"
		                                          inManagedObjectContext:[self managedObjectContext]];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:[self managedObjectContext]
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		[sd1 release];
		[sd2 release];
		[fetchRequest release];
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			NSLog(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Utility methods
///////////////////////////////////////////////////////////////////////////////////////////////

-(NSString*)getUserId:(NSString*)userName{
    
    NSString *userId =nil;
    if ([userName compare:@"sumaira"] == NSOrderedSame) {
        userId = @"usr-3db7277e-5538-11e0-b8a8-000f2075d66f";
        
    }
    if ([userName compare:@"umar"] == NSOrderedSame) {
        userId = @"usr-3db10a56-5538-11e0-b8a8-000f2075d66f";
        
    }
    if ([userName compare:@"bilal"] == NSOrderedSame) {
        userId = @"usr-3d9af14e-5538-11e0-b8a8-000f2075d66f";
    }
    if ([userName compare:@"ali"] == NSOrderedSame) {
        userId = @"usr-3db7277e-5538-11e0-b8a8-000f2075d66f";
    }
    //usr-3daa7c04-5538-11e0-b8a8-000f2075d66f
    return userId;
    
}


-(ChatUser*)convertUserFromXMPPToChatUser:(XMPPUserCoreDataStorage *)user 

{
    ChatUser *newUser = [[ChatUser alloc] init];
	newUser.userName =user.displayName ;
    
    
    newUser.userId = [user.jidStr stringByAppendingString:@"/iChat"];
    
    int sectionNumber =[user.sectionNum intValue];
    
    switch (sectionNumber) {
        case 0:
            newUser.status = AVAILABLE;
            break;
        case 1:
            newUser.status = AWAY;
            break;
            
        default:
            newUser.status = OFFLINE;
            break;
    }
	[((ChatViewController*)userChatViewController).friendDictionry setObject:newUser forKey:newUser.userId];
    
    return newUser;
}


-(UIImage*)getStatusImage:(enum UserStatus)myState{
	
	UIImage *statusImage = nil;
	switch (myState) {
		case OFFLINE:
			statusImage =[UIImage imageNamed:OffLineGrayIcon];
			break;
		case AVAILABLE:
			statusImage =[UIImage imageNamed:AvailableGreenIcon];
			break;
		case AWAY:
			statusImage =[UIImage imageNamed:AwayRedIcon];
			break;
            
		default:
			break;
			
	}
	return statusImage;
}

////////////////////////////////////////////////////////////////////////////////////////////////////


-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
	if (self != nil) {
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
        
        myfriendList = [[NSMutableArray alloc]init];
        
        
        
	}
	return self;
}
/*
 -(void)viewDidLoad{
 [super viewDidLoad];
 
 
 }*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self tableView] reloadData];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[[self fetchedResultsController] sections] count];
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return @"Available";
			case 1  : return @"Away";
			default : return @"Offline";
		}
	}
	
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
    
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

#define CELLVIEW_TAG 0
#define PROFILEVIEW_TAG 1
#define USERNAME_TAG 2
#define STATUSVIEW_TAG 3

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
	
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
		                               reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cellView =[[UserListView alloc]initWithFrame:CGRectMake(0,0, cell.frame.size.width, cell.frame.size.height)];
		[cell.contentView addSubview:cellView];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
    
    else {
		
		cellView.profileImageView = (TTImageView *)[[cell.contentView viewWithTag:CELLVIEW_TAG] viewWithTag:
                                                    PROFILEVIEW_TAG];
		cellView.userName = (UILabel *)[[cell.contentView viewWithTag:CELLVIEW_TAG] viewWithTag:USERNAME_TAG];
		cellView.statusImageView = (UIImageView *)[[cell.contentView viewWithTag:CELLVIEW_TAG] viewWithTag:
                                                   STATUSVIEW_TAG];
		
	}
    
	
    
    
    cellView.profileImageView.frame = CGRectMake(240, 5, 32, 32);
    
	XMPPUserCoreDataStorage *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ChatUser *newUser=[self convertUserFromXMPPToChatUser:user];
    [myfriendList addObject:newUser];
    
    
    
	enum UserStatus	myState = newUser.status;
	UIImage *stateImage = [self getStatusImage:myState]; 
    cellView.statusImageView.frame =CGRectMake(10,17, stateImage.size.width,stateImage.size.height);
    cellView.statusImageView.image = stateImage;
    
    //NSString *userId = [[self getUserId:newUser.userName] ];
    NSString *imageUrl  =[ScrybeUserImage getScrybeUserImageUrl:[self getUserId:newUser.userName] imageSize:@"32x32"];
    cellView.profileImageView.urlPath = imageUrl;
    
    
	NSString *text = newUser.userName;
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0]
				   constrainedToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.height)
					   lineBreakMode:UILineBreakModeWordWrap];
    
    
    cellView.userName.frame =CGRectMake(cellView.statusImageView.frame.size.width +20.0f,
                                        15.0f , size.width + 5.0f, size.height);
    cellView.userName.text =newUser.userName;
    
	
	
	return cell;
}
/////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate
//////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	//int row = indexPath.row;
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
    XMPPUserCoreDataStorage *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    ((ChatViewController*)userChatViewController).currentUser=[self convertUserFromXMPPToChatUser:user];
	
	
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==0) {
        if (indexPath.row%2==0) {
            cell.backgroundColor =  [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
        }
        else {
            
            cell.backgroundColor = [UIColor whiteColor];          
            
        }
        
	}
	else if(indexPath.section ==1){
        
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else {
            
            cell.backgroundColor =  [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];           
            
        }
    }
    else
    {
        if (indexPath.row%2==0) {
            cell.backgroundColor =  [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
        }
        else {
            
            cell.backgroundColor = [UIColor whiteColor];          
            
        }
        
        
    }
    
	
    
    
}


#pragma mark -
#pragma mark Size for popover


// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {//self.tableView.rowHeight*[myfriendList count]
    return self.contentSizeForViewInPopover = CGSizeMake(280.0, 300);
}





- (void)dealloc
{
	[super dealloc];
}

@end
