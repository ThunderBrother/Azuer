//
//  OTSPropertyListView.m
//  OTSKit
//
//  Created by Jerry on 16/9/23.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSPropertyListView.h"
#import "NSArray+safe.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
#import "AZFuncDefine.h"

@implementation OTSPropertyListView {
    NSMutableArray<UILabel*> *_titleLabels;
    NSMutableArray<UILabel*> *_valueLabels;
    
    NSMutableArray<UILabel*> *_reusableImageArray;
}

OTSViewInit {
    _reusableImageArray = [NSMutableArray arrayWithCapacity:10.0];
    _preferredTitleWidth = 100.0f;
    
    _titleAlignment = NSTextAlignmentLeft;
    _valueAlignment = NSTextAlignmentLeft;
    
    _titleColor = [UIColor colorWithRGB:0x333333];
    _valueColor = [UIColor colorWithRGB:0x666666];
    
    _titleFont = [UIFont systemFontOfSize:14.0];
    _valueFont = [UIFont systemFontOfSize:14.0];
    
    _hSpacing = 10.0f;
    _vSpacing = 10.0f;
    
    _titleLabels = [NSMutableArray array];
    _valueLabels = [NSMutableArray array];
}

- (void)layoutSubviews {
    CGFloat yOffset = .0;
    for (int i = 0; i < _titleLabels.count; i++) {
        
        UILabel *aTitleLabel = [_titleLabels safeObjectAtIndex:i];
        UILabel *aValueLabel = [_valueLabels safeObjectAtIndex:i];
        
        aTitleLabel.top = yOffset;
        aTitleLabel.width = self.preferredTitleWidth;
        
        CGSize aTitleSize = [aTitleLabel sizeThatFits:aTitleLabel.frame.size];
        aTitleLabel.height = aTitleSize.height;
        
        aValueLabel.top = yOffset;
        aValueLabel.left = aTitleLabel.right + self.hSpacing;
        aValueLabel.width = self.width - aValueLabel.left;
        
        CGSize aValueSize = [aValueLabel sizeThatFits:aValueLabel.frame.size];
        aValueLabel.height = aValueSize.height;
        
        yOffset = MAX(aTitleLabel.bottom, aValueLabel.bottom) + self.vSpacing;
    }
}

- (void)sizeToFit {
    CGSize intrinsicContentSize = [self intrinsicContentSize];
    self.height = intrinsicContentSize.height;
}

- (CGSize)intrinsicContentSize {
    if (!self.width) {
        [self layoutIfNeeded];
    }
    CGFloat preferredWidth = self.width;
    CGFloat yOffset = .0;
    
    for (int i = 0; i < _titleLabels.count; i++) {
        UILabel *aTitleLabel = [_titleLabels safeObjectAtIndex:i];
        UILabel *aValueLabel = [_valueLabels safeObjectAtIndex:i];
        
        CGSize aTitleSize = [aTitleLabel sizeThatFits:CGSizeMake(self.preferredTitleWidth, 0)];
        CGFloat aTitleHeight = aTitleSize.height;
        
        CGFloat aValueWidth = preferredWidth - self.preferredTitleWidth - self.hSpacing;
        
        CGSize aValueSize = [aValueLabel sizeThatFits:CGSizeMake(aValueWidth, .0)];
        CGFloat aValueHeight = aValueSize.height;
        
        yOffset += MAX(aTitleHeight, aValueHeight);
        
        if (i < _titleLabels.count - 1) {
            yOffset += self.vSpacing;
        }
    }
    return CGSizeMake(preferredWidth, yOffset);
}

#pragma mark - API
- (void)reloadDataWithPropertyTitles:(NSArray<NSString*>*)titles
                              values:(NSArray<NSString*>*)values {
    
    NSMutableArray *titlesArray = [NSMutableArray array];
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    if (titles.count != values.count) {
        return;
    }
    
    for (NSString *aTitle in titles) {
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:aTitle];
        [titlesArray addObject:attributedTitle];
    }
    
    for (NSString *aValue in values) {
        NSAttributedString *attributedValue = [[NSAttributedString alloc] initWithString:aValue];
        [valuesArray addObject:attributedValue];
    }
    
    [self reloadDataWithAttributedPropertyTitles:titlesArray values:valuesArray];
}

