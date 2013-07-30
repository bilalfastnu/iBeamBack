//
//  SnippetFactory.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SnippetData.h"

#import "NoteSnippetView.h"

@interface SnippetFactory : NSObject {
    
}

-(NoteSnippetView*) getNoteSnippetForData:(NSMutableDictionary *)data;

-(UIImage*) getImageSnippetForData:(NSMutableDictionary *)data;


@end
