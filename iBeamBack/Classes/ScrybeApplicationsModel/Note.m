//
//  Note.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "Note.h"

#import "extThree20JSON/JSON.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@interface Note(PRIVATE)

-(void)setCustomProperties:(NSArray*)customProperty;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Note

@synthesize isTextBroken;
@synthesize imagesArray;
@synthesize filesArray;
@synthesize customPropertiesArray;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithFeedData:(NSDictionary*)data
{
    self = [super initWithFeedData:data];
    
    if (self) {
        
       
        customPropertiesArray = [[[[data objectForKey:@"custom_properties"] JSONValue] objectForKey:@"files"] retain];

        NSString *textBroken = [[[data objectForKey:@"custom_properties"] JSONValue] objectForKey:@"is_text_broken"];
        
        isTextBroken = ([textBroken isEqualToString:@"1"] ? YES : NO);
        //NSLog(@"data : %@",[data objectForKey:@"custom_properties"]);

        if ([customPropertiesArray count]) {
            
            imagesArray = [[NSMutableArray alloc] init];
            filesArray = [[NSMutableArray alloc] init];
            [self setCustomProperties:customPropertiesArray];
        }
    }
    
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setCustomProperties:(NSArray*)customProperty
{
    //NSLog(@"Custom Properties %@",customPropertiesArray);
    
    int minCount = MIN([customProperty count],4); 
     
    NSDictionary *tempDictionary = nil;
    for (int i= 0 ; i < minCount; i++) {
        
        tempDictionary = [customProperty objectAtIndex:i];
        
        if ([[tempDictionary objectForKey:@"file_format"] isEqualToString:@"IMAGE"]) {
            
            NoteCustomProperties *property = [[NoteCustomProperties alloc] initWithCustomProperty:tempDictionary];
            //  NSLog(@"Properties %@",property);
            [imagesArray addObject:property];
            [property release];
        }
    }

}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) dealloc
{
    [filesArray release];
	[imagesArray release];
    [customPropertiesArray release];
    
    [super dealloc];
}

@end
