//
//  DateManager.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "DateManager.h"

#import "NSDate+RelativeDate.h"

@implementation DateManager

@synthesize miliseconds, date, timestamp;

/////////////////////////////////////////////////////////////////////////////////////////
-(void) setTime:(NSDictionary*) time withBaseTimeStamp:(double)p_baseTimeStamp withInitializationTimeStamp:(double) p_initializationTimeStamp
{
    date = [[time objectForKey:@"date"] retain];
    timestamp = [[time objectForKey:@"timestamp"] doubleValue];
    miliseconds = [[time objectForKey:@"miliseconds"] intValue];
    
    baseTimeStamp = p_baseTimeStamp/2+(timestamp);//round trip time or base time

    initializationTimeStamp = p_initializationTimeStamp;//current time stamp when PHP server data reached
}
/////////////////////////////////////////////////////////////////////////////////////////
+(DateManager *)sharedDateManager
{
	return (DateManager *)[super sharedInstance];
}

/////////////////////////////////////////////////////////////////////////////////////////
-(NSString *) convertDateToLocalTimeZoneDate:(NSString *)dateString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	
	NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	
	NSDate *myDate = [dateFormatter dateFromString:dateString];
	myDate = [myDate dateByAddingTimeInterval:timeZoneOffset];
	
	NSString *localDate = [dateFormatter stringFromDate:myDate];
	
	[dateFormatter release];
	
	return localDate;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(NSDate *) localTimeZoneDateFrom:(NSString*)dateString
{
	NSString* localDateString = [self convertDateToLocalTimeZoneDate:dateString];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
    
	NSDate *localDate = [dateFormatter dateFromString:localDateString];
	
	[dateFormatter release];
	
	return localDate;
	
}
/////////////////////////////////////////////////////////////////////////////////////////
-(double) getNowTimeStamp
{
    double endTimeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    double nowTimeStamp = endTimeStamp-initializationTimeStamp;
    nowTimeStamp+=baseTimeStamp;
    
    return nowTimeStamp;
}
/////////////////////////////////////////////////////////////////////////////////////////
-(NSString *) getNowDate
{
    double endTimeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    double todayTimeStamp = endTimeStamp-initializationTimeStamp;
    todayTimeStamp+=baseTimeStamp;
    
    NSDate *todayDate = [[NSDate date] dateFromUnixTimeStamp:todayTimeStamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
    
	NSString *nowDate = [dateFormatter stringFromDate:todayDate];
    
   /// NSString *testTime = [self convertDateToLocalTimeZoneDate:nowDate];
   // NSDate *testTime2 = [self localTimeZoneDateFrom:nowDate];
    return nowDate;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(NSString *) getReletiveDate:(NSString*)dateString
{

   // NSDate *datestes = [self localTimeZoneDateFrom:[self getNowDate]];
	NSString * reletiveDate = [[NSDate date] 
           relativeDateSinceNow:[self convertDateToLocalTimeZoneDate:dateString] withTodayDate:[self localTimeZoneDateFrom:[self getNowDate]]];
	
	return reletiveDate;
}

/////////////////////////////////////////////////////////////////////////////////////////
-(int) getHowManyDaysHavePased:(NSString*)lastDateString
{
	NSString* localDateString = [self convertDateToLocalTimeZoneDate:lastDateString];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
    
	NSDate *lastDate = [dateFormatter dateFromString:localDateString];
    
	[dateFormatter release];
	
	int days = [[NSDate date] howManyDaysHavePast:lastDate today:[NSDate date]];
	
	return days;
    
}
/////////////////////////////////////////////////////////////////////////////////////////


-(void) dealloc
{
    [date release];
    
    [super dealloc];
}
@end

