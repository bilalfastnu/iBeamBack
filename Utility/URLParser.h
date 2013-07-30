//
//  URLParser.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLParser : NSObject {
    
    NSDictionary *infoDictionary;
}
- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;


@end
