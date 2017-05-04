//
//  OTSViewAttribute.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewAttribute.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
#import "UIView+Border.h"
#import "OTSIntentModel.h"
#import "NSObject+Runtime.h"
#import "OTSDynamicKitProtocol.h"

@implementation OTSViewAttribute

NSString *const OTSTapIntentModelKey = @"ots_tap_intentModel";
NSString *const OTIntentDelegateKey = @"ots_intent_delegate";

- (void)setNilValueForKey:(NSString *)key {
    //do nothing
}

- (CGSize)preferredSize {
    CGFloat width = 0, height = 0;
    if ((self.preferredWidth && self.preferredHeight) ||
        (self.preferredWidth && self.preferredRatio) ||
        (self.preferredHeight && self.preferredRatio)) {
        
        if (self.preferredWidth && self.preferredHeight) {
            width = self.preferredWidth;
            height = self.preferredHeight;
        } else if(self.preferredWidth) {
            width = self.preferredWidth;
            height = self.preferredWidth / self.preferredRatio;
        } else if(self.preferredHeight) {
            height = self.preferredHeight;
            width = self.preferredHeight * self.preferredRatio;
        }
    }
    return CGSizeMake(width, height);
}

@end

@implementation UIView (OTSViewAttributeApply)

- (void)applyAttribute:(nullable OTSViewAttribute*)attribute delegate:(id)delegate {
    if (!attribute) {
        return;
    }
    
    if (attribute.cornerRadius) {
        self.layer.cornerRadius = attribute.cornerRadius;
        self.layer.masksToBounds = true;
    } else {
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = false;
    }
    
    if (attribute.backgroundColor) {
        self.backgroundColor = [UIColor colorWithRGB:attribute.backgroundColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    if (attribute.tintColor) {
        self.tintColor = [UIColor colorWithRGB:attribute.tintColor];
    }
    
    if (attribute.borderOption) {
        self.borderOption = attribute.borderOption;
    } else {
        if (self.borderOption) {
            self.borderOption = OTSBorderOptionNone;
        }
    }
    
    [self objc_setAssociatedObject:OTIntentDelegateKey value:delegate policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self objc_setAssociatedObject:OTSTapIntentModelKey value:attribute.tapIntentModel policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    
    if ([self isKindOfClass:[UIControl class]]) {
        ((UIControl*)self).enabled = !attribute.disabled;
    }
    
    if (attribute.tapIntentModel) {
        if ([self isKindOfClass:[UIControl class]]) {
            UIControl *control = (id)self;
            for (id target in control.allTargets) {
                [control removeTarget:target action:NULL forControlEvents:UIControlEventTouchUpInside];
            }
            [control addTarget:self action:@selector(__ots_OTSViewAttribute_handleTap:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            for (id gesture in self.gestureRecognizers) {
                [self removeGestureRecognizer:gesture];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__ots_OTSViewAttribute_handleTap:)];
            [self addGestureRecognizer:tap];
        }
    }
}

- (void)resizeWithAttribute:(nullable OTSViewAttribute*)attribute {
    CGSize preferredSize = [attribute preferredSize];
    if (!CGSizeEqualToSize(preferredSize, CGSizeZero)) {
        self.width = preferredSize.width;
        self.height = preferredSize.height;
    } else {
        if (attribute.preferredWidth) {
            self.width = attribute.preferredWidth;
            self.height = [self sizeThatFits:CGSizeMake(attribute.preferredWidth, .0)].height;
        } else {
            [self sizeToFit];
        }
        if (attribute.maxWidth && self.width > attribute.maxWidth) {
            self.width = attribute.maxWidth;
        }
        if (attribute.minWidth && self.width < attribute.minWidth) {
            self.width = attribute.minWidth;
        }
        
        if (attribute.minHeight && self.height < attribute.minHeight) {
            self.height = attribute.minHeight;
        }
        
        if (attribute.maxHeight && self.height > attribute.maxHeight) {
            self.height = attribute.maxHeight;
        }
    }
}

- (void)__ots_OTSViewAttribute_handleTap:(id)sender {
    id delegate = [self objc_getAssociatedObject:OTIntentDelegateKey];
    OTSIntentModel *tap = [self objc_getAssociatedObject:OTSTapIntentModelKey];
    if ([delegate respondsToSelector:@selector(didexecuteIntentModel:)] && tap) {
        [delegate didexecuteIntentModel:tap];
    }
}

@end
