//
//  UIFont+Utility.m
//  OTSKit
//
//  Created by Jerry on 16/9/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIFont+Utility.h"
#import "AZFuncDefine.h"

@implementation UIFont (Utility)

+ (UIFont *)small
{
    CGFloat fontSize = 10;
    if (IS_IPAD_DEVICE) {
        fontSize = 12;
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)medium
{
    CGFloat fontSize = 12;
    if (IS_IPAD_DEVICE) {
        fontSize = 14;
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)large
{
    CGFloat fontSize = 14;
    if (IS_IPAD_DEVICE) {
        fontSize = 16;
    }
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)bigLarge
{
    CGFloat fontSize = 18;
    if (IS_IPAD_DEVICE) {
        fontSize = 20;
    }
    return [UIFont systemFontOfSize:fontSize];
}

@end
