//
//  NoteApplicationState.m
//  MySplitViewControllerDemo0
//
//  Created by Bilal Nazir on 3/7/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteApplicationState.h"
#import "SynthesizeSingleton.h"

@implementation NoteApplicationState

SYNTHESIZE_SINGLETON_FOR_CLASS(NoteApplicationState);

//@synthesize noteApplicationState;

-(NoteAppState)getNoteAppState
{
	return noteAppState;
}
/**/
-(void)setNoteAppState:(NoteAppState)state
{
    switch (state) {
        case NOTE_VIEW:
            NSLog(@"I'm now in Note view State");
            noteAppState = NOTE_VIEW;
            break;
            
        case IMAGE_DETAIL_VIEW:
             NSLog(@"I'm now in Image Detail view State");
             noteAppState = IMAGE_DETAIL_VIEW;
            break;
            
        case THUMB_VIEW:
             NSLog(@"I'm now in Thumb view State");
             noteAppState = THUMB_VIEW;
            break;
            
        default:
             NSLog(@"I'm now in Unknown view State");
             //noteAppState = NONE;
            break;
    }
}
@end
