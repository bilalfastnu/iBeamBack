//
//  NoteFeedItemCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteFeedItemCell.h"

#import "Note.h"
#import "ScrybeResourceImage.h"
#import "NoteCustomProperties.h"

#import "ScrybeImageThumbView.h"

@implementation NoteFeedItemCell

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
#pragma mark NoteFeedItemCell Height

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {  

    Note *note = item;
    
    CGFloat cellHeight = [super tableView:tableView rowHeightForObject:item];
    
    if ([note.imagesArray count]){
		
		cellHeight+= IMAGE_THUMB_VIEW_HEIGHT;
		cellHeight+= VERTICAL_DIFERENCE_LABEL;
	}
    
    if ([note.details length]  && [note.imagesArray count] != 1) {
		
		// detailed text height
		CGSize constraintsLabel = CGSizeMake(CELL_CONTENT_WIDTH , CELL_CONTENT_MAX_HEIGHT);
		
		CGSize sizeLabel = [note.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraintsLabel lineBreakMode:UILineBreakModeWordWrap];
		
		cellHeight+= sizeLabel.height+VERTICAL_DIFERENCE_LABEL;
	}

    
    return cellHeight;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NoteFeedItemCell Prepare Cell For Resuse

-(void)prepareForReuse{
	
	[super prepareForReuse];
    
    for (ScrybeImageThumbView *scrybeThumbView in attachedImagesArray) {
		
		[scrybeThumbView removeFromSuperview];
	}
    
	[attachedImagesArray release];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NoteFeedItemCell initilization

- (id)object {
	return _item;  
}

- (void)setObject:(id)object {
	if (_item != object ) {
		[super setObject:object];
		
		if (object == nil) {
			return;
		}
        
       Note *note = object;
        
		feedTypeIcon.urlPath = [NSString stringWithFormat:@"bundle://%@",Notes16];
        
        feedItemTitleLabel.text = [TTStyledText textFromXHTML:
                  [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=NOTE?action=%d\">%@</a>    <a href=\"feedId=%d?ID=0?type=COMMENT?action=%d\">Comment</a>", note.feedId,note.resourceId,OPEN_RESOURCE,note.title,note.feedId,POST_COMMENT] lineBreaks:YES URLs:NO];

        [feedItemTitleLabel sizeToFit];
        
        float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        y+=feedItemTitleLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        if ([note.details length]) {
			// set detail of cell
			detailedTextLabel.text  = [TTStyledText textFromXHTML:note.details lineBreaks:YES URLs:YES];
        }
        
        CGSize size = CGSizeZero;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_MAX_HEIGHT);
       
        int imagesCount = MIN([note.imagesArray count], 4);

        if (imagesCount == 1) {// if more than 1 images is attached with note
			
            constraint.width-=IMAGE_THUMB_VIEW_WIDTH;
            
			size = [note.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			
           [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X+(IMAGE_THUMB_VIEW_WIDTH+HORIZONTAL_DIFERENCE_LABEL), y+2, size.width+HORIZONTAL_DIFERENCE_LABEL, size.height)];

			[detailedTextLabel sizeToFit];
        }
        else{
            
            size = [note.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

            [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y, CELL_CONTENT_WIDTH,500)];
            [detailedTextLabel sizeToFit];
            
            y+=detailedTextLabel.frame.size.height;
            y+=(imagesCount > 0 ? VERTICAL_DIFERENCE_LABEL : 0);
        }
       
        ///////////////// show images ///////////////////////////////////
        float x = 0.0;
        attachedImagesArray = [[NSMutableArray alloc] initWithCapacity:imagesCount];
        
        for (int i=0; i < imagesCount; i++) {
            
            NoteCustomProperties *customProperty = [note.imagesArray objectAtIndex:i];

            ScrybeImageThumbView *scrybeThumbView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectMake(CONTENTS_STARTING_X +x, y, IMAGE_THUMB_VIEW_WIDTH, IMAGE_THUMB_VIEW_HEIGHT)];
            
            [scrybeThumbView setIsDrawBoundray:YES];
            
            [scrybeThumbView setImage:[ScrybeResourceImage getScrybeImageForURLVersion:ScryePhotoVersionThumbnail applicationName:@"note" withResourceId:note.resourceId withResourceUrl:customProperty.thumbnailName]forState:UIControlStateNormal];
            
            scrybeThumbView.hidden = NO;
            
            scrybeThumbView.tag = [NSString stringWithFormat:@"feedId=%d?ID=%@?type=%@?action=%d",note.feedId,customProperty.Id,customProperty.type,OPEN_RESOURCE];
            
            [scrybeThumbView addTarget:self action:@selector(scrybeThumbViewTaped:) forControlEvents:UIControlEventTouchUpInside];
            
            [attachedImagesArray addObject:scrybeThumbView];
            
            [self.contentView addSubview:scrybeThumbView];
            
            [scrybeThumbView release];
            
            
            x+=IMAGE_THUMB_VIEW_WIDTH+HORIZONTAL_DIFERENCE_LABEL;
            
        }
        
        /////////////////////////////////////////////////////////////////
        
        ////////////////////// show conversations ///////////////////////
        
		if (note.conversationsCount) {
			
             y+=(imagesCount >= 1 ? IMAGE_THUMB_VIEW_HEIGHT+2*VERTICAL_DIFERENCE_LABEL:VERTICAL_DIFERENCE_LABEL);

			if (note.conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
				
				moreCommentsLabel = [[TTStyledTextLinkLabel alloc] init];
				[moreCommentsLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y , CELL_CONTENT_WIDTH, 25)];
				
                moreCommentsLabel.text = [TTStyledText textFromXHTML:
                   [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=COMMENT?action=%d\"> %d comments</a>", note.feedId,note.resourceId,SHOW_ALL_COMMENTS,note.conversationsCount] lineBreaks:YES URLs:NO];
                
                [moreCommentsLabel sizeToFit];
				[self.contentView addSubview:moreCommentsLabel];
                
				y+=4*VERTICAL_DIFERENCE_LABEL;
    		}
			
           [self.contentView addSubview:[super layoutConversations:note.conversationsArray delegate:self yOffset:y]];
			
		}
        /////////////////////////////////////////////////////////////////
    }
}

///////////////////////////////////////////////////////////////////////////

-(void) scrybeThumbViewTaped:(id)sender
{
    ScrybeImageThumbView *thumbView = (ScrybeImageThumbView*)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResourceTaped" object:thumbView.tag ];
 
}
///////////////////////////////////////////////////////////////////////////
-(void) snippetViewTapped:(id) p_conversation
{
    //Conversation *conversation = (Conversation*) p_conversation;
    
}

///////////////////////////////////////////////////////////////////////////

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [attachedImagesArray release];
    [super dealloc];
}

@end
