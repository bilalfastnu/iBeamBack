//
//  NoteSnippetView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteSnippetView.h"

#import <QuartzCore/QuartzCore.h>

#import "ICONS.h"

@implementation NoteSnippetView

@synthesize conversationDelegate;
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
        conversationDelegate = nil;
        
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor colorWithRed:255/255.f green:250/255.f blue:235/255.f alpha:1];	
        //label.backgroundColor= [UIColor grayColor];
		label.numberOfLines = 0;
		label.font = [UIFont systemFontOfSize:13];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
		[self addSubview:label];
             
		self.backgroundColor = [UIColor clearColor];
		UIImage *image = [UIImage imageNamed:TextSnippetIcon];
		
		int height = arc4random() % 30;
		
		image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:height];
		
		self.image = image;
		
		// A thin border.
		//self.layer.borderColor = [UIColor blackColor].CGColor;
		//self.layer.borderWidth = 0.3;
		
		// Drop shadow.
		[[self layer] setMasksToBounds:NO];
		self.layer.shadowOpacity = 0.5;
		self.layer.shadowRadius = 7.0;
		self.layer.shadowOffset = CGSizeMake(0, 3);

	}
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([conversationDelegate respondsToSelector:@selector(snippetViewTapped:)]) {
        
        [conversationDelegate performSelector:@selector(snippetViewTapped:)];
    } 
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	
	[label release];
	
    [super dealloc];
}


@end
