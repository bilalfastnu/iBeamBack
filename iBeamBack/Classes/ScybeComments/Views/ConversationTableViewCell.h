//
//  ConversationTableViewCell.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/15/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConversationView.h"
#import "Conversation.h"

@interface ConversationTableViewCell : UITableViewCell {
    
    ConversationView *conversationView;
    UILabel *moreCommentsLabel;
}

@property (nonatomic, retain) ConversationView *conversationView;
@property (nonatomic, retain) UILabel *moreCommentsLabel;


@end
