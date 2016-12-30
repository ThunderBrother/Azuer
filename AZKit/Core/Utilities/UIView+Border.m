//
//  UIView+Border.m
//  OTSKit
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIView+Border.h"
#import "UIColor+Utility.h"
#import "NSObject+Runtime.h"
#import "UIView+Frame.h"

@interface UIView()

@property (strong, nonatomic) NSArray *borderViews;

@end

@implementation UIView (Border)

#pragma mark - Getter & Setter
- (void)setBorderViews:(NSArray *)borderViews {
    if (borderViews.count == 4) {
        [self objc_setAssociatedObject:@"ots_borderViews" value:borderViews policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
}

- (NSArray*)borderViews {
    NSArray *obj = [self objc_getAssociatedObject:@"ots_borderViews"];
    if (!obj) {
        obj = @[[NSNull null], [NSNull null], [NSNull null], [NSNull null]];
    }
    return obj;
}

- (void)setBorderColor:(UIColor*)borderColor {
    if (![self.borderColor isEqual:borderColor]) {
        [self objc_setAssociatedObject:@"ots_borderColor" value:borderColor policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        [self __applyBorderColor];
    }
}

- (UIColor*)borderColor {
    UIColor *obj = [self objc_getAssociatedObject:@"ots_borderColor"];
    if (!obj) {
        obj = [UIColor colorWithRGB:0xe5e5e5];
    }
    return obj;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (self.borderWidth != borderWidth) {
        [self objc_setAssociatedObject:@"ots_borderWidth" value:@(borderWidth) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        [self __applyBorderFrame];
    }
}

- (CGFloat)borderWidth {
    NSNumber *obj = [self objc_getAssociatedObject:@"ots_borderWidth"];
    if (obj) {
        return [obj floatValue];
    }
    return 1.0;
}

- (void)setBorderOption:(OTSBorderOption)borderOption {
    if (self.borderOption != borderOption) {
        [self objc_setAssociatedObject:@"ots_borderOption" value:@(borderOption) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        [self __makeBorder];
    }
}

- (OTSBorderOption)borderOption {
    NSNumber *obj = [self objc_getAssociatedObject:@"ots_borderOption"];
    if (obj) {
        return [obj unsignedIntegerValue];
    }
    return OTSBorderOptionNone;
}

- (void)setBorderInsets:(UIEdgeInsets)borderInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, borderInsets)) {
        [self objc_setAssociatedObject:@"ots_borderInsets" value:[NSValue valueWithUIEdgeInsets:borderInsets] policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        [self __applyBorderFrame];
    }
}

- (UIEdgeInsets)borderInsets {
    NSValue *obj = [self objc_getAssociatedObject:@"ots_borderInsets"];
    if (obj) {
        return [obj UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Private
- (OTSBorderOption)__optionForIndex: (NSInteger)index {
    switch (index) {
        case 0:
            return OTSBorderOptionTop;
            break;
        case 1:
            return OTSBorderOptionLeft;
            break;
        case 2:
            return OTSBorderOptionBottom;
            break;
        case 3:
            return OTSBorderOptionRight;
            break;
        default:
            return OTSBorderOptionNone;
            break;
    }
}

- (void)__makeBorder {
    OTSBorderOption option = self.borderOption;
    
    if (self.borderOption == OTSBorderOptionAll && UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, UIEdgeInsetsZero)) {
        for (id subView in self.borderViews) {
            if ([subView isKindOfClass:[UIView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.borderViews = nil;
    } else {
        NSMutableArray *borderViews = [NSMutableArray arrayWithArray:self.borderViews];
        
        for (int i = 0; i < 4; i++) {
            OTSBorderOption compareOption = [self __optionForIndex:i];
            if (option & compareOption) {
                if (borderViews[i] == [NSNull null]) {
                    UIView *lineView = [[UIView alloc] init];
                    
                    if (i == 0) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    } else if(i == 1) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    } else if(i == 2) {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
                    } else {
                        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
                    }
                    
                    [self addSubview:lineView];
                    borderViews[i] = lineView;
                }
            } else {
                if (borderViews[i] != [NSNull null]) {
                    [borderViews[i] removeFromSuperview];
                    borderViews[i] = [NSNull null];
                }
            }
        }
        
        self.borderViews = borderViews;
    }
    
    [self __applyBorderColor];
    [self __applyBorderFrame];
}

- (void)__applyBorderColor {
    if (self.borderOption == OTSBorderOptionAll && UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, UIEdgeInsetsZero)) {
        self.layer.borderColor = self.borderColor.CGColor;
    } else {
        self.layer.borderColor = nil;
    }
    
    for (id obj in self.borderViews) {
        if (obj == [NSNull null]) {
            continue;
        }
        
        UIView *borderView = obj;
        borderView.backgroundColor = self.borderColor;
    }
}

- (void)__applyBorderFrame {
    
    CGFloat lineWidth = self.borderWidth / [UIScreen mainScreen].scale;
    
    if (self.borderOption == OTSBorderOptionAll && UIEdgeInsetsEqualToEdgeInsets(self.borderInsets, UIEdgeInsetsZero)) {
        self.layer.borderWidth = lineWidth;
        return;
    } else {
        self.layer.borderWidth = 0;
    }
    
    UIEdgeInsets insets = self.borderInsets;
    
    if (!self.width) {
        self.width = 100;
    }
    
    if (!self.height) {
        self.height = 44.0;
    }

    
    for (int i = 0; i < 4; i++) {
        id obj = self.borderViews[i];
        if (obj == [NSNull null]) {
            continue;
        }
        UIView *borderView = obj;
        if (i == 0) {
            borderView.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, lineWidth);
        } else if(i == 1) {
            borderView.frame = CGRectMake(insets.left, insets.top, lineWidth, self.height - insets.top - insets.bottom);
        } else if(i == 2) {
            borderView.frame = CGRectMake(insets.left, self.height - lineWidth - insets.bottom, self.width - insets.left - insets.right, lineWidth);
        } else {
            borderView.frame = CGRectMake(self.width - lineWidth - insets.right, insets.top, lineWidth, self.height - insets.top - insets.bottom);
        }
    }
}

@end
