//
//  UIButton+Make.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/8.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIButton+Make.h"
#import <OTSKit/OTSKit.h>

@implementation UIButton (Make)

- (void)makeForBottomActionButton {
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = true;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [self setBackgroundImage:[UIImage imageWithColor:OTSThemeColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xD12F29]] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xbdbdbd]] forState:UIControlStateDisabled];
}

- (void)makeForBottomActionButtonWhite{
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = [UIColor colorWithRGB:0xbdbdbd].CGColor;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = true;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self setTitleColor:[UIColor colorWithRGB:0x757575] forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xffffff]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xe1e1e1]] forState:UIControlStateHighlighted];
}
@end
