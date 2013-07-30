//
//  NoteCustomProperties.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteCustomProperties.h"



@implementation NoteCustomProperties

@synthesize type;

@synthesize  size, width, height;

@synthesize Id, name, setName, previewName, originalName, thumbnailName;
@synthesize item_Id, file_Id;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject
{
    self = [super init];
    
	if (self) {
        
        
        item_Id = [[dictionaryObject objectForKey:@"item_id"] retain];
        file_Id = [[dictionaryObject objectForKey:@"file_id"] retain];
        
        name = [[dictionaryObject objectForKey:@"name"] retain];
        Id = [[dictionaryObject objectForKey:@"id"] retain];
        width = [[dictionaryObject objectForKey:@"width"] intValue];
        height = [[dictionaryObject objectForKey:@"height"] intValue];
        size = [[dictionaryObject objectForKey:@"size"] intValue];
        originalName = [[dictionaryObject objectForKey:@"original_name"] retain];
        thumbnailName = [[dictionaryObject objectForKey:@"thumbnail_name"] retain];
        previewName = [[dictionaryObject objectForKey:@"preview_name"] retain];
        type = [[dictionaryObject objectForKey:@"type"] retain];
        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) dealloc
{
    [file_Id release];
    [item_Id release];
    
    [Id release];
    [name release];
    [type release];
	[setName release];
	[previewName release];
	[originalName release];
	[thumbnailName release];
 
	[super dealloc];
}

@end
