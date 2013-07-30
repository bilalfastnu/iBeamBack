//
//  CollaborationInfo.h
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SnippetData;

@interface CollaborationInfo : NSObject<NSCopying> {
    NSInteger     parentResourceIndex;
    SnippetData * snippetData;
}
@property(nonatomic,assign) NSInteger parentResourceIndex;
@property(nonatomic,retain) SnippetData * snippetData;

+(CollaborationInfo *) createFromJSON:(NSString*) jsonString;

-(NSString*) getJSONRepresentation;

-(id) initWithSnippetData:(SnippetData*) p_snippetData parentResourceIndex:(NSInteger) p_parentResourceIndex;

@end
