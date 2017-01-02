//
//  OTSLabelItem.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"
#import <OTSKit/OTSKit.h>

@implementation OTSTextAttribute

@end

@implementation UILabel (OTSTextAttributeApply)

- (void)applyAttribute:(OTSTextAttribute*)item
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor {
    if (item) {
        if (item.attributedTitle) {
            self.attributedText = item.attributedTitle;
        } else {
            self.text = item.title;
        }
        self.font = [UIFont systemFontOfSize:item.font ?: alternativeFont];
        self.textColor = [UIColor colorWithRGB:item.color ?: alternativeColor];
        
        if (item.backgroundColor) {
            self.backgroundColor = [UIColor colorWithRGB:item.backgroundColor];
        } else {
            self.backgroundColor = [UIColor whiteColor];
        }
        
    } else {
        self.text = nil;
    }
}

@end

@implementation UIButton (OTSTextAttributeApply)

- (void)applyAttribute:(OTSTextAttribute*)item
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor {
    if (item) {
        if (item.attributedTitle) {
            self.titleLabel.attributedText = item.attributedTitle;
        } else {
            [self setTitle:item.title forState:UIControlStateNormal];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:item.font ?: alternativeFont];
        [self setTitleColor:[UIColor colorWithRGB:item.color ?: alternativeColor] forState:UIControlStateNormal];
    } else {
        [self setTitle:nil forState:UIControlStateNormal];
    }
}

@end


