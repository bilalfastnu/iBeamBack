//
//  SearchWebView.h
//  iPadHelloWorld
//
//  Created by Bilal Nazir on 3/3/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

@interface UIWebView (ScrybeWebView)

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;

@end