//
//  NoteApplicationState.h
//  MySplitViewControllerDemo0
//
//  Created by Bilal Nazir on 3/7/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteAppStateEnum.h"

@interface NoteApplicationState : NSObject {

	NoteAppState noteAppState;
}

//@property (nonatomic, readwrite) NoteAppState noteApplicationState;

-(NoteAppState)getNoteAppState;
-(void)setNoteAppState:(NoteAppState)state;

+ (NoteApplicationState*)sharedNoteApplicationState;
@end
