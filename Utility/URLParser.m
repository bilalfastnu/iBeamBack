//
//  URLParser.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/12/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "URLParser.h"


@interface URLParser(Private)

- (NSDictionary *)parseQueryString:(NSString *)query;

@end

@implementation URLParser

- (id)initWithURLString:(NSString *)url
{
    self = [super init];
    if (self) {
        
        infoDictionary = [self parseQueryString:url];
    }
    return self;
}

- (NSString *)valueForVariable:(NSString *)varName
{
    return [infoDictionary objectForKey:varName];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:6] autorelease];
    NSArray *pairs = [query componentsSeparatedByString:@"?"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

-(void) dealloc
{
    [super dealloc];
}
@end
