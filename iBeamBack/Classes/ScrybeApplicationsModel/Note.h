//
//  Note.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeedItem.h"
#import "NoteCustomProperties.h"

@class NoteCustomProperties;

@interface Note : FeedItem {
    
    BOOL    isTextBroken;
    NSArray *customPropertiesArray;
    NSMutableArray *imagesArray;
	NSMutableArray *filesArray;
    
}

@property (nonatomic, assign) BOOL isTextBroken;

@property (nonatomic, retain) NSArray *customPropertiesArray;
@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *filesArray;

//Actions
-(id)initWithFeedData:(NSDictionary*)data;


@end
