//
//  CommentView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ConversationView.h"

#import "CELL.h"
#import "ICONS.h"
#import "CONSTANTS.h"
#import "UserManager.h"
#import "SnippetFactory.h"
#import "Conversation.h"
#import "ScrybeImageThumbView.h"
#import "DateManager.h"
#import "ScrybeUserImage.h"
#import "ScrybeStyleSheet.h"
#import "ScrybeImageThumbView.h"
#import "extThree20JSON/JSON.h"
#import "TTStyledTextLinkLabel.h"

@implementation ConversationView

@synthesize cellDelegate;
@synthesize conversation;
///////////////////////////////////////////////////////////////////////////

-(void) layoutConversation:(Conversation*) p_conversation withCellWidth:(float)cellWidth
{
    NSString *url = [ScrybeUserImage getScrybeUserImageUrl:p_conversation.initiatedBy imageSize:@"28x28"];
    
    [userImage setImage:url forState:UIControlStateNormal];
    
    CGSize constraint = CGSizeMake(cellWidth-(CONVERSATIONS_USER_ICON_WIDTH+10), CELL_CONTENT_MAX_HEIGHT);
	CGSize size= CGSizeZero;

    ResourceLink *resourceLink = p_conversation.resourceLink;
   
    NSInteger parentResourceIndex =  resourceLink.collaborationInfo.parentResourceIndex;
    NSInteger hierarcyCount = [resourceLink.resourcePath.hierarchy count];
    
    if (parentResourceIndex != -1 &&(parentResourceIndex+1) < hierarcyCount)
    {
        Resource *resource =[p_conversation.resourceLink.resourcePath.hierarchy objectAtIndex:hierarcyCount-1];
        NSString *subResourceText = [NSString stringWithFormat:@"<img src=\"bundle://%@\" width=\"18\" height=\"18\"/>",SubResourceIcon];
        
		subResourceText = [subResourceText stringByAppendingFormat:@"  <a href=\"%@?%d\">%@</a>",@"tt://subResource",p_conversation.feedId,resource.title];
        
        subResourceTitleLabel = [[TTStyledTextLinkLabel alloc] init];
		subResourceTitleLabel.font = [UIFont systemFontOfSize:CONVERSATION_FONT_SIZE];
		
        size = [resource.title sizeWithFont:subResourceTitleLabel.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

        subResourceTitleLabel.frame = CGRectMake(CONVERSATIONS_USER_ICON_WIDTH+10, 0, cellWidth-(CONVERSATIONS_USER_ICON_WIDTH+10), size.height);
        
		subResourceTitleLabel.text = [TTStyledText textFromXHTML:subResourceText lineBreaks:UILineBreakModeWordWrap URLs:YES];
		[subResourceTitleLabel sizeToFit];
		[self addSubview:subResourceTitleLabel];
    }

    float y = (subResourceTitleLabel == nil ? 0: subResourceTitleLabel.frame.size.height);

    NSString *creationInfo = [[[UserManager sharedUserManager] getFullName:p_conversation.initiatedBy] stringByAppendingString:@", "];
    
    if ([p_conversation.updatedBy length]) {
        creationInfo = [creationInfo stringByAppendingString:@"Updated "];
    }
    
    creationInfo = [creationInfo stringByAppendingString:[[DateManager sharedDateManager] getReletiveDate:p_conversation.postDate]];
    
    NSString *commentText = [p_conversation.comments stringByRemovingHTMLTags];

    size = [[commentText stringByAppendingString:creationInfo] sizeWithFont:[UIFont systemFontOfSize:CONVERSATION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    [TTStyleSheet setGlobalStyleSheet:[[[ScrybeStyleSheet alloc] init] autorelease]];
    commentText = [NSString stringWithFormat:@"%@ <span class=\"grayText\">%@</span>",commentText,creationInfo];
	
	commentTextLabel.text = [TTStyledText textFromXHTML:commentText lineBreaks:UILineBreakModeWordWrap URLs:YES];
	commentTextLabel.frame = CGRectMake(CONVERSATIONS_USER_ICON_WIDTH+10, y, cellWidth-(CONVERSATIONS_USER_ICON_WIDTH+10),size.height);
	
    [commentTextLabel sizeToFit];

    y+=size.height;
    
    /////////////////// Show Snippets Data /////////////////////////////

    SnippetData *snippetData = p_conversation.resourceLink.collaborationInfo.snippetData;
    
    if (snippetData.data != (NSMutableDictionary*) [NSNull null])
    {
        SnippetFactory *snippetFactory = [[SnippetFactory alloc] init];
        y+=VERTICAL_DIFERENCE_LABEL;
        
        if ([snippetData.type isEqualToString:NOTE_SNIPPET])
        {
            NoteSnippetView *snippetView = [snippetFactory getNoteSnippetForData:snippetData.data];
            
            snippetView.conversationDelegate = self;
            
            snippetView.frame = CGRectMake(CONVERSATIONS_USER_ICON_WIDTH+10,y,snippetView.frame.size.width,snippetView.frame.size.height);
            
            y+= snippetView.frame.size.height;
            
            [self  addSubview:snippetView];
            [snippetView release];
         }
       else if ([snippetData.type isEqualToString:IMAGE_SNIPPET]) 
        {
            UIImage *snippetImage = [snippetFactory getImageSnippetForData:snippetData.data];
            
            ScrybeImageThumbView *snippetView = [[ScrybeImageThumbView alloc] initWithFrame:CGRectZero];
            snippetView.hidden = NO;
            
            [snippetView setThumbViewImage:snippetImage];
            
            [snippetView addTarget:self action:@selector(snippetViewTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            int height = [[snippetData.data objectForKey:@"height"]intValue];
            int width = [[snippetData.data objectForKey:@"width"]intValue];
            
            snippetView.frame=CGRectMake(CONVERSATIONS_USER_ICON_WIDTH+10,y,width,height);
            
            [self  addSubview:snippetView];
            [snippetView release];
            
            y+=height;
        }

        [snippetFactory release];
    }
    self.frame = CGRectMake(0.0, 0.0, cellWidth, y);//y is height of conversation view
}

///////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame withConversationData:(Conversation*)p_conversation withMaximumCellWidth:(float)cellWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        subResourceTitleLabel = nil;
		
		userImage = [[ScrybeImageThumbView alloc] init];
		commentTextLabel = [[TTStyledTextLabel alloc] init];
		
		commentTextLabel.font = [UIFont systemFontOfSize:CONVERSATION_FONT_SIZE];
		userImage.hidden = NO;
        [self addSubview:userImage];
		[self addSubview:commentTextLabel];
		
		[self layoutConversation:p_conversation withCellWidth:cellWidth];

        conversation = [p_conversation retain];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////
-(void) layoutSubviews
{
	[super layoutSubviews];
	
	userImage.frame = CGRectMake(0.0, 0.0, CONVERSATIONS_USER_ICON_WIDTH, CONVERSATIONS_USER_ICON_HEIGHT);
}
///////////////////////////////////////////////////////////////////////////

-(void) snippetViewTapped:(id) sender
{
    if ([cellDelegate respondsToSelector:@selector(snippetViewTapped:)]) {
        
        [cellDelegate performSelector:@selector(snippetViewTapped:) withObject:conversation];
    } 
}

///////////////////////////////////////////////////////////////////////////

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [conversation release];
    
    [super dealloc];
}

@end
