//
//  ScrybeStyleSheet.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/15/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ScrybeStyleSheet.h"


@implementation ScrybeStyleSheet

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) init
{
    self = [super init];
	if (self) {
		
		
	}
	return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (TTStyle*)grayText {
	return [TTTextStyle styleWithColor:[UIColor grayColor] next:nil];
}
- (TTStyle*)blueText {
	return [TTTextStyle styleWithColor:[UIColor blueColor] next:nil];
}
- (TTStyle*)largeText {
	return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
}
- (TTStyle*)smallText {
	return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] next:nil];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

@end
