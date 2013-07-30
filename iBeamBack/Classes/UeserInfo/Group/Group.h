//
//  Group.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Group : NSObject {

    NSString *ID,*name;
	NSString *createdBy,*type;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *createdBy;

@end
