//
//  MessageFeedItemCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MessageFeedItemCell.h"

#import "Message.h"

@implementation MessageFeedItemCell

///////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MessageFeedItemCell Height

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item { 
    
    
    Message *message = item;
	
	CGFloat cellHeight = [super tableView:tableView rowHeightForObject:item];
	
    if ([message.details length]) {
       
        // detailed text height
        CGSize constraints = CGSizeMake(CELL_CONTENT_WIDTH-2*HORIZONTAL_DIFERENCE_LABEL, CELL_CONTENT_MAX_HEIGHT);
        
        CGSize size = [message.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
        
        cellHeight += (size.height < 30 ? 30 : size.height);
        cellHeight+=4*VERTICAL_DIFERENCE_LABEL;

    }
	return cellHeight;

}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MessageFeedItemCell Prepare Cell For Resuse

-(void)prepareForReuse{
	
	[super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MessageFeedItemCell initilization

- (id)object {
	return _item;  
}

- (void)setObject:(id)object {
	if (_item != object ) {
		[super setObject:object];
		
		if (object == nil) {
			return;
		}
    
        Message *message = object;
        
        feedTypeIcon.urlPath = [NSString stringWithFormat:@"bundle://%@",Message16];

        feedItemTitleLabel.text = [TTStyledText textFromXHTML:
                 [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=MESSAGE?action=%d\">%@</a>    <a href=\"feedId=%d?ID=0?type=COMMENT?action=%d\">Comment</a>", message.feedId,message.resourceId,OPEN_RESOURCE,message.title,message.feedId,POST_COMMENT] lineBreaks:YES URLs:NO];
        
        [feedItemTitleLabel sizeToFit];
        

        float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        y+=feedItemTitleLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        
        if ([message.details length]) {
            // set detail of cell
            y+=2*VERTICAL_DIFERENCE_LABEL;
            detailedTextLabel.text = [TTStyledText textFromXHTML:message.details lineBreaks:YES URLs:YES];
            
            CGSize constraints = CGSizeMake(CELL_CONTENT_WIDTH-2*HORIZONTAL_DIFERENCE_LABEL, CELL_CONTENT_MAX_HEIGHT);

            
            CGSize size = [message.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];

            [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X+2*HORIZONTAL_DIFERENCE_LABEL,y,size.width,size.height)];

            //y+=size.height+2*VERTICAL_DIFERENCE_LABEL;
        }
        
     //   detailedTextLabel.backgroundColor = [UIColor grayColor];

        ////////////////////// show conversations ///////////////////////
        
		if (message.conversationsCount) {
			
            y+=detailedTextLabel.frame.size.height+4*VERTICAL_DIFERENCE_LABEL;
			if (message.conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
				
				moreCommentsLabel = [[TTStyledTextLinkLabel alloc] init];
				[moreCommentsLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y , CELL_CONTENT_WIDTH, 25)];
                
                moreCommentsLabel.text = [TTStyledText textFromXHTML:
                                          [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=NOTE?action=%d\"> %d comments</a>", message.feedId,message.resourceId,SHOW_ALL_COMMENTS,message.conversationsCount] lineBreaks:YES URLs:NO];

               /* moreCommentsLabel.text = [TTStyledText textFromXHTML:
                                          [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=COMMENT?action=%d\"> %d comments</a>", message.feedId,message.resourceId,SHOW_ALL_COMMENTS,message.conversationsCount] lineBreaks:YES URLs:NO];
                    */
                [moreCommentsLabel sizeToFit];
				[self.contentView addSubview:moreCommentsLabel];
                
				y+=4*VERTICAL_DIFERENCE_LABEL;
    		}
			
            [self.contentView addSubview:[super layoutConversations:message.conversationsArray delegate:self yOffset:y]];
			
		}
        /////////////////////////////////////////////////////////////////

        
    }
}

///////////////////////////////////////////////////////////////////////////

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect frame = detailedTextLabel.frame;
  
    float x = frame.origin.x -20 ,y = frame.origin.y;
    float width = x+CELL_CONTENT_WIDTH, height = frame.size.height+5;
    
	if (height < 30) {
		height = 30;
	}
    // grab the current view graphics context
	// the context is basically our invisible canvas that we draw into.
	CGContextRef context    = UIGraphicsGetCurrentContext();
	
	// Drawing lines with an RGB based color
	CGContextSetRGBStrokeColor(context, 0.9, 0.6, 0.1, 0.5);
	
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.3);
	
	// lets set the starting point of our line, at x position 10, and y position 30
	CGContextMoveToPoint(context, x, y);
    
    // Draw a connected sequence of line segments
	// here we are creating an Array of points that we will combine to form
	// a path
	
    CGPoint addLines[] =
	{
		CGPointMake(x, y+2),
		CGPointMake(x+12.0f, y+7.0f),
		CGPointMake(x, y+2),
		CGPointMake(x+12.0f, y+15.0f),
	};
	
	CGContextMoveToPoint(context, x+20.0f, y-7); //draw straight line   -----------
    
	CGContextAddLineToPoint(context, width-2,y-7);//draw straight line//y+LINE_SlOPE-15.0f
	
	CGContextMoveToPoint(context, width+5.0f ,y+6); //draw right down line							|
	CGContextAddLineToPoint(context, width+5.0f, y+height-6);//draw right down line						|
    
	CGContextMoveToPoint(context, x+12.0f, y+15.0f); //draw right down line							|
	CGContextAddLineToPoint(context, x+12.0f, y+height-6);//draw right down line					
	
	
	CGContextMoveToPoint(context, x+20.0f, y+height); //draw straight line  
	CGContextAddLineToPoint(context, width, y+height);//draw straight line -------------------
	
	
    // now we can simply add the lines to the context
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
	CGContextStrokePath(context);
    
    ////////////////////  End Lines ///////////////////////////
	// draw the Left upper curve 
	CGContextRef bezierContext = UIGraphicsGetCurrentContext();
	
	CGMutablePathRef bezierPath = CGPathCreateMutable();
	
	CGPathMoveToPoint(bezierPath, nil,x+12,y+7.0f);
	CGPathAddQuadCurveToPoint(bezierPath,nil,x+10.0f,y-7,x+20.0f,y-7);
	
	//draw the right upper corner
	CGPathMoveToPoint(bezierPath, nil, width-2, y-7);
	CGPathAddQuadCurveToPoint(bezierPath, nil, width+5.0f, y-7,width+5,y+6);
	
	//draw the right down corner
	CGPathMoveToPoint(bezierPath, nil,  width+5.0f, y+height-6);
	CGPathAddQuadCurveToPoint(bezierPath, nil, width+5.0f,y+height,width,y+height);

	CGPathMoveToPoint(bezierPath, nil,x+12.0f, y+height-6);
	CGPathAddQuadCurveToPoint(bezierPath, nil, x+12.0f, y+height,x+20.0f,y+height);
    
	
	CGContextAddPath(bezierContext, bezierPath);
	CGContextStrokePath(bezierContext);
	CFRelease(bezierPath);
} 


///////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
