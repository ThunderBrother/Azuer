//
//  NSString+Frame.m
//  OTSKit
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "NSString+Frame.h"

@implementation NSString (Frame)

- (CGSize)sizeWithFont:(UIFont *)font
         lineBreakMode:(NSLineBreakMode)lineBreakMode
        preferredWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = lineBreakMode;
    
    CGSize size = CGSizeMake(width, MAXFLOAT);
    return [self boundingRectWithSize:size
                                       options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName: font,
                                                    NSParagraphStyleAttributeName: paraStyle}
                                          context:nil].size;
}

@end
