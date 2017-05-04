//
//  OTSLabelItem.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"
#import "UIColor+Utility.h"
#import "NSString+Frame.h"

@implementation OTSTextAttribute

- (CGFloat)referencedHeightForWidth:(CGFloat)preferredWidth
                    alternativeFont:(CGFloat)alternativeFontSize {
    
    CGFloat resultWidth = preferredWidth;
    if (self.preferredWidth) {
        resultWidth = self.preferredWidth;
    } else {
        if (self.maxWidth) {
            resultWidth = MIN(self.maxWidth, resultWidth);
        }
        if (self.minWidth) {
            resultWidth = MAX(self.minWidth, resultWidth);
        }
    }
    
    CGFloat resultHeight = self.preferredHeight ?: [self.title sizeWithFont:[UIFont systemFontOfSize:self.fontSize ?: alternativeFontSize] lineBreakMode:self.lineBreakMode preferredWidth:resultWidth].height;
    
    if (self.maxHeight) {
        resultHeight = MIN(resultHeight, self.maxHeight);
    }
    if (self.minHeight) {
        resultHeight = MAX(resultHeight, self.minHeight);
    }
    
    return resultHeight;
}

@end

@implementation UILabel (OTSTextAttributeApply)

- (void)applyAttribute:(OTSTextAttribute*)item
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor
              delegate:(id)delegate {
    
    [super applyAttribute:item delegate:delegate];
    
    if (item) {
        if (item.attributedTitle) {
            self.attributedText = item.attributedTitle;
        } else {
            self.text = item.title;
        }
        
        CGFloat fontSize = item.fontSize ?: alternativeFont;
        self.font = item.bold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
        self.textColor = [UIColor colorWithRGB:item.color ?: alternativeColor];
        self.lineBreakMode = item.lineBreakMode;
        self.textAlignment = item.textAlignment;
    } else {
        self.text = nil;
    }
    
    self.layer.masksToBounds = true;
}

@end


