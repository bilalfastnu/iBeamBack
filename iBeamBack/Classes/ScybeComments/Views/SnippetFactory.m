//
//  SnippetFactory.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "SnippetFactory.h"

#import "CELL.h"
#import "ICONS.h"
#import "Conversation.h"


@implementation SnippetFactory

///////////////////////////////////////////////////////////////////////////
-(NoteSnippetView *) getNoteSnippetForData:(NSMutableDictionary*) data
{
	NSString *text = [data objectForKey:@"text"];
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:CGSizeMake(TEXT_SNIPPET_WIDTH, TEXT_SNIPPET_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
	
	//NSString *subString = [text substringToIndex:MAX_TEXT_SNIPPET_LENGTH];
    text = ([text length] >= MAX_TEXT_SNIPPET_LENGTH ? [text substringToIndex:MAX_TEXT_SNIPPET_LENGTH] :text);

    // size.height = ([text length] >= MAX_TEXT_SNIPPET_LENGTH ? MAX_TEXT_SNIPPET_HEIGHT : size.height);
	
    NoteSnippetView *noteSnippetView = [[NoteSnippetView alloc] initWithFrame:CGRectZero];
	//NoteSnippetView *noteSnippetView = [[[NoteSnippetView alloc] initWithFrame:CGRectMake(30.0, 0.0, TEXT_SNIPPET_WIDTH+5, size.height)] autorelease];
	
	noteSnippetView.label.text  = ([text length] >= MAX_TEXT_SNIPPET_LENGTH ?[[text substringToIndex:MAX_TEXT_SNIPPET_LENGTH]stringByAppendingString:@"..."]:text);
    
    noteSnippetView.label.frame = CGRectMake(5, 2.0, TEXT_SNIPPET_WIDTH,size.height);
    
    [noteSnippetView.label sizeToFit];
    
    //x , y will be set by conversation View
    noteSnippetView.frame = CGRectMake(0.0, 0.0, TEXT_SNIPPET_WIDTH, noteSnippetView.label.frame.size.height+5);
	
	return noteSnippetView;
    
}

/*-(NoteSnippetView *) getNoteSnippetForData:(NSMutableDictionary*) data
{
	NSString *text = [data objectForKey:@"text"];
	
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:CGSizeMake(TEXT_SNIPPET_WIDTH, TEXT_SNIPPET_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
	
	size.height = ([text length] >= MAX_TEXT_SNIPPET_LENGTH ? MAX_TEXT_SNIPPET_HEIGHT : size.height);
	
    NoteSnippetView *noteSnippetView = [[NoteSnippetView alloc] initWithFrame:CGRectZero];
	//NoteSnippetView *noteSnippetView = [[[NoteSnippetView alloc] initWithFrame:CGRectMake(30.0, 0.0, TEXT_SNIPPET_WIDTH+5, size.height)] autorelease];
	
	noteSnippetView.label.text  = ([text length] >= MAX_TEXT_SNIPPET_LENGTH ?[[text substringToIndex:MAX_TEXT_SNIPPET_LENGTH]stringByAppendingString:@"..."]:text);
    
    noteSnippetView.label.frame = CGRectMake(5, 2.0, TEXT_SNIPPET_WIDTH,size.height);
    
    [noteSnippetView.label sizeToFit];
    
    //x , y will be set by conversation View
    noteSnippetView.frame = CGRectMake(0.0, 0.0, TEXT_SNIPPET_WIDTH, noteSnippetView.label.frame.size.height+5);
	
	return noteSnippetView;
    
}*/
///////////////////////////////////////////////////////////////////////////
-(UIImage *) getImageSnippetForData:(NSMutableDictionary*) data
{
	NSArray *arrayOfNumbers = [data objectForKey:@"pixels"];
	
	unsigned char *buffer = (unsigned char*)malloc([arrayOfNumbers count]);
	int i=0;
	for (NSDecimalNumber *num in arrayOfNumbers) {
		buffer[i++] = [num intValue];
	}
	NSData *myNSData = [NSData dataWithBytes:buffer length:[arrayOfNumbers count]];
	
	free(buffer);
	
    
	//UIImageView *bitmapSnippetView =[[[UIImageView alloc] initWithImage:[UIImage imageWithData:myNSData]] autorelease];
	
	return [UIImage imageWithData:myNSData];
}
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
