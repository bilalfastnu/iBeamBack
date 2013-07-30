//
//  FeedItemCell.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "CELL.h"
#import "ICONS.h"
#import "FeedItem.h"
#import "Conversation.h"
#import "ConversationView.h"
#import "CONSTANTS.h"
#import "NAVIGATOR.h"
#import "UserManager.h"
#import "ScrybeImageThumbView.h"
#import "TTStyledTextLinkLabel.h"


@interface FeedItemCell : TTTableLinkedItemCell {
    UILabel *createdDateLabel;
	
	TTImageView *feedTypeIcon;
	ScrybeImageThumbView *creatorImageView;
	ScrybeImageThumbView *modifierImageView;
	
	TTStyledTextLinkLabel *feedItemTitleLabel;
	TTStyledTextLinkLabel *sharingInfoLabel;
    
	TTStyledTextLabel *detailedTextLabel;
	TTStyledTextLinkLabel *moreCommentsLabel;
    
    UIView *conversationsViews;
}
@property (nonatomic, retain) UIView *conversationsViews;
@property (nonatomic, retain) TTImageView *feedTypeIcon;

@property (nonatomic, retain) TTStyledTextLabel * detailedTextLabel;
@property (nonatomic, retain) TTStyledTextLabel * moreCommentsLabel;
@property (nonatomic, retain) TTStyledTextLinkLabel * feedItemTitleLabel;
@property (nonatomic, retain) TTStyledTextLinkLabel * sharingInfoLabel;

//-(ConversationView *)layoutConversations:(NSMutableArray*) conversations yOffset:(float)y;
-(UIView *)layoutConversations:(NSMutableArray*) conversations delegate:(id) delegate yOffset:(float)y;
@end
