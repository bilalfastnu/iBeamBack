//
//  TTStyledTextLinkLabel.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "TTStyledTextLinkLabel.h"


@implementation TTStyledTextLinkLabel

@synthesize delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        delegate = nil;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	//[self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_highlightedNode) {
        // This is a dirty hack to decouple the UI from Style. TTOpenURL was originally within
        // the node implementation. One potential fix would be to provide some protocol for these
        // nodes to converse with.
        
        if ([_highlightedNode isKindOfClass:[TTStyledLinkNode class]]) {
            //TTOpenURL([(TTStyledLinkNode*)_highlightedNode URL]);
            
            NSLog(@"URL Descr %@",[[(TTStyledLinkNode*)_highlightedNode URL] description]);
            [delegate resourceTaped:self receivedObject:[(TTStyledLinkNode*)_highlightedNode URL]];
            if (!delegate) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResourceTaped" object:[(TTStyledLinkNode*)_highlightedNode URL] ];
            }
            
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"LinkTaped" object:[(TTStyledLinkNode*)_highlightedNode URL] ];
            
        } else if ([_highlightedNode isKindOfClass:[TTStyledButtonNode class]]) {
            //TTOpenURL([(TTStyledButtonNode*)_highlightedNode URL]);
            NSLog(@"URLBtton Descr %@",[[(TTStyledLinkNode*)_highlightedNode URL] description]);
        } else {
            [_highlightedNode performDefaultAction];
        }
         [self setHighlightedFrame:nil];
    }
	
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesMoved:touches withEvent:event];
}

@end
