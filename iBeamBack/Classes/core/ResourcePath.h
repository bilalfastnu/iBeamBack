//
//  ResourcePath.h
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Resource;

@interface ResourcePath : NSObject<NSCopying> {
    NSInteger         appInstanceID;
    NSMutableArray  * hierarchy;  
}

@property(nonatomic,assign) NSInteger        appInstaceID;
@property(nonatomic,retain) NSMutableArray * hierarchy;


-(id)initWithAppInstanceID:(NSInteger)p_appInstanceID hierarchy:(NSMutableArray *)p_hierarchy;

-(NSString*) getPathIDs;

-(NSMutableDictionary*) getJSONProperties;
@end
