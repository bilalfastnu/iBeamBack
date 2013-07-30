//
//  NSSingleton.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSSingleton : NSObject {
    
}
+(void)cleanup;
// Deux cas:
// . [NSSingleton cleanup]  : Free all singletons.
// . [MySingleton cleanup] : Free MySingleton.

+(id)sharedInstance;
// Notes :
// . +(id)sharedInstance can be overridden to return the right type..
//   ex : (MySingleton *)sharedInstance { return [super sharedInstance]; }
// . Singleton initialization must be done as usual in -(id)init.
//
@end
