//
//  NoteRemoteCaller.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RemoteCaller.h"

@interface NoteRemoteCaller : RemoteCaller {
    
}

-(void) getNoteDetails:(NSString *)noteId;

@end
