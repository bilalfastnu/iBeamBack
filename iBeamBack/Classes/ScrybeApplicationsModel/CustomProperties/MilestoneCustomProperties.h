//
//  MilestoneCustomProperties.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MilestoneCustomProperties : NSObject {
	
    NSString *status;
    NSString *dueOn;
	NSString *text;
	NSString *title;
	NSString *assignedTo;
}
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *dueOn;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *assignedTo;

//Actions
-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject;

@end
