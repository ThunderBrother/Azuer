//
//  OTSJsonKit.h
//  OneStoreFramework
//
//  Created by huang jiming on 14-8-7.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSJsonKit : NSObject

/**
 *  功能:将dictionary转成字符串
 */
+ (NSString *)stringFromDict:(NSDictionary *)aDict;

/**
 *  NSDictionary转字符串（格式化成较美观的json，含换行符等）
 *
 */
+ (NSString *)prettyStringFromDict:(NSDictionary *)aDict;

/**
 *  json对象转字符串
 *
 */
+ (NSString *)stringFromJSONObject:(id)aObj options:(NSJSONWritingOptions)option;

/**
 *  功能:将字符串转成dictionary
 */
+ (NSDictionary *)dictFromString:(NSString *)aString;

/**
 *  功能:将字符串转成array
 */
+ (NSArray *)arrayFromString:(NSString *)aString;

/**
 *  功能:将字符串转成vo
 */
+ (id)voFromString:(NSString *)aString;

@end
