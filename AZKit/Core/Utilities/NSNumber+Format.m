//
//  NSNumber+Format.m
//  OneStoreFramework
//
//  Created by airspuer on 14-9-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSNumber+Format.h"
//category
#import "NSString+safe.h"
#import "NSString+Attributed.h"

@implementation NSNumber(Format)

- (NSString *)moneyFormatString {
    NSString *priceString = [NSString stringWithFormat:@"¥%.2f", self.floatValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
    }
    return priceString;
}

+ (NSString *)moneyFormat:(double)aValue {
    NSString *priceString = [NSString stringWithFormat:@"¥%.2f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
    }
    return priceString;
}

+ (NSString *)weightFormat:(double)aValue
{
    NSString *priceString = [NSString stringWithFormat:@"%.3f", aValue];
    NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
    if ([endChar isEqualToString:@"0"]) {
        priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
        NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
        if ([endChar isEqualToString:@"0"]) {
            priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
            NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
            if ([endChar isEqualToString:@"0"]) {
                priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
                NSString *endChar = [priceString safeSubstringWithRange:NSMakeRange(priceString.length-1, 1)];
                if ([endChar isEqualToString:@"."]) {
                    priceString = [priceString safeSubstringWithRange:NSMakeRange(0, priceString.length-1)];
                }
            }
        }
    }
    return priceString;
}

/**
 *  功能:价格积分(eg:¥99.9 + 10 积分) 或 (eg:¥99.9\n10 积分)
 */
+ (NSAttributedString *)attStringWithPrice:(CGFloat)aPrice
                                     point:(NSInteger)aPoint
                                  joinChar:(NSString *)aChar
                           priceAttributes:(NSDictionary *)aAttributes
                           pointAttributes:(NSDictionary *)bAttributes
                            charAttributes:(NSDictionary *)cAttributes
{
    if (aPoint <= 0) {
        NSString *compStr = [NSNumber moneyFormat:aPrice];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:compStr];
        [attributedString setAttributes:aAttributes range:NSMakeRange(0, compStr.length)];
        return attributedString;
    } else if (aPrice <= 0.0) {
        NSString *compStr = [NSString stringWithFormat:@"%zd 积分", aPoint];
        return [compStr attributedStringWithHeadAttributes:bAttributes tailAttributes:cAttributes tailLength:3];
    } else {
        NSString *compStr = [NSString stringWithFormat:@"%@%@%zd 积分", [NSNumber moneyFormat:aPrice], aChar, aPoint];
        
        NSRange addRange = [compStr safeRangeOfString:aChar];//连接符range
        NSRange pointRange = [compStr safeRangeOfString:@" 积分"];//积分range
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:compStr];
        [attributedString setAttributes:aAttributes range:NSMakeRange(0, addRange.location)];
        [attributedString setAttributes:cAttributes range:addRange];
        [attributedString setAttributes:bAttributes range:NSMakeRange(addRange.location+addRange.length, pointRange.location-addRange.location-addRange.length)];
        [attributedString setAttributes:cAttributes range:pointRange];
        return attributedString;
    }
}

@end
