//
//  NSNumber+Format.h
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber(Format)

/**
 *	功能:NSNumber类型转换成显示金钱数据的字符串(保留两位有效数字，如果最后一位有效数字为0,则不显示)
 *
 */
- (NSString *)moneyFormatString;

/**
 *	功能:double类型数据转换成显示金钱数据的字符串(保留两位有效数字，如果最后一位有效数字为0,则不显示)
 *
 */
+ (NSString *)moneyFormat:(double)aValue;

/**
 *  功能:重量字符串，单位kg
 */
+ (NSString *)weightFormat:(double)aValue;

/**
 *  功能:价格积分(eg:¥99.9 + 10 积分) 或 (eg:¥99.9\n10 积分)
 */
+ (NSAttributedString *)attStringWithPrice:(CGFloat)aPrice
                                     point:(NSInteger)aPoint
                                  joinChar:(NSString *)aChar
                           priceAttributes:(NSDictionary *)aAttributes
                           pointAttributes:(NSDictionary *)bAttributes
                            charAttributes:(NSDictionary *)cAttributes;

@end
