//
//  SnippetData.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SnippetData : NSObject {
    
    NSString *type;
    NSMutableDictionary *data;
}

@property (nonatomic, retain)  NSString *type;
@property (nonatomic, retain) NSMutableDictionary *data;

-(id) initWithType:(NSString *) p_type data:(NSMutableDictionary*)p_data;
-(NSMutableDictionary*) getValueObjectForServer;
@end
