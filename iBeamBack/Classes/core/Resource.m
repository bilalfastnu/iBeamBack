//
//  Resource.m
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Resource.h"
#import "extThree20JSON/JSON.h"

@implementation Resource

@synthesize uid;
@synthesize type;
@synthesize title;
@synthesize version;
@synthesize createdBy;
@synthesize data;

-(id) init {
    self = [super init];
    if (self) {
        self.uid = @"";
        self.type = @"";
        self.title = @"";
        self.version = -1;
        self.createdBy = @"";
        self.data = nil;
    }
    return self;
}

-(id)initWithUid:(NSString *)p_uid 
            type:(NSString *)p_type 
           title:(NSString *)p_title
         version:(NSInteger )p_version
       createdBy:(NSString *)p_creator 
            data:(NSMutableDictionary *)p_data {
          
    self = [ super init];
    if (self) {
        self.uid = p_uid;
        self.type = p_type;
        self.title = p_title;
        self.version = p_version;
        self.createdBy = p_creator;
        self.data = p_data;
    }
    return self;
}


-(id) copyWithZone:(NSZone *)zone {
    Resource * clone = [[Resource alloc] 
                        initWithUid:self.uid  
                               type:self.type
                              title:self.title
                            version:self.version
                          createdBy:self.createdBy
                               data:self.data];
    return clone;                     
                        
}


+(NSMutableArray *) createHierarchyWithPathIDs:(NSString *)pathIDs
                          jsonPathTypes:(NSString *)pathTypes
                          jsonPathNames:(NSString *)pathNames
                       jsonPathVersions:(NSString *)pathVersions
                      jonPathCreatedBys:(NSString *)pathCreatedBys
                           jsonPathData:(NSString *)pathData {
    
    NSArray *ids      = [pathIDs componentsSeparatedByString:@","];
    NSArray *types    = [pathTypes JSONValue];
    NSArray *names    = [pathNames JSONValue];
    NSArray *versions = [pathVersions JSONValue];
    NSArray *creators = [pathCreatedBys JSONValue];
    NSArray *datas    = [pathData JSONValue];
    
    NSInteger len = [ids count];
    NSMutableArray *hierarchy = [[NSMutableArray alloc] initWithCapacity:len];
    for (NSInteger index=0; index < len ; ++ index ) {
        [hierarchy addObject:
            [[Resource alloc] initWithUid:[ids objectAtIndex:index]
                                     type:[types objectAtIndex:index]
                                    title:[names objectAtIndex:index]
                                  version:[[versions objectAtIndex:index] intValue]
                                createdBy:[creators objectAtIndex:index]
                                     data:[datas objectAtIndex:index]]];  
    }
    return hierarchy;                           
}

-(void)dealloc {
    [uid release];
    [type release];
    [title release];
    [createdBy release];
    [data release];
    [super dealloc];
}

@end
