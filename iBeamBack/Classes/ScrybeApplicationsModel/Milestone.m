//
//  Milestone.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Milestone.h"

#import "DateManager.h"
#import "UserManager.h"

#import "extThree20JSON/JSON.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
@interface Milestone(PRIVATE)

-(NSString *) getMilestoneDetail;

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Milestone

@synthesize customProperty;
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithFeedData:(NSDictionary*)data
{
    self = [super initWithFeedData:data];
    if (self) {
        
        customProperty = [[MilestoneCustomProperties alloc] initWithCustomProperty:[[data objectForKey:@"custom_properties"] JSONValue]];

        details = [[self getMilestoneDetail] retain];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *) getMilestoneDetail 
{
    NSString *detailedText = nil;
    
    if ([customProperty.status isEqualToString:@"pending"]) {
        int days=[[DateManager sharedDateManager] getHowManyDaysHavePased:customProperty.dueOn];
		
		//detailedText = ( days > 0 ?[NSString stringWithFormat:@"Due:<b> %d days ago</b>",days]:[NSString stringWithFormat:@"Due:<b> In %d days</b>",-days]);
		detailedText = ( days > 0 ?[NSString stringWithFormat:@"Due:<b> %d days ago</b>",days]:days == 0 ?@"Due:<b> Today</b>":[NSString stringWithFormat:@"Due:<b> In %d days</b>",-days]);

    }else {
		NSDate *date = [[DateManager sharedDateManager] localTimeZoneDateFrom:createdDate];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMM dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];  
		[dateFormatter release];
		
		detailedText = [NSString stringWithFormat:@"\nCompleted:<b> %@  on %@ </b>",
						[[UserManager sharedUserManager] getFullName:createdBy],dateString];
    }
    
    if ([customProperty.assignedTo length]) {
		
		detailedText= [detailedText stringByAppendingFormat:@"\nAssigned to:<b> %@</b>",[[UserManager sharedUserManager] getFullName:customProperty.assignedTo]];
	}
	if ([customProperty.text length]) {
		
		detailedText = [detailedText stringByAppendingFormat:@"\n%@",customProperty.text];
	}

    return detailedText;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dealloc
{
    [customProperty release];
    
    [super dealloc];
}

@end
