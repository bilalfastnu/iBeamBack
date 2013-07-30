//
//  ResourcePath.m
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ResourcePath.h"

#import "Resource.h"

#import "extThree20JSON/JSON.h"

@implementation ResourcePath
@synthesize appInstaceID;
@synthesize hierarchy;

-(id)init {
    self = [super init];
    if(self) {
        appInstaceID = 0;
        hierarchy = nil;
    }
    return self;
}

-(id)initWithAppInstanceID:(NSInteger)p_appInstanceID hierarchy:(NSMutableArray *)p_hierarchy {
    self = [super init];
    if(self) {
        appInstaceID = p_appInstanceID;
        hierarchy = p_hierarchy;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    ResourcePath *clone = [[ResourcePath alloc] initWithAppInstanceID:self.appInstaceID
                                                          hierarchy:[self.hierarchy copy]];
    return clone;
}

-(NSString*) getPathIDs
{
    NSString *uids = nil;
    if ([hierarchy count]) {
         
       Resource *resource = [hierarchy objectAtIndex:0];
       uids = [[[NSString alloc] initWithString:resource.uid] autorelease];
        for (int i= 1; i < [hierarchy count]; i++) {
           
            resource = [hierarchy objectAtIndex:i];
            uids = [uids stringByAppendingFormat:@",%@",resource.uid];
        }
    }
    return uids;
}


-(NSMutableDictionary*) getJSONProperties
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *versions = [[NSMutableArray alloc] init];
    NSMutableArray *names = [[NSMutableArray alloc] init];
    NSMutableArray *creators = [[NSMutableArray alloc] init];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *types = [[NSMutableArray alloc] init];
    
    Resource *resource  = nil;
    
    for (int i= 0; i < [hierarchy count]; i++) {
        
        resource = [hierarchy objectAtIndex:i];
        [names addObject:resource.title];
        [versions addObject:[NSNumber numberWithInt:resource.version]];
        [types addObject:resource.type];
        [creators addObject:resource.createdBy];
        if (resource.data) {
            [data addObject:resource.data];
        }else
        {
            [data addObject:[NSNull null]];
        }
        
    }
    [properties setValue:[names JSONRepresentation] forKey:@"titles"];
    [properties setValue:[types JSONRepresentation] forKey:@"types"];
    [properties setValue:[versions JSONRepresentation] forKey:@"versions"];
    [properties setValue:[data JSONRepresentation] forKey:@"datas"];
    [properties setValue:[creators JSONRepresentation] forKey:@"createdBys"];

    return properties;
}

-(void)dealloc {
    [hierarchy release]; 
    [super dealloc];
}
@end
