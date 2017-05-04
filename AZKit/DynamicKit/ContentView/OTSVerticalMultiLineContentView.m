//
//  OTSVerticalMultiLineContentView.m
//  OTSKit
//
//  Created by Jerry on 2017/2/6.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSVerticalMultiLineContentView.h"

UIKIT_EXTERN CGFloat OTSMultiLineContentViewInnerMargin;

@implementation OTSVerticalMultiLineContentView

#pragma mark - Override
- (void)__layoutLeftRightViewsWithLeftEdge:(out CGFloat*)oEdgeLeft
                                 rightEdge:(out CGFloat*)oEdgeRight {
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat edgeLeft = (UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.contentInsets.left);
    CGFloat edgeRight = width - (UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.contentInsets.right);
    
    if (_attribute.accessoryImageAttibute) {
        [_accessoryImageView resizeWithAttribute:_attribute.accessoryImageAttibute];
        _accessoryImageView.center = CGPointMake(edgeRight - _accessoryImageView.width * .5f, height * .5f);
        edgeRight -= (_accessoryImageView.width + (_attribute.accessoryImageAttibute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    if (_attribute.buttonAttribute) {
        [_rightButton resizeWithAttribute:_attribute.buttonAttribute];
        _rightButton.center = CGPointMake(edgeRight - _rightButton.width * .5f, height * .5f);
        edgeRight -= (_rightButton.width + (_attribute.buttonAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    *oEdgeLeft = edgeLeft;
    *oEdgeRight = edgeRight;
}

- (void)__layoutContentViewWithLeftEdge:(CGFloat)edgeLeft rightEdge:(CGFloat)edgeRight {
    CGFloat yOffset = UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.contentInsets.top;
    
    if (_attribute.imageAttribute) {
        [_leftImageView resizeWithAttribute:_attribute.imageAttribute];
        _leftImageView.centerX = self.width * .5f;
        _leftImageView.top = yOffset;
        
        yOffset = _leftImageView.bottom;
        
        if (_attribute.titleAttribute) {
            yOffset += (_attribute.titleAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin);
        }
    }
    
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
    
    CGFloat resultHeight = UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.contentInsets.top + item.contentAttribute.contentInsets.bottom);
    
    if (item.imageAttribute) {
        resultHeight += ([item.imageAttribute preferredSize].height ?: 20.0);
    }
    
    if (item.titleAttribute) {
        resultHeight += ([item.titleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:0]] + (item.titleAttribute.contentOffset.vertical ?: OTSMultiLineContentViewInnerMargin));
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

@end
