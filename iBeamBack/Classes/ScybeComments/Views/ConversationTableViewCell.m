//
//  ConversationTableViewCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/15/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ConversationTableViewCell.h"


@implementation ConversationTableViewCell

@synthesize conversationView;
@synthesize moreCommentsLabel;
///////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        conversationView = nil;
        moreCommentsLabel = nil;
    }
    return self;
}

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
