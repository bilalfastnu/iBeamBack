//
//  DateManager.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSSingleton.h"

@interface DateManager : NSSingleton {
    
    NSString *date;
    double timestamp;
    NSInteger miliseconds;
    double baseTimeStamp;
    double initializationTimeStamp;
}

@property (nonatomic, retain) NSString *date;
@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) NSInteger miliseconds;

-(double) getNowTimeStamp;
-(NSString*) getNowDate;
-(NSDate *) localTimeZoneDateFrom:(NSString*)dateString;
-(int) getHowManyDaysHavePased:(NSString*)lastDateString;
-(NSString *) getReletiveDate:(NSString *)dateString;

-(void) setTime:(NSDictionary*) time withBaseTimeStamp:(double)p_baseTimeStamp withInitializationTimeStamp:(double) p_initializationTimeStamp;

+(DateManager *)sharedDateManager;

@end
