//
//  NSDate+OTS.m
//  OneStore
//
//  Created by huang jiming on 13-6-18.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "NSDate+Utility.h"
#import "NSString+safe.h"
#import "OTSGlobalValue.h"

@implementation NSDate(Utility)

+ (instancetype)dateWithDateString:(NSString*)dateString {
    return [[NSDate __otsDefaultDateFormatter] dateFromString:dateString];
}

+ (instancetype)dateWithTimeString:(NSString*)timeString {
    return [[NSDate __otsDefaultTimeFormatter] dateFromString:timeString];
}

+ (NSDateFormatter*)__otsDefaultDateFormatter {
    static NSDateFormatter *__dateFormatter = nil;
    if (!__dateFormatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy";
        formatter.timeZone = [NSTimeZone localTimeZone];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        __dateFormatter = formatter;
    }
    return __dateFormatter;
}

+ (NSDateFormatter*)__otsDefaultTimeFormatter {
    static NSDateFormatter *__timeFormatter = nil;
    if (!__timeFormatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy HH:mm:ss";
        formatter.timeZone = [NSTimeZone localTimeZone];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        
        __timeFormatter = formatter;
    }
    return __timeFormatter;
}

- (NSInteger )distanceNowDays {
	NSTimeInterval seconds = [self timeIntervalSinceNow];
	if (seconds < 0) {
		seconds = -seconds;
	}
	NSInteger daySeconds = 60 * 60 * 24;
	NSInteger days = (NSInteger)(seconds / daySeconds);
	return days;
}

- (NSDictionary *)distanceNowDic {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitDay|kCFCalendarUnitHour| kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:[NSDate date] toDate:self options:0];
    
    NSDictionary * dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@(comps.day),@"day",@(comps.hour),@"hour",@(comps.minute),@"minute",@(comps.second),@"second",nil];
    
	return dic;
}

- (NSDictionary *)distanceYearMonthDayFromNowDic {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitYear|kCFCalendarUnitMonth| kCFCalendarUnitDay fromDate:self toDate:[NSDate date] options:0];
    
    NSDictionary * dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:@(comps.year),@"year",@(comps.month),@"month",@(comps.day),@"day",nil];
    
	return dic;
}

/**
 *  功能:转换成日期字符串，精确到天
 */
- (NSString *)dateString {
    return [[NSDate __otsDefaultDateFormatter] stringFromDate:self];
}

/**
 *  功能:转换成时间字符串，精确到秒
 */
- (NSString *)timeString {
    return [[NSDate __otsDefaultTimeFormatter] stringFromDate:self];
}

/**
 *  是否是今天的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isTodayDate {
    NSDateFormatter* dateFormatter = [NSDate __otsDefaultDateFormatter];
    
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  是否昨天
 */
- (BOOL)isYesterday {
    NSDate *nowDate = [OTSGlobalValue sharedInstance].serverTime;
    
    NSDateFormatter *fmt = [NSDate __otsDefaultDateFormatter];
    
    NSString *selStr = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  是否是今年的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isCurrentYearDate {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [dateFormatter stringFromDate:self];
    
    if ([today isEqualToString:day])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  判断与当前时间差值
 */
- (NSDateComponents *)deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
@end
