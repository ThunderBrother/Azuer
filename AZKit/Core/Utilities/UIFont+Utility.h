//
//  UIFont+Utility.h
//  OTSKit
//
//  Created by Jerry on 16/9/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIFont OTSFont;

@interface UIFont (Utility)

/**
 * 小号字体
 * iPhone:10,ipad:12
 *
 */
+ (UIFont *)small;

/**
 *  中号字体
 * iPhone:12,ipad:14
 */
+ (UIFont *)medium;

/**
 *  大号字体
 * iPhone:14,ipad:16
 */
+ (UIFont *)large;

/**
 *  超大号字体
 * iPhone:18,ipad:20
 */
+ (UIFont *)bigLarge;

@end
