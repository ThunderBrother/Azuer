//
//  NSString+safe.m
//  OneStore
//
//  Created by huang jiming on 14-1-8.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "NSString+safe.h"

@implementation NSString (safe)

- (NSString *)safeSubstringFromIndex:(NSUInteger)from
{
    if (from > self.length) {
        return nil;
    } else {
        return [self substringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        return nil;
    } else {
        return [self substringToIndex:to];
    }
}

- (NSString *)safeSubstringWithRange:(NSRange)range
{
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location+length > self.length) {
        return nil;
    } else {
        return [self substringWithRange:range];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    if (aString == nil) {
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self rangeOfString:aString options:mask];
    }
}

- (NSString *)safeStringByAppendingString:(NSString *)aString
{
    if (aString == nil) {
        return [self stringByAppendingString:@""];
    } else {
        return [self stringByAppendingString:aString];
    }
}

- (id)safeInitWithString:(NSString *)aString
{
    if (aString == nil) {
        return [self initWithString:@""];
    } else {
        return [self initWithString:aString];
    }
}

+ (id)safeStringWithString:(NSString *)string
{
    if (string == nil) {
        return [self stringWithString:@""];
    } else {
        return [self stringWithString:string];
    }
}

/**
 *  替换字符串中指定的内容
 */
- (NSString *)replaceFromArray:(NSArray *)fromAry withArray:(NSArray *)replaceAry {
    NSString *result = [NSString stringWithString:self];
    if (result.length>0 && [fromAry count]>0 &&([fromAry count] == [replaceAry count])) {
        for (int i =0;i< [fromAry count];i ++) {
            id fromStr = [fromAry objectAtIndex:i];
            id replaceStr = [replaceAry objectAtIndex:i];
            if ([fromStr isKindOfClass:[NSString class]] && [replaceStr isKindOfClass:[NSString class]]) {
                result = [result stringByReplacingOccurrencesOfString:fromStr withString:replaceStr];
            } else {
                return self;
            }
        }
    }
    return result;
}

@end
