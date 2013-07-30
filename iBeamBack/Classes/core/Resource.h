//
//  Resource.h
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Resource : NSObject<NSCopying> {
    NSString            * uid;
    NSString            * type;
    NSString            * title;
    NSInteger             version;
    NSString            * createdBy;
    NSMutableDictionary * data;
    
}
@property(nonatomic,retain) NSString            * uid;
@property(nonatomic,retain) NSString            * type;
@property(nonatomic,retain) NSString            * title;
@property(nonatomic,assign) NSInteger             version;
@property(nonatomic,retain) NSString            * createdBy;
@property(nonatomic,retain) NSMutableDictionary * data;

+(NSMutableArray *) createHierarchyWithPathIDs:(NSString *)pathIDs
                                 jsonPathTypes:(NSString *)pathTypes
                                 jsonPathNames:(NSString *)pathNames
                              jsonPathVersions:(NSString *)pathVersions
                             jonPathCreatedBys:(NSString *)pathCreatedBys
                                  jsonPathData:(NSString *)pathData; 

@end
