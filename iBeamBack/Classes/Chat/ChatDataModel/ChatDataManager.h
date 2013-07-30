//
//  ChatDataManager.h
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


@interface ChatDataManager : NSObject {
    	NSMutableDictionary *chatDataManager;
}
@property(nonatomic,retain)NSMutableDictionary *chatDataManager;


-(id)init;
+ (ChatDataManager *)sharedChatDataManager;

@end
