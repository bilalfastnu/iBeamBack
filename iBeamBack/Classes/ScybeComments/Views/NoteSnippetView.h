//
//  NoteSnippetView.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoteSnippetView : UIImageView {
    
    UILabel *label;
    id conversationDelegate;
}

@property (nonatomic, assign) id conversationDelegate;
@property (nonatomic, retain) UILabel *label;

@end
