//
//  CommentView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Three20/Three20.h>

@class Conversation;
@class ScrybeImageThumbView;
@class TTStyledTextLinkLabel;

@interface ConversationView : UIView {

    id cellDelegate;
    Conversation *conversation;
    ScrybeImageThumbView *userImage;
	TTStyledTextLabel *commentTextLabel;
	TTStyledTextLinkLabel *subResourceTitleLabel;
}

@property (nonatomic, assign) id cellDelegate;
@property (nonatomic, retain) Conversation *conversation;

- (id)initWithFrame:(CGRect)frame withConversationData:(Conversation*)conversation withMaximumCellWidth:(float)cellWidth;


@end
