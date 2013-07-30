//
//  CollaborationInfo.m
//  iBeamBack
//
//  Created by Ali Hassan on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "CollaborationInfo.h"

#import "SnippetData.h"
#import "extThree20JSON/JSON.h"

@implementation CollaborationInfo

@synthesize parentResourceIndex;
@synthesize snippetData;

-(id) init {
    self = [super init];
    if(self){
        self.parentResourceIndex = -1;
        self.snippetData = nil;
    }
    return self;
}

-(id) initWithSnippetData:(SnippetData*) p_snippetData parentResourceIndex:(NSInteger) p_parentResourceIndex {
    self = [super init];
    if( self ) {
        self.snippetData = p_snippetData;
        self.parentResourceIndex = p_parentResourceIndex;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    CollaborationInfo * clone = [[CollaborationInfo alloc] 
                                 initWithSnippetData:self.snippetData 
                                 parentResourceIndex:self.parentResourceIndex];
    return clone;
}

+(CollaborationInfo *) createFromJSON:(NSString*) jsonString
{
    
    NSDictionary *dictionary = [jsonString JSONValue];
  
    SnippetData *sData = nil;
    NSDictionary *snippetDictionary = [dictionary objectForKey:@"snippetData"];
    
    if (snippetDictionary != (NSDictionary*)[NSNull null]) {
        sData = [[SnippetData alloc] initWithType:[snippetDictionary objectForKey:@"type"] data:[snippetDictionary objectForKey:@"data"]];
    }
    CollaborationInfo *info = [[CollaborationInfo alloc] initWithSnippetData:sData parentResourceIndex:[[dictionary objectForKey:@"parentResourceIndex"]intValue]];
    
    return info;
}

-(NSString*) getJSONRepresentation
{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dict setValue:[NSNumber numberWithInt:parentResourceIndex] forKey:@"parentResourceIndex"];
    if (snippetData) {
        
        [dict setValue:[snippetData getValueObjectForServer] forKey:@"snippetData"];
    }

    return [dict JSONRepresentation];
}

-(void)dealloc {
    [snippetData release];
    [super dealloc];
}
@end
