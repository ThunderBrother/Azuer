//
//  UIColor+Extention.h
//  OTSKit
//
//  Created by HUI on 16/8/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIColor OTSColor;

@interface UIColor (Utility)

/**
 *  通过0xffffff的16进制数字创建颜色
 *
 *  @param aRGB 0xffffff
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithRGB:(NSUInteger)aRGB;

@end
