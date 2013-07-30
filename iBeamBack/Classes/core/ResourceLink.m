//
//  ResourceLink.m
//  iBeamBack
//
//  Created by Ali Hassan on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ResourceLink.h"


@implementation ResourceLink

@synthesize collaborationInfo;
@synthesize resourcePath;
@synthesize data;


-(id)init {
    self = [super init];
    if(self) {
        self.collaborationInfo = nil;
        self.resourcePath = nil;
        self.data = nil;
    }
    return self;    
}

-(id)initWithResourcePath:(ResourcePath *) p_resourcePath 
        collaborationInfo:(CollaborationInfo *)p_collaborationInfo
                     data:(NSMutableDictionary *)p_data {
    self = [super init];
    if(self) {
        self.resourcePath = p_resourcePath;
        self.collaborationInfo = p_collaborationInfo;
        self.data = p_data;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
   ResourceLink * clone = [[ResourceLink alloc] 
                           initWithResourcePath:[self.resourcePath copy]
                           collaborationInfo:[self.collaborationInfo copy]
                           data:[self.data copy]];
    return clone;
}

-(void)dealloc {
    [resourcePath release];
    [collaborationInfo release];
    [data release];
    [super dealloc];
}

@end
