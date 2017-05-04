//
//  OTSMultiLineContentView.m
//  OTSKit
//
//  Created by Jerry on 2017/1/11.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSMultiLineContentView.h"
#import "UIView+Frame.h"
#import "NSString+Frame.h"
#import "AZFuncDefine.h"
#import "OTSViewModelItem.h"
#import "OTSPlaceHolderImageView.h"

@implementation OTSMultiLineContentView

const CGFloat OTSMultiLineContentViewInnerMargin = 6.0;

- (void)__layoutCenterLinesWithYOffset:(CGFloat)yOffset
                              leftEdge:(CGFloat)edgeLeft
                             rightEdge:(CGFloat)edgeRight {
    CGFloat labelWidth = edgeRight - edgeLeft;
    
    if (_attribute.titleAttribute) {
        [self __layoutLabel:_leftTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
                  attribute:_attribute.titleAttribute];
    }
    
    if (_attribute.subTitleAttribute) {
        [self __layoutLabel:_leftSubTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
                  attribute:_attribute.subTitleAttribute];
    }
    
    if (_attribute.thirdTitleAttribute) {
        [self __layoutLabel:_rightTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
                  attribute:_attribute.thirdTitleAttribute];
    }
    
    if (_attribute.fourthTitleAttribute) {
        [self __layoutLabel:_rightSubTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
                  attribute:_attribute.fourthTitleAttribute];
    }
}

#pragma mark - Override
- (void)__layoutContentViewWithLeftEdge:(CGFloat)edgeLeft rightEdge:(CGFloat)edgeRight {
    CGFloat yOffset = UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.contentInsets.top;
    
    [self __layoutCenterLinesWithYOffset:yOffset leftEdge:edgeLeft rightEdge:edgeRight];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    CGFloat originalHeight = 120.0;
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return CGSizeMake(UI_CURRENT_SCREEN_WIDTH, originalHeight);
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    CGFloat viewWidth = item.contentAttribute.preferredWidth ?: UI_CURRENT_SCREEN_WIDTH;
    
    if (item.contentAttribute.preferredHeight) {
        return CGSizeMake(viewWidth, item.contentAttribute.preferredHeight);
    }
    
    CGFloat itemWidth = viewWidth - (UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.contentInsets, UIEdgeInsetsZero) ?UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.contentInsets.left + item.contentAttribute.contentInsets.right));
    
    if (item.accessoryImageAttibute) {
        itemWidth -= ((item.accessoryImageAttibute.preferredWidth ?: 20.0) + (item.accessoryImageAttibute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    if (item.buttonAttribute) {
        itemWidth -= ((item.buttonAttribute.preferredWidth ?: 20.0) + (item.buttonAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    if (item.imageAttribute) {
        itemWidth -= ((item.imageAttribute.preferredWidth ?: 20.0) + (item.titleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    CGFloat resultHeight = UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.contentInsets.top + item.contentAttribute.contentInsets.bottom);
    
    if (item.titleAttribute) {
        resultHeight += [item.titleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:0]];
    }
    
    if (item.subTitleAttribute) {
        resultHeight += ([item.subTitleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:1]] + (item.subTitleAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin));
    }
    
    if (item.thirdTitleAttribute) {
        resultHeight += ([item.thirdTitleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:1]] + (item.thirdTitleAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin));
    }
    
    if (item.fourthTitleAttribute) {
        resultHeight += ([item.fourthTitleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:1]] + (item.fourthTitleAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin));
    }
    
    if (item.contentAttribute.minHeight) {
        resultHeight = MAX(resultHeight, item.contentAttribute.minHeight);
    }
    
    if (item.contentAttribute.maxHeight) {
        resultHeight = MIN(resultHeight, item.contentAttribute.maxHeight);
    }
    
    return CGSizeMake(viewWidth, resultHeight);
}

#pragma mark - Getter & Setter
- (UILabel*)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [self __createLabel];
        _rightTitleLabel.numberOfLines = 0;
        [self addSubview:_rightTitleLabel];
    }
    return _rightTitleLabel;
}

- (UILabel*)rightSubTitleLabel {
    if (!_rightSubTitleLabel) {
        _rightSubTitleLabel = [self __createLabel];
        _rightSubTitleLabel.numberOfLines = 0;
        [self addSubview:_rightSubTitleLabel];
    }
    return _rightSubTitleLabel;
}

#pragma mark - Private
- (void)__layoutLabel:(UILabel*)label
                withX:(CGFloat)x
                    Y:(CGFloat*)y
                width:(CGFloat)width
            attribute:(OTSTextAttribute*)textAttribute {
    
    CGFloat yOffset = (label == _leftTitleLabel ? *y : (*y + (textAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin)));
    
    label.left = x;
    label.top = yOffset;
    label.width = (textAttribute.preferredWidth ?: width);
    
    [label resizeWithAttribute:textAttribute];
    
    *y = label.bottom;
}

@end
