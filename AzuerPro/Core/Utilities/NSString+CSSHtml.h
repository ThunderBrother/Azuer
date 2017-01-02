//
//  NSString+CSSHtml.h
//  OneStoreBase
//
//  Created by airspuer on 15/8/27.
//  Copyright (c) 2015年 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CSSHtml)

/**
 *  给html添加一个居中显示的css样式,返回此html
 *
 *  @return
 */
- (NSString *)getAlignCenterCssHtml;

- (NSString *)getWirelessAlignCenterCssHtml;

- (NSString *)getPCAlignCenterCssHtml;

- (NSString *)getTheOtherOneAlignCenterCssHtml;

@end
