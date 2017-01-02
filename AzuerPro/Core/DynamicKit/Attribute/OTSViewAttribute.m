//
//  OTSViewAttribute.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewAttribute.h"

@implementation OTSViewAttribute

- (void)setNilValueForKey:(NSString *)key {
    //do nothing
}

@end

@implementation UIView (OTSViewAttributeApply)

- (void)applyAttribute:(OTSViewAttribute*)attribute {
    if (attribute.cornerRadius) {
        self.layer.cornerRadius = attribute.cornerRadius;
        self.layer.masksToBounds = true;
    }
    
    if (attribute.backgroundColor) {
        self.backgroundColor = [UIColor colorWithRGB:attribute.backgroundColor];
    }
    
    if (attribute.backgroundImageName) {
        self.layer.contents = (__bridge id)([UIImage imageNamed:attribute.backgroundImageName].CGImage);
    } else {
        self.layer.contents = nil;
    }
}

- (void)layoutAttribute:(nullable OTSViewAttribute*)attribute {
    if (attribute.preferredWidth && attribute.preferredHeight) {
        self.width = attribute.preferredWidth;
        self.height = attribute.preferredHeight;
    } else {
        [self sizeToFit];
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

@end
