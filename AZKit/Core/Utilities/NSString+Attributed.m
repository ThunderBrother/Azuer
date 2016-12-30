//
//  NSString+Attributed.m
//  OTSKit
//
//  Created by Jerry on 16/9/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "NSString+Attributed.h"

@implementation NSString (Attributed)


/**
 *  功能:拼装2个组合字串(知道首字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                headLength:(NSUInteger)aLength
{
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange tailRange = NSMakeRange(aLength, self.length-aLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  功能:拼装2个组合字串(知道尾字串长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                            tailAttributes:(NSDictionary *)bAttributes
                                                tailLength:(NSUInteger)aLength
{
    NSRange headRange = NSMakeRange(0, self.length-aLength);
    NSRange tailRange = NSMakeRange(self.length-aLength, aLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  功能:拼装3个组合字串(知道首尾长度)
 */
- (NSAttributedString *)attributedStringWithHeadAttributes:(NSDictionary *)aAttributes
                                             midAttributes:(NSDictionary *)bAttributes
                                            tailAttributes:(NSDictionary *)cAttributes
                                                headLength:(NSUInteger)aLength
                                                tailLength:(NSUInteger)cLength
{
    NSRange headRange = NSMakeRange(0, aLength);
    NSRange midRange = NSMakeRange(aLength, self.length-aLength-cLength);
    NSRange tailRange = NSMakeRange(self.length-cLength, cLength);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString setAttributes:aAttributes range:headRange];
    [attributedString setAttributes:bAttributes range:midRange];
    [attributedString setAttributes:cAttributes range:tailRange];
    
    return attributedString;
}

/**
 *  功能:价格字符串小数点前后字体和颜色
 */
- (NSMutableAttributedString *)stringWithColor:(UIColor *)aColor symbolFont:(UIFont *)aSymbolFont integerFont:(UIFont *)aIntrgerFont decimalFont:(UIFont *)aDecimalFont {
    if (self.length <= 0) {
        return nil;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    [string addAttribute:NSForegroundColorAttributeName value:aColor range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:aSymbolFont range:NSMakeRange(0, 1)];
    NSRange range = [self rangeOfString:@"."];
    if (range.location != NSNotFound) {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, range.location)];
        [string addAttribute:NSFontAttributeName value:aDecimalFont range:NSMakeRange(range.location,  string.length - range.location)];
    } else {
        [string addAttribute:NSFontAttributeName value:aIntrgerFont range:NSMakeRange(1, string.length - 1)];
    }
    
    return string;
}

@end
