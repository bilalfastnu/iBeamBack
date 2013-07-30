//
//  SidebarViewController.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SidebarTableViewController.h"

#import "ScrybeUserImage.h"
#import "UserManager.h"
#import "ScrybeImageThumbView.h"

@implementation SidebarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
   
    NSInteger rows = 1;
	switch (section) {
			
		case PERSONAL_INFORMATION:
			rows = 2;
			break;
			
		case FILTER:
			
			rows = 4; 
			
			break;
			
		default:
			break;
	}
    return rows;

}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	CGFloat cellHeight = 0.0f;
	
	switch (indexPath.section) {
		case 0://Personal information
			
			cellHeight = (indexPath.row > 0 ? 50.0f :70.0f);
			
			break;
		case 1:
			
			cellHeight = 50.0f;
			
			break;
            
		default:
			cellHeight = 50.0f;
			break;
	}
	return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    switch (indexPath.section) {
			
		case PERSONAL_INFORMATION:
            
			if (indexPath.row == 0) {
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
                UserManager *userManager = [UserManager sharedUserManager];
                
                NSString *url = [ScrybeUserImage getScrybeUserImageUrl:userManager.currentUser.userId imageSize:@"48x48"];
                
                userImageView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectMake(5.0, 10, 48, 48)];
                userImageView.hidden = NO;

                [userImageView setImage:url forState:UIControlStateNormal];
                
                [cell.contentView addSubview:userImageView];
				[userImageView release];
				
				UIImageView *statuseImagView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 20, 20)];
				//statuseImagView.image = [UIImage imageNamed:Status_Available];
				[cell.contentView addSubview:statuseImagView];
				[statuseImagView release];
                
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 100, 20)];
				label.text = [userManager getFullName:userManager.currentUser.userId];
				[label sizeToFit];
				[cell.contentView addSubview:label];
				[label release];
			}
			else {
				cell.textLabel.text = @"Edit my Profile";
			}
            
			break;
			
		case FILTER:
			
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"News Feed";
					break;
				case 1:
					cell.textLabel.text = @"Directs";
					break;
				case 2:
					cell.textLabel.text = @"My Task List";
					break;
				case 3:
					cell.textLabel.text = @"Discussions";
					break;
					
				default:
					break;
			}
			
			break;
			
		default:
			break;
	}

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
