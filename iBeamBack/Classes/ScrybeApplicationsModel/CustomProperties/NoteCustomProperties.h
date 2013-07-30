//
//  NoteCustomProperties.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NoteCustomProperties : NSObject {

    NSString * file_Id;
    NSString * item_Id;
    NSString * Id;
    NSInteger  size;
    NSString * name;
	NSInteger  width;
    NSString * type;
	NSInteger  height;
    NSString * setName;
	NSString * previewName;
	NSString * originalName;
	NSString * thumbnailName;
}

@property (nonatomic, retain) NSString * file_Id;
@property (nonatomic, retain) NSString * item_Id;

@property (nonatomic, retain) NSString * Id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) NSInteger  size;
@property (nonatomic, assign) NSInteger  width;
@property (nonatomic, assign) NSInteger  height;
@property (nonatomic, retain) NSString * setName;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * previewName;
@property (nonatomic, retain) NSString * originalName;
@property (nonatomic, retain) NSString * thumbnailName;

//Action
-(id)initWithCustomProperty:(NSDictionary*)dictionaryObject;

@end
