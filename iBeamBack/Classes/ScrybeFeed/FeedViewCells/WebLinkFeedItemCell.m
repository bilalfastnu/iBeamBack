//
//  WebLinkFeedItemCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "WebLinkFeedItemCell.h"

#import "WebLink.h"
#import "SERVER.h" //for weblink icon path
#import "ScrybeImageThumbView.h"
#import "ScrybeResourceImage.h"
#import "WebLinkCustomProperties.h"
#import "Three20/Three20+Additions.h"
@implementation WebLinkFeedItemCell

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
#pragma mark WebLinkFeedItemCell Height

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {  
 
    WebLink *webLink = item;
	
	CGFloat cellHeight = [super tableView:tableView rowHeightForObject:item];
	
    CGSize constraints = CGSizeMake(CELL_CONTENT_WIDTH , CELL_CONTENT_MAX_HEIGHT);
	
    CGFloat textHeight = 0.0;
    
    if ([webLink.customProperty.thumbnailUrl length]){
		
        constraints.width-=IMAGE_THUMB_VIEW_WIDTH;
	}
     else if ([webLink.details length]) {

        CGSize size = [webLink.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
        
        textHeight+= size.height+VERTICAL_DIFERENCE_LABEL;
    }
    cellHeight += (textHeight >= IMAGE_THUMB_VIEW_HEIGHT ? textHeight :IMAGE_THUMB_VIEW_HEIGHT);
   
    return cellHeight+VERTICAL_DIFERENCE_LABEL;
}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark WebLinkFeedItemCell Prepare Cell For Resuse

-(void)prepareForReuse{
	
	[super prepareForReuse];
    
    [scrybeThumbView removeFromSuperview];
	
	TT_RELEASE_SAFELY(scrybeThumbView);

}

///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark WebLinkFeedItemCell initilization

- (id)object {
	return _item;  
}

- (void)setObject:(id)object {
	if (_item != object ) {
		[super setObject:object];
		
		if (object == nil) {
			return;
		}
        
        WebLink *webLink = object;
        
        feedTypeIcon.urlPath = [ScrybeIconPath stringByAppendingString:webLink.customProperty.icon];
        
        feedItemTitleLabel.text = [TTStyledText textFromXHTML:
            [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=WEBLINK?action=%d\">%@</a>    <a href=\"feedId=%d?ID=0?type=COMMENT?action=%d\">Comment</a>", webLink.feedId,webLink.resourceId,OPEN_RESOURCE,webLink.title,webLink.feedId,POST_COMMENT] lineBreaks:YES URLs:NO];

        
        [feedItemTitleLabel sizeToFit];

        float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        y+=feedItemTitleLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;

        if ([webLink.details length]) {
			// set detail of cell
			detailedTextLabel.text = [TTStyledText textFromXHTML:webLink.details lineBreaks:YES URLs:YES];
        }
        
        CGSize size = CGSizeZero;
        CGSize constraints = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);

        BOOL isImageAttached = NO;
        if ([webLink.customProperty.thumbnailUrl length])
        {
            isImageAttached = YES;
             constraints.width-=IMAGE_THUMB_VIEW_WIDTH;
            
			size = [webLink.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
			
            [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X+(IMAGE_THUMB_VIEW_WIDTH+HORIZONTAL_DIFERENCE_LABEL), y+2, size.width+HORIZONTAL_DIFERENCE_LABEL, size.height)];
            
			[detailedTextLabel sizeToFit];
            
           scrybeThumbView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectMake(CONTENTS_STARTING_X, y, IMAGE_THUMB_VIEW_WIDTH, IMAGE_THUMB_VIEW_HEIGHT)];
            
            [scrybeThumbView setIsDrawBoundray:YES];
           
            scrybeThumbView.hidden = NO;

            [scrybeThumbView setImage:[ScrybeResourceImage getScrybeImageForURLVersion:ScryePhotoVersionNone applicationName:@"link" withResourceId:webLink.resourceId withResourceUrl:webLink.customProperty.thumbnailUrl]forState:UIControlStateNormal];
            
            scrybeThumbView.tag = [NSString stringWithFormat:@"feedId=%d?ID=%@?type=WEBLINK?action=%d",webLink.feedId,webLink.resourceId,OPEN_RESOURCE];
          
             
            [scrybeThumbView addTarget:self action:@selector(scrybeThumbViewTaped:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:scrybeThumbView];
        }
        else // if no image is attach with web link
        {
            size = [webLink.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
            
            [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y, CELL_CONTENT_WIDTH,500)];
            [detailedTextLabel sizeToFit];
            y+=detailedTextLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;

        }

       // detailedTextLabel.backgroundColor = [UIColor grayColor];
        
        
        ////////////////////// show conversations ///////////////////////
        
		if (webLink.conversationsCount) {
			
            y+=(isImageAttached == YES ? IMAGE_THUMB_VIEW_HEIGHT+2*VERTICAL_DIFERENCE_LABEL:VERTICAL_DIFERENCE_LABEL);
            
			if (webLink.conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
				
				moreCommentsLabel = [[TTStyledTextLinkLabel alloc] init];
				[moreCommentsLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y , CELL_CONTENT_WIDTH, 25)];
                
                /*moreCommentsLabel.text = [TTStyledText textFromXHTML:
                                          [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=COMMENT?action=%d\"> %d comments</a>", webLink.feedId,webLink.resourceId,SHOW_ALL_COMMENTS,webLink.conversationsCount] lineBreaks:YES URLs:NO];
                */
                
                moreCommentsLabel.text = [TTStyledText textFromXHTML:
                                          [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=COMMENT?action=%d\"> %d comments</a>", webLink.feedId,webLink.resourceId,SHOW_ALL_COMMENTS,webLink.conversationsCount] lineBreaks:YES URLs:NO];
                
                [moreCommentsLabel sizeToFit];
				[self.contentView addSubview:moreCommentsLabel];
                
				y+=4*VERTICAL_DIFERENCE_LABEL;
    		}
			
            [self.contentView addSubview:[super layoutConversations:webLink.conversationsArray delegate:self yOffset:y]];
			
		}
        /////////////////////////////////////////////////////////////////

        
    }
}
///////////////////////////////////////////////////////////////////////////

-(void) scrybeThumbViewTaped:(id)sender
{
    
}

///////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(scrybeThumbView);
    [super dealloc];
}

@end
