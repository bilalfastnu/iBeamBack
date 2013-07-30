//
//  ScrybeResourceImage.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

typedef enum {
    ScryePhotoVersionNone,
    ScryePhotoVersionLarge,
    ScryePhotoVersionMedium,
    ScryePhotoVersionSmall,
    ScryePhotoVersionThumbnail
} ScryePhotoVersion;

@interface ScrybeResourceImage : NSObject {
    
}

+(NSString*) getScrybeImageForURLVersion:(ScryePhotoVersion)version applicationName:(NSString*) applicationName withResourceId:(NSString*) resourceId withResourceUrl:(NSString *) url;

@end