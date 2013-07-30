//
//  ResourceLink.h
//  iBeamBack
//
//  Created by Ali Hassan on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CollaborationInfo;
@class ResourcePath;

@interface ResourceLink : NSObject<NSCopying> {
    CollaborationInfo   * collaborationInfo;
    ResourcePath        * resourcePath;
    NSMutableDictionary * data;
}

@property(nonatomic,retain) CollaborationInfo       * collaborationInfo;
@property(nonatomic,retain) ResourcePath            * resourcePath;
@property(nonatomic,retain) NSMutableDictionary     * data;

-(id)initWithResourcePath:(ResourcePath *) p_resourcePath 
        collaborationInfo:(CollaborationInfo *)p_collaborationInfo
                     data:(NSMutableDictionary *)p_data;

@end
