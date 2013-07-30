//
//  WebLinkCustomProperties.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/15/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebLinkCustomProperties : NSObject {
    
	NSString *icon;
	NSString *source;
	NSString *thumbnailURL;
	
}
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *thumbnailUrl;

//Actions
-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject;
@end
