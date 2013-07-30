//
//  CONSTANTS.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FEED_PAGE_SIZE					20

#define MAIN_HEADER_VIEW_HEIGHT			55.0f

#define RESOURCE_HEADER_VIEW_HEIGHT		70.0f


//////////// SPLITVIW CONSTANTS //////////////

#define FEED_MASTER_VIEW_WIDTH		250

#define NOTE_MASTER_VIEW_WIDTH		310

#define DEFALUT_MASTER_VIEW_WIDTH	320

////////////////////////////////////////////////


//////////// Open Application from Feed ////////

#define  OPEN_RESOURCE              0

#define  SHOW_ALL_COMMENTS          1

#define  POST_COMMENT               2

////////////////////////////////////////////////

//////////// Chat CONSTANTS //////////////

#define ACANI_RED [UIColor colorWithRed:230.0/255 green:30.0/255 blue:43.0/255 alpha:1]
#define CHAT_BACKGROUND_COLOR [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0]

#define CHAT_BAR_HEIGHT_1	44.0f
#define CHAT_BAR_HEIGHT_4	94.0f
#define VIEW_WIDTH	self.view.frame.size.width
#define VIEW_HEIGHT	self.view.frame.size.height

#define MESSAGE_FONT_SIZE 14.0f
#define INPUT_FONT_SIZE 17.0f

#define CONSTRAINED_WIDTH 300.0f
#define CONSTRAINED_HEIGHT 450.0f

#define MESSAGE_TAG 0
#define BALLOON_TAG 1
#define TEXT_TAG 2
#define USER_TAG 3
#define TIMESTAMP_TAG 4


#define RESET_CHAT_BAR_HEIGHT	SET_CHAT_BAR_HEIGHT(CHAT_BAR_HEIGHT_1)
#define EXPAND_CHAT_BAR_HEIGHT	SET_CHAT_BAR_HEIGHT(CHAT_BAR_HEIGHT_4)
#define	SET_CHAT_BAR_HEIGHT(HEIGHT)\
CGRect chatContentFrame = chatContent.frame;\
chatContentFrame.size.height = VIEW_HEIGHT - HEIGHT;\
[UIView beginAnimations:nil context:NULL];\
[UIView setAnimationDuration:0.1f];\
chatContent.frame = chatContentFrame;\
chatBar.frame = CGRectMake(chatBar.frame.origin.x, chatContentFrame.size.height, VIEW_WIDTH, HEIGHT);\
[UIView commitAnimations]

#define ENABLE_SEND_BUTTON	SET_SEND_BUTTON(YES, 1.0f)
#define DISABLE_SEND_BUTTON	SET_SEND_BUTTON(NO, 0.5f)
#define SET_SEND_BUTTON(ENABLED, ALPHA)\
sendButton.enabled = ENABLED;\
sendButton.titleLabel.alpha = ALPHA


////////////////////////////////////////////////