- (void)reloadDataWithAttributedPropertyTitles:(NSArray<NSAttributedString*>*)titles
                                        values:(NSArray<NSAttributedString*>*)values {
    
    if (titles.count != values.count) {
        return;
    }
    
    if (_titleLabels.count != titles.count) {
        for (UILabel *aLabel in _titleLabels) {
            [self __enqueueLabel:aLabel];
        }
        
        for (UILabel *aLabel in _valueLabels) {
            [self __enqueueLabel:aLabel];
        }
        
        [_titleLabels removeAllObjects];
        [_valueLabels removeAllObjects];
        
        for (int i = 0; i < titles.count; i++) {
            UILabel *titleLabel = [self __dequeueLabel];
            [self addSubview:titleLabel];
            
            UILabel *valueLabel = [self __dequeueLabel];
            [self addSubview:valueLabel];
            
            [_titleLabels addObject:titleLabel];
            [_valueLabels addObject:valueLabel];
        }
    }
    
    for (int i = 0; i < titles.count; i++) {
        UILabel *titleLabel = [_titleLabels safeObjectAtIndex:i];
        UILabel *valueLabel = [_valueLabels safeObjectAtIndex:i];
        
        titleLabel.numberOfLines = 0;
        valueLabel.numberOfLines = 0;
        
        titleLabel.attributedText = [titles safeObjectAtIndex:i];
        valueLabel.attributedText = [values safeObjectAtIndex:i];
    }
    
    [self __refreshLabelsWithTitleAlignment:self.titleAlignment valueAlignment:self.valueAlignment];
    [self __refreshLabelsWithTitleColor:self.titleColor valueColor:self.valueColor];
    [self __refreshLabelsWithTitleFont:self.titleFont valuefont:self.valueFont];
}

#pragma mark - Setter & Getter
- (void)setPreferredTitleWidth:(CGFloat)preferredTitleWidth {
    if (_preferredTitleWidth != preferredTitleWidth) {
        _preferredTitleWidth = preferredTitleWidth;
        [self setNeedsLayout];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        [self __refreshLabelsWithTitleColor:titleColor valueColor:self.valueColor];
    }
}

- (void)setValueColor:(UIColor *)valueColor {
    if (_valueColor != valueColor) {
        _valueColor = valueColor;
        [self __refreshLabelsWithTitleColor:self.titleColor valueColor:valueColor];
    }
}

- (void)setHSpacing:(CGFloat)hSpacing {
    if (_hSpacing != hSpacing) {
        _hSpacing = hSpacing;
        [self setNeedsLayout];
    }
}

- (void)setVSpacing:(CGFloat)vSpacing {
    if (_vSpacing != vSpacing) {
        _vSpacing = vSpacing;
        [self setNeedsLayout];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        [self __refreshLabelsWithTitleFont:titleFont valuefont:self.valueFont];
    }
}

- (void)setValueFont:(UIFont *)valueFont {
    if (_valueFont != valueFont) {
        _valueFont = valueFont;
         [self __refreshLabelsWithTitleFont:self.titleFont valuefont:valueFont];
    }
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    if (_titleAlignment != titleAlignment) {
        _titleAlignment = titleAlignment;
        [self __refreshLabelsWithTitleAlignment:titleAlignment valueAlignment:self.valueAlignment];
    }
}

- (void)setValueAlignment:(NSTextAlignment)valueAlignment {
    if (_valueAlignment != valueAlignment) {
        _valueAlignment = valueAlignment;
        [self __refreshLabelsWithTitleAlignment:self.titleAlignment valueAlignment:valueAlignment];
    }
}

#pragma mark - Private
- (void)__refreshLabelsWithTitleFont:(UIFont*)titleFont
                           valuefont:(UIFont*)valueFont {
    for (UILabel *aTitleLabel in _titleLabels) {
        aTitleLabel.font = titleFont;
    }
    
    for (UILabel *aValueLabel in _valueLabels) {
        aValueLabel.font = valueFont;
    }
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)__refreshLabelsWithTitleColor:(UIColor*)titleColor
                           valueColor:(UIColor*)valueColor {
    for (UILabel *aTitleLabel in _titleLabels) {
        aTitleLabel.textColor = titleColor;
    }
    
    for (UILabel *aValueLabel in _valueLabels) {
        aValueLabel.textColor = valueColor;
    }
}

- (void)__refreshLabelsWithTitleAlignment:(NSTextAlignment)titleAlignment
                           valueAlignment:(NSTextAlignment)valueAlignment {
    for (UILabel *aTitleLabel in _titleLabels) {
        aTitleLabel.textAlignment = titleAlignment;
    }
    
    for (UILabel *aValueLabel in _valueLabels) {
        aValueLabel.textAlignment = valueAlignment;
    }
}

- (void)__enqueueLabel:(UILabel*)aLabel {
    if (_reusableImageArray.count < 10.0) {
        aLabel.text = nil;
        aLabel.attributedText = nil;
        [_reusableImageArray addObject:aLabel];
    }
    [aLabel removeFromSuperview];
}

- (UILabel*)__dequeueLabel {
    if (_reusableImageArray.count) {
        UILabel *label = _reusableImageArray.lastObject;
        [_reusableImageArray removeLastObject];
        return label;
    }
    return [[UILabel alloc] init];
}

@end
