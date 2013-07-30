//
//  SidebarViewController.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrybeImageThumbView;

typedef enum _SidebarSections{
    
	PERSONAL_INFORMATION		=  0,
	FILTER						=  1,
	GROUPS1	                    =  2,
	UPCOMMINGS					=  3,
	MEMBERS						=  4
    
}SidebarSections;


@interface SidebarTableViewController : UITableViewController {
    
    ScrybeImageThumbView *userImageView;
}

@end
