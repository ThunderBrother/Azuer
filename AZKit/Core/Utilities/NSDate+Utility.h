//
//  NSDate+OTS.h
//  OneStore
//
//  Created by huang jiming on 13-6-18.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Utility)

+ (instancetype)dateWithDateString:(NSString*)dateString;

+ (instancetype)dateWithTimeString:(NSString*)timeString;

/**
 *	功能:获取距离现在的天数，小于一天为0
 *
 */
- (NSInteger )distanceNowDays;

/**
 *  功能:日期距离当前时间的描述，改描述为:_天_时_分_秒
 *
 *  @return map
 */
- (NSDictionary *)distanceNowDic;

/**
 *  功能:年月日从现在
 *
 *  @return map
 */
- (NSDictionary *)distanceYearMonthDayFromNowDic;

/**
 *  功能:转换成日期字符串，精确到天
 */
- (NSString *)dateString;

/**
 *  功能:转换成时间字符串，精确到秒
 */
- (NSString *)timeString;

/**
 *  是否是今天的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isTodayDate;

/**
 *  是否昨天
 */
- (BOOL)isYesterday;

/**
 *  是否是今年的日期
 *
 *  @return 返回YES OR NO
 */
- (BOOL)isCurrentYearDate;

/**
 *  判断与当前时间差值
 */
- (NSDateComponents *)deltaWithNow;

@end
