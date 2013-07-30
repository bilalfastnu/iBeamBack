//
//  FeedItemCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedItemCell.h"

#import "Three20/Three20+Additions.h"
#import "ScrybeUserImage.h"
#import "DateManager.h"

@implementation FeedItemCell

@synthesize feedTypeIcon, moreCommentsLabel;

@synthesize feedItemTitleLabel, sharingInfoLabel, detailedTextLabel;

@synthesize conversationsViews;
///////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         _item = nil;
         conversationsViews = nil;
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell
///////////////////////////////////////////////////////////////////////////

+(CGFloat) calculateHeightForConversation:(NSMutableArray *) conversations
{
    
    CGSize constraints = CGSizeMake(CONVERSATIONS_CELL_CONTENT_WIDTH,CELL_CONTENT_MAX_HEIGHT);
	CGSize size = CGSizeZero;
	int conversationsCount = [conversations count];
	
	CGFloat cellHeight = 2*VERTICAL_DIFERENCE_LABEL;
	
    Conversation *conversation = nil;
	BOOL isTextSnippet = NO;
	int i =0;
	if (conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
		
		i = conversationsCount-MAX_CONVERSATIONS_DISPLAY;
		cellHeight+= 2*VERTICAL_DIFERENCE_LABEL; //for comment text label
	}
    
	for ( ; i < conversationsCount ; i++) {
		
		conversation = [conversations objectAtIndex:i];
		
        NSInteger parentResourceIndex =  conversation.resourceLink.collaborationInfo.parentResourceIndex;
        NSInteger hierarcyCount = [conversation.resourceLink.resourcePath.hierarchy count];
        
        //calculate height of subresource title
        if (parentResourceIndex != -1 &&(parentResourceIndex+1) < hierarcyCount)
        {
            Resource *resource =[conversation.resourceLink.resourcePath.hierarchy objectAtIndex:hierarcyCount-1];
            size = [resource.title sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
            cellHeight+=size.height;
        }
		
        NSString *creationInfo = [[[UserManager sharedUserManager] getFullName:conversation.initiatedBy] stringByAppendingString:@", "];
        
        if ([conversation.updatedBy length]) {
            creationInfo = [creationInfo stringByAppendingString:@"Updated "];
        }
        
        creationInfo = [creationInfo stringByAppendingString:[[DateManager sharedDateManager] getReletiveDate:conversation.postDate]];
        
        NSString *commentText = [conversation.comments stringByRemovingHTMLTags];
        
        size = [[commentText stringByAppendingString:creationInfo] sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];

         cellHeight+=size.height+VERTICAL_DIFERENCE_LABEL;
        
        SnippetData *snippetData = conversation.resourceLink.collaborationInfo.snippetData;
        if (snippetData.data != (NSMutableDictionary*) [NSNull null]) {
            
            if ([snippetData.type isEqualToString:NOTE_SNIPPET])
            {
                NSString *textSnippet = [snippetData.data objectForKey:@"text"];
                
                textSnippet = ([textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? [textSnippet substringToIndex:MAX_TEXT_SNIPPET_LENGTH] :textSnippet);
                
                size = [textSnippet sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:CGSizeMake(TEXT_SNIPPET_WIDTH, TEXT_SNIPPET_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
                
                cellHeight+=size.height;
                
                cellHeight+=(isTextSnippet == YES && [textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? 3*VERTICAL_DIFERENCE_LABEL: VERTICAL_DIFERENCE_LABEL);
                
                isTextSnippet = YES;
            }
            else if ([snippetData.type isEqualToString:IMAGE_SNIPPET])
            {
                cellHeight+=[[snippetData.data objectForKey:@"height"] intValue];
                cellHeight+=VERTICAL_DIFERENCE_LABEL;
            }
        }
   }
    
    cellHeight+= (conversationsCount > 1 ? 3*(VERTICAL_DIFERENCE_LABEL) : 0);
    return cellHeight+VERTICAL_DIFERENCE_LABEL;
}
/*+(CGFloat) calculateHeightForConversation:(NSMutableArray *) conversations
{
    
    CGSize constraints = CGSizeMake(CONVERSATIONS_CELL_CONTENT_WIDTH,CELL_CONTENT_MAX_HEIGHT);
	CGSize size = CGSizeZero;
	int conversationsCount = [conversations count];
	
	CGFloat cellHeight = 2*VERTICAL_DIFERENCE_LABEL;
	
    Conversation *conversation = nil;
	BOOL isTextSnippet = NO;
	int i =0;
	if (conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
		
		i = conversationsCount-MAX_CONVERSATIONS_DISPLAY;
		cellHeight+= 2*VERTICAL_DIFERENCE_LABEL; //for comment text label
	}
	
	for ( ; i < conversationsCount ; i++) {
		
		conversation = [conversations objectAtIndex:i];
		
        NSInteger parentResourceIndex =  conversation.resourceLink.collaborationInfo.parentResourceIndex;
        NSInteger hierarcyCount = [conversation.resourceLink.resourcePath.hierarchy count];
        
        //calculate height of subresource title
        if (parentResourceIndex != -1 &&(parentResourceIndex+1) < hierarcyCount)
        {
            Resource *resource =[conversation.resourceLink.resourcePath.hierarchy objectAtIndex:hierarcyCount-1];
            size = [resource.title sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
            cellHeight+=size.height;
        }
		
        NSString *commentText = [conversation.comments stringByRemovingHTMLTags];
        size = [commentText sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
        
        cellHeight+=size.height;
        
        SnippetData *snippetData = conversation.resourceLink.collaborationInfo.snippetData;
        if (snippetData.data != (NSMutableDictionary*) [NSNull null]) {
            
            if ([snippetData.type isEqualToString:NOTE_SNIPPET])
            {
                NSString *textSnippet = [snippetData.data objectForKey:@"text"];
                
                textSnippet = ([textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? [textSnippet substringToIndex:MAX_TEXT_SNIPPET_LENGTH] :textSnippet);
                
                size = [textSnippet sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:CGSizeMake(TEXT_SNIPPET_WIDTH, TEXT_SNIPPET_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
                
                cellHeight+=size.height;
               
                cellHeight+=(isTextSnippet == YES && [textSnippet length] >= MAX_TEXT_SNIPPET_LENGTH ? 3*VERTICAL_DIFERENCE_LABEL: VERTICAL_DIFERENCE_LABEL);

                isTextSnippet = YES;
            }
            else if ([snippetData.type isEqualToString:IMAGE_SNIPPET])
            {
                cellHeight+=[[snippetData.data objectForKey:@"height"] intValue];
                
                // cellHeight+=VERTICAL_DIFERENCE_LABEL;
            }
        }
    }
    
    cellHeight+= (conversationsCount > 1 ? 4*(VERTICAL_DIFERENCE_LABEL) : 0);
    return cellHeight+VERTICAL_DIFERENCE_LABEL;
}*/

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark FeedItemCell Height
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item {  

    FeedItem *feedItem = item;
	
	CGSize constraintsLabel = CGSizeMake(CELL_CONTENT_WIDTH , CELL_CONTENT_MAX_HEIGHT);
	
	TTStyledTextLabel *fontLabel = [[TTStyledTextLabel alloc] init]; 
	NSString *titleString = [feedItem.title stringByAppendingString:@"            Comment"];
	CGSize size = [titleString sizeWithFont:fontLabel.font constrainedToSize:constraintsLabel lineBreakMode:UILineBreakModeWordWrap];
	
	CGFloat cellHeight = VERTICAL_DIFERENCE_LABEL+size.height;
	
	NSString *sharingInfo = feedItem.sharingInfo;
	
	size = [[sharingInfo stringByRemovingHTMLTags] sizeWithFont:fontLabel.font constrainedToSize:constraintsLabel lineBreakMode:UILineBreakModeWordWrap];
	
	[fontLabel release];
	
	cellHeight+= VERTICAL_DIFERENCE_LABEL+size.height+VERTICAL_DIFERENCE_LABEL;
	
    if ([feedItem.conversationsArray count]) {
        
        cellHeight+=[self calculateHeightForConversation:feedItem.conversationsArray];
    } 

    
    return cellHeight;
}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark FeedItemCell Prepare Cell For Resuse

-(void)prepareForReuse{
	
    [super prepareForReuse];
	
	[feedTypeIcon removeFromSuperview];
	[modifierImageView removeFromSuperview];
	[detailedTextLabel removeFromSuperview];
	[feedItemTitleLabel removeFromSuperview];
	[creatorImageView removeFromSuperview];
	[createdDateLabel removeFromSuperview];
	[sharingInfoLabel removeFromSuperview];
	[moreCommentsLabel removeFromSuperview];
    [conversationsViews removeFromSuperview];
	

	TT_RELEASE_SAFELY(detailedTextLabel);
	TT_RELEASE_SAFELY(createdDateLabel);
	TT_RELEASE_SAFELY(sharingInfoLabel);
	TT_RELEASE_SAFELY(feedItemTitleLabel);
	TT_RELEASE_SAFELY(modifierImageView);
	TT_RELEASE_SAFELY(creatorImageView);
    TT_RELEASE_SAFELY(modifierImageView);
	TT_RELEASE_SAFELY(moreCommentsLabel);
    TT_RELEASE_SAFELY(conversationsViews);
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FeedItemCell initilization

- (id)object {
	return _item;  
}

- (void)setObject:(id)object {
	if (_item != object ) {
		[super setObject:object];
		
		if (object == nil) {
			return;
		}
        
        //////////////  allocation of labels and adding in cell ////////////////////
        createdDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        createdDateLabel.textColor = [UIColor grayColor];
        createdDateLabel.font= [UIFont systemFontOfSize:13];
        
        feedTypeIcon = [[TTImageView alloc] initWithFrame:CGRectZero];
        feedTypeIcon.backgroundColor = [UIColor whiteColor];
        
        creatorImageView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectZero];
        creatorImageView.hidden = NO;
        
        detailedTextLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
        feedItemTitleLabel = [[TTStyledTextLinkLabel alloc] initWithFrame:CGRectZero];
        sharingInfoLabel = [[TTStyledTextLinkLabel alloc] initWithFrame:CGRectZero];
		
		[self.contentView addSubview:createdDateLabel];
		[self.contentView addSubview:feedTypeIcon];
		[self.contentView addSubview:creatorImageView];
        [self.contentView addSubview:feedItemTitleLabel];
		[self.contentView addSubview:sharingInfoLabel];
		[self.contentView addSubview:detailedTextLabel];

        /////////////////////////////////////////////////////////
        
        //////////////////////FeedItemCell initilization ////////
        FeedItem *feedItem = object;
        
        sharingInfoLabel.text = [TTStyledText textFromXHTML:feedItem.sharingInfo lineBreaks:YES URLs:NO];

        NSString *url = [ScrybeUserImage getScrybeUserImageUrl:feedItem.createdBy imageSize:@"48x48"];
      
        [creatorImageView setImage:url forState:UIControlStateNormal];

        sharingInfoLabel.text = [TTStyledText textFromXHTML:feedItem.sharingInfo lineBreaks:YES URLs:NO];
        // set sharing info
		sharingInfoLabel.frame = CGRectMake(CONTENTS_STARTING_X,VERTICAL_DIFERENCE_LABEL,CELL_CONTENT_WIDTH, 300.0f);
		
		[sharingInfoLabel sizeToFit];
        
       // float sharingInfoLabelHeight = sharingInfoLabel.frame.size.height;

        float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        feedTypeIcon.frame	= CGRectMake(CONTENTS_STARTING_X, y, APPLICATION_ICON_WIDTH,APPLICATION_ICON_HEIGHT);

        // set title
		feedItemTitleLabel.frame = CGRectMake(CONTENTS_STARTING_X+APPLICATION_ICON_WIDTH+5,y,CELL_CONTENT_WIDTH-APPLICATION_ICON_WIDTH-5, 300.0f);
        
        //////////////////////////////////
        //set date
 
        createdDateLabel.text = [[DateManager sharedDateManager] getReletiveDate:feedItem.createdDate];
		createdDateLabel.frame = CGRectMake(CONTENTS_STARTING_X+CELL_CONTENT_WIDTH+10, sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL, DATE_LABEL_WIDTH, 25);
 
        //createdDateLabel.backgroundColor = [UIColor grayColor];
        
        //////////////////////////////////
        
        
        if(![feedItem.createdBy isEqualToString:feedItem.lastModifiedBy])
		{
			modifierImageView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectZero];
            url = [ScrybeUserImage getScrybeUserImageUrl:feedItem.lastModifiedBy imageSize:@"32x32"];

			[modifierImageView setImage:url forState:UIControlStateNormal];
			modifierImageView.hidden = NO;
            [self.contentView addSubview:modifierImageView];
		}

        /////////////////////////////////////////////////////////
    }
}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark FeedItemCell layoutSubviews

-(void)layoutSubviews
{
	[super layoutSubviews];
    
	creatorImageView.frame  = CGRectMake(10.0, VERTICAL_DIFERENCE_LABEL, USER_ICON_WIDTH, USER_ICON_HEIGHT);
    modifierImageView.frame = CGRectMake(15+USER_ICON_WIDTH/2, 10+USER_ICON_HEIGHT/2, MODIFIER_USER_ICON_WIDTH, MODIFIER_USER_ICON_HEIGHT);
    
}
///////////////////////////////////////////////////////////////////////////
-(UIView *)layoutConversations:(NSMutableArray*) conversations delegate:(id) delegate yOffset:(float)y
{
    float startY = 0.0;
    
	conversationsViews = [[UIView alloc] init];
	
	int conversationsCount = [conversations count];
	
	int i = 0;
	
	if (conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
		
		i = conversationsCount-MAX_CONVERSATIONS_DISPLAY;
	}
    
    Conversation *conversation = nil;
    CGRect conversationsViewFrame = CGRectZero;
    
    
	for ( ; i < conversationsCount; i++) {
		
		conversation = [conversations objectAtIndex:i];
		
        ConversationView *conversationView = [[ConversationView alloc] initWithFrame:CGRectZero withConversationData:conversation withMaximumCellWidth:CONVERSATIONS_CELL_CONTENT_WIDTH];
        
        // conversationView.backgroundColor = [UIColor greenColor];
        
		conversationView.cellDelegate = delegate;
		conversationsViewFrame = conversationView.frame;
        
		conversationsViewFrame.origin.y = startY;
        
        conversationView.frame = conversationsViewFrame;
		
		[conversationsViews addSubview:conversationView];
		[conversationView release];
		
		startY+=conversationsViewFrame.size.height;
        
        startY+=(conversationsCount > 1 ? 2*VERTICAL_DIFERENCE_LABEL:0);
        
	}

    [conversationsViews setFrame:CGRectMake(CONTENTS_STARTING_X, y, CONVERSATIONS_CELL_CONTENT_WIDTH, conversationsViewFrame.size.height)];

	return conversationsViews;

}


///////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{

	TT_RELEASE_SAFELY(detailedTextLabel);
	TT_RELEASE_SAFELY(createdDateLabel);
	TT_RELEASE_SAFELY(sharingInfoLabel);
	TT_RELEASE_SAFELY(feedItemTitleLabel);
	TT_RELEASE_SAFELY(modifierImageView);
	TT_RELEASE_SAFELY(creatorImageView);
    TT_RELEASE_SAFELY(modifierImageView);
	TT_RELEASE_SAFELY(moreCommentsLabel);
    TT_RELEASE_SAFELY(conversationsViews);

    [super dealloc];
}

@end
