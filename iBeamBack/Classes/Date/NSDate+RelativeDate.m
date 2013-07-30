//
//  NSDate+RelativeDate.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/16/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NSDate+RelativeDate.h"


#define SECOND     1
#define MINUTE (  60 * SECOND )
#define HOUR   (  60 * MINUTE )
#define DAY    (  24 * HOUR   )
#define WEEK   (   7 * DAY    )
#define MONTH  (  30 * DAY    )
#define YEAR   ( 365 * DAY    )

@implementation NSDate (RelativeDate)

/////////////////////////////////////////////////////////////////////////////////////////
-(NSDate*)dateFromUnixTimeStamp:(double)unixdate 
{
    NSTimeInterval unixDate = unixdate / 1000.0;
    return [NSDate dateWithTimeIntervalSince1970:unixDate];
}
/////////////////////////////////////////////////////////////////////////////////////////
/*- (NSString *)formateDate:(NSDate *)sourceDate withTodayDate:(NSDate *)todayDate
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	
	int numDays = [self howManyDaysHavePast:sourceDate today:todayDate];
	(numDays < 30 ? [dateFormatter setDateFormat:@"EEE, MMM dd"] :[dateFormatter setDateFormat:@"MMM dd, yyyy"]);
    
	//[dateFormatter setDateFormat:@"MMM dd, yyyy"];
	
	NSString *dateString = [dateFormatter stringFromDate:sourceDate];
	
	[dateFormatter release];
	return dateString;
}*/

- (NSString *)formateDate:(NSDate *)sourceDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;

    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];

    [dateFormatter setDateFormat:@"h:mm a, MMM dd"];
   
    NSString *dateString = [dateFormatter stringFromDate:sourceDate];
	
	[dateFormatter release];
	return dateString;
}
/////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getLastWeekendDate:(NSDate*)sourceDate withTodayDate:(NSDate *)todayDate
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
	int numDays = [self howManyDaysHavePast:sourceDate today:todayDate];
	if(numDays < 5)
	{
		[dateFormatter setDateFormat:@"EEEE"];
	}
	else{
		[dateFormatter setDateFormat:@"EEE, MMM dd"];
	}	
	
	NSString *date = [dateFormatter stringFromDate:sourceDate];  
	
	[dateFormatter release];
	
	return date;
}
/////////////////////////////////////////////////////////////////////////////////////////
-(int)howManyDaysHavePast:(NSDate*)lastDate today:(NSDate*)today {
	NSDate *startDate = lastDate;
	NSDate *endDate = today;
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	
	[gregorian release];
	int days = [components day];
	return days;
}
/////////////////////////////////////////////////////////////////////////////////////////
- (NSString *) relativeDateSinceNow:(NSString *) dateString withTodayDate:(NSDate*)todayDate
{
	//////////////// convert now date to GMT Time zone
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	

	//NSString *nowDateString = [dateFormatter stringFromDate:todayDate];
	
    NSDate *nowDate = todayDate;
	//NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	
	//NSDate *nowDate = [dateFormatter dateFromString:nowDateString];
	//nowDate = [nowDate dateByAddingTimeInterval:timeZoneOffset];
	
	/////////////////////////////////
	NSDate *sourceDate = [dateFormatter dateFromString:dateString];
	[dateFormatter release];
	
	int delta = [nowDate timeIntervalSinceDate:sourceDate];
	
	if (delta < 0) {
		return [self formateDate:sourceDate]; 
         //return [NSString stringWithFormat:@"%u minutes ago", delta / MINUTE];
    } else if (delta <= 30 * SECOND) {
        return NSLocalizedString(@"just now", nil);
    } else if (delta < 1 * MINUTE) {
        return [NSString stringWithFormat:@"%u seconds ago", delta];
    } else if (delta < 2 * MINUTE) {
        return @"1 minutes ago";
    } else if (delta <= 45 * MINUTE) {
        return [NSString stringWithFormat:@"%u minutes ago", delta / MINUTE];
    } else if (delta <= 90 * MINUTE) {
        return @"1 hour ago";
    } else if (delta < 3 * HOUR) {
        return @"2 hours ago";
    } else if (delta < 23 * HOUR) {
        return [NSString stringWithFormat:@"%u hours ago", delta / HOUR];
    } else if (delta < 36 * HOUR) {
		return [self formateDate:sourceDate];       
    }else
    {
        return [self formateDate:sourceDate];
    }
}

/////////////////////////////////////////////////////////////////////////////////////////
/*- (NSString *) relativeDateSinceNow:(NSString *) dateString {
	
	//////////////// convert now date to GMT Time zone
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	[dateFormatter setTimeZone:gmt];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
	
	NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
	
	NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
	
	NSDate *nowDate = [dateFormatter dateFromString:nowDateString];
	nowDate = [nowDate dateByAddingTimeInterval:timeZoneOffset];
	
	/////////////////////////////////
	NSDate *sourceDate = [dateFormatter dateFromString:dateString];
	[dateFormatter release];
	
	int delta = [nowDate timeIntervalSinceDate:sourceDate];
	
	if (delta < 0) {
		return [self getLastWeekendDate:sourceDate withTodayDate:nowDate];
    } else if (delta <= 30 * SECOND) {
        return NSLocalizedString(@"just now", nil);
    } else if (delta < 1 * MINUTE) {
        return [NSString stringWithFormat:@"%u seconds ago", delta];
    } else if (delta < 2 * MINUTE) {
        return @"1 minutes ago";
    } else if (delta <= 45 * MINUTE) {
        return [NSString stringWithFormat:@"%u minutes ago", delta / MINUTE];
    } else if (delta <= 90 * MINUTE) {
        return @"1 hour ago";
    } else if (delta < 3 * HOUR) {
        return @"2 hours ago";
    } else if (delta < 23 * HOUR) {
        return [NSString stringWithFormat:@"%u hours ago", delta / HOUR];
    } else if (delta < 36 * HOUR) {
		return @"Yesterday";
		// return @"1 day ago";
    } else if (delta < 72 * HOUR) {
        return [self formateDate:sourceDate withTodayDate:nowDate]; 
		//return [self getLastWeekendDate:sourceDate withTodayDate:nowDate];
        // return @"2 days ago";
    } else if (delta < 7 * DAY) {
		return [self formateDate:sourceDate withTodayDate:nowDate]; 
        
        //return [self getLastWeekendDate:sourceDate withTodayDate:nowDate];
		//return [self formateDate:sourceDate];
        //return [NSString stringWithFormat:@"%u days ago", delta / DAY];
    } else if (delta < 11 * DAY) {
		return [self formateDate:sourceDate withTodayDate:nowDate];
    } else if (delta < 14 * DAY) {
		return [self formateDate:sourceDate withTodayDate:nowDate]; 
	} else if (delta < 9 * WEEK) {
		return [self formateDate:sourceDate withTodayDate:nowDate];
		// return [NSString stringWithFormat:@"%u weeks", delta / WEEK];
    } else if (delta < 19 * MONTH) {
		return [self formateDate:sourceDate withTodayDate:nowDate];
        //return [NSString stringWithFormat:@"%u months", delta / MONTH];        
    } else if (delta < 2 * YEAR) {
		return [self getLastWeekendDate:sourceDate withTodayDate:nowDate];
		//return [self formateDate:sourceDate];
		// return @"1 year";
    } else {
		return [self getLastWeekendDate:sourceDate withTodayDate:nowDate];
		//return [self formateDate:sourceDate];
        //return [NSString stringWithFormat:@"%u years", delta / YEAR];        
    }
}*/
/////////////////////////////////////////////////////////////////////////////////////////
@end