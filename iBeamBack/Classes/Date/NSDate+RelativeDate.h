//
//  NSDate+RelativeDate.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (RelativeDate)

-(NSDate*)dateFromUnixTimeStamp:(double)unixdate;
- (NSString *) relativeDateSinceNow:(NSString *) dateString withTodayDate:(NSDate*)todayDate;
-(int)howManyDaysHavePast:(NSDate*)lastDate today:(NSDate*)today;

@end
