//
//  UIButton+Position.m
//  OTSKit
//
//  Created by Jerry on 2016/11/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIButton+Position.h"
#import "NSObject+Runtime.h"
#import "UIView+Frame.h"

@implementation UIButton (Position)

#pragma mark - LifeCycle
- (CGSize)intrinsicContentSize {
    if (self.position == OTSButtonPositionImageTop) {
        CGFloat width = MAX(self.imageView.width, self.titleLabel.intrinsicContentSize.width) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        CGFloat height = self.imageView.height + self.titleLabel.intrinsicContentSize.height + self.offset + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        return CGSizeMake(width, height);
    }
    
    CGSize mSize = [super intrinsicContentSize];
    if (self.offset) {
        mSize.width += self.offset;
    }
    return mSize;
}

- (void)updateButtonInsets {
    CGFloat padding = self.padding;
    CGFloat offset = self.offset;
    CGFloat halfOffset = offset * .5f;
    OTSButtonPosition position = self.position;
    self.contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    CGSize size = [self intrinsicContentSize];
    if (position == OTSButtonPositionDefault) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, halfOffset, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -halfOffset, 0, 0);
    } else if (position == OTSButtonPositionImageRight) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.width - size.width + self.titleLabel.intrinsicContentSize.width + halfOffset + padding * 2, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.titleLabel.intrinsicContentSize.width - size.width + self.imageView.width + halfOffset + padding * 2);
    } else if(position == OTSButtonPositionImageTop) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.width, -self.imageView.height - halfOffset, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height - halfOffset, 0, 0, -self.titleLabel.intrinsicContentSize.width);
    }
}

#pragma mark - Getter & Setter
- (void)setOffset:(CGFloat)offset {
    [self objc_setAssociatedObject:@"ots_buttonOffset" value:@(offset) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self updateButtonInsets];
}

- (void)setPadding:(CGFloat)padding {
    [self objc_setAssociatedObject:@"ots_buttonPadding" value:@(padding) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self updateButtonInsets];
}

- (void)setPosition:(OTSButtonPosition)position {
    [self objc_setAssociatedObject:@"ots_buttonPosition" value:@(position) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self updateButtonInsets];
}

- (CGFloat)offset {
    return [[self objc_getAssociatedObject:@"ots_buttonOffset"] floatValue];
}

- (CGFloat)padding {
    return [[self objc_getAssociatedObject:@"ots_buttonPadding"] floatValue];
}

- (OTSButtonPosition)position {
    return [[self objc_getAssociatedObject:@"ots_buttonPosition"] integerValue];
}

@end
