//
//  OTSFlexibleContentView.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSFlexibleContentView.h"
#import "AZFuncDefine.h"
#import "OTSPlaceHolderImageView.h"
#import "OTSViewModelItem.h"
#import "UIView+Frame.h"
#import "NSString+Frame.h"
#import "UIColor+Utility.h"

@implementation OTSFlexibleContentView

const CGFloat OTSFlexibleContentViewInnerMargin = 4.0;

OTSViewInit {
    [self addSubview:self.leftTitleLabel];
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat edgeLeft, edgeRight;
    [self __layoutLeftRightViewsWithLeftEdge:&edgeLeft rightEdge:&edgeRight];
    [self __layoutContentViewWithLeftEdge:edgeLeft rightEdge:edgeRight];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    [super updateWithCellData:aData atIndexPath:indexPath];
    
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return;
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    
    _attribute = item;
    
    [(item.titleAttribute ? self.leftTitleLabel : _leftTitleLabel) applyAttribute:item.titleAttribute
                                                                  alternativeFont:[[self class ] __defaultFontForLabelAtIndex:0]
                                                                         andColor:[[self class] __defaultColorForLabelAtIndex:0]
                                                                         delegate:self.delegate];
    
    [(item.subTitleAttribute ? self.leftSubTitleLabel : _leftSubTitleLabel) applyAttribute:item.subTitleAttribute
                                                                           alternativeFont:[[self class] __defaultFontForLabelAtIndex:1]
                                                                                  andColor:[[self class] __defaultColorForLabelAtIndex:1]
                                                                                  delegate:self.delegate];
    
    [(item.thirdTitleAttribute ? self.rightTitleLabel : _rightTitleLabel) applyAttribute:item.thirdTitleAttribute
                                                                         alternativeFont:[[self class] __defaultFontForLabelAtIndex:2]
                                                                                andColor:[[self class] __defaultColorForLabelAtIndex:2]
                                                                                delegate:self.delegate];
    
    [(item.fourthTitleAttribute ? self.rightSubTitleLabel : _rightSubTitleLabel) applyAttribute:item.fourthTitleAttribute
                                                                                alternativeFont:[[self class] __defaultFontForLabelAtIndex:3]
                                                                                       andColor:[[self class] __defaultColorForLabelAtIndex:3]
                                                                                       delegate:self.delegate];
    
    [(item.imageAttribute ? self.leftImageView : _leftImageView) applyAttribute:item.imageAttribute delegate:self.delegate];
    
    [(item.buttonAttribute ? self.rightButton : _rightButton) applyAttribute:item.buttonAttribute delegate:self.delegate];
    [(item.accessoryImageAttibute ? self.accessoryImageView : _accessoryImageView) applyAttribute:item.accessoryImageAttibute delegate:self.delegate];
    
    if (!item.imageAttribute) {
        [_leftImageView removeFromSuperview];
    }
    
    if (!item.buttonAttribute) {
        [_rightButton removeFromSuperview];
    }
    
    if (!item.accessoryImageAttibute) {
        [_accessoryImageView removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    CGFloat originalHeight = 60.0;
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
    
    CGFloat thirdWidth = item.thirdTitleAttribute.preferredWidth ?: [item.thirdTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.thirdTitleAttribute.fontSize ?: [self __defaultFontForLabelAtIndex:2]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    if (item.thirdTitleAttribute.maxWidth) {
        thirdWidth = MIN(thirdWidth, item.thirdTitleAttribute.maxWidth);
    }
    if (item.thirdTitleAttribute.minWidth) {
        thirdWidth = MAX(thirdWidth, item.thirdTitleAttribute.minWidth);
    }
    
    CGFloat fourthWidth = item.fourthTitleAttribute.preferredWidth ?: [item.fourthTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.fourthTitleAttribute.fontSize ?: [self __defaultFontForLabelAtIndex:3]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    if (item.fourthTitleAttribute.maxWidth) {
        fourthWidth = MIN(fourthWidth, item.fourthTitleAttribute.maxWidth);
    }
    if (item.fourthTitleAttribute.minWidth) {
        fourthWidth = MAX(fourthWidth, item.fourthTitleAttribute.minWidth);
    }
    
    CGFloat rightTitleWidth = MAX(thirdWidth, fourthWidth);
    if (rightTitleWidth) {
        itemWidth -= (rightTitleWidth + (item.thirdTitleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    if (item.imageAttribute) {
        itemWidth -= ((item.imageAttribute.preferredWidth ?: 20.0) + (item.titleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    CGFloat resultHeight = UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.contentInsets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.contentInsets.top + item.contentAttribute.contentInsets.bottom);
    
    if (item.titleAttribute) {
        resultHeight += [item.titleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:0]];
    }
    
    if (item.subTitleAttribute) {
        resultHeight += ([item.subTitleAttribute referencedHeightForWidth:itemWidth alternativeFont:[self __defaultFontForLabelAtIndex:1]] + (item.subTitleAttribute.contentOffset.vertical ?: OTSFlexibleContentViewInnerMargin));
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
- (UILabel*)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [self __createLabel];
        _leftTitleLabel.numberOfLines = 0;
        _leftTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _leftTitleLabel;
}

- (UILabel*)leftSubTitleLabel {
    if (!_leftSubTitleLabel) {
        _leftSubTitleLabel = [self __createLabel];
        _leftSubTitleLabel.numberOfLines = 0;
        _leftSubTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_leftSubTitleLabel];
    }
    return _leftSubTitleLabel;
}

- (UILabel*)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [self __createLabel];
        _rightTitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightTitleLabel];
    }
    return _rightTitleLabel;
}

- (UILabel*)rightSubTitleLabel {
    if (!_rightSubTitleLabel) {
        _rightSubTitleLabel = [self __createLabel];
        _rightSubTitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightSubTitleLabel];
    }
    return _rightSubTitleLabel;
}

- (OTSPlaceHolderImageView*)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[OTSPlaceHolderImageView alloc] init];
    }
    [self addSubview:_leftImageView];
    return _leftImageView;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:[UIColor colorWithRGB:0x999999] forState:UIControlStateDisabled];
    }
    [self addSubview:_rightButton];
    return _rightButton;
}

- (UIImageView*)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
    }
    [self addSubview:_accessoryImageView];
    return _accessoryImageView;
}

#pragma mark - Private
- (UILabel*)__createLabel {
    UILabel *aLabel = [[UILabel alloc] init];
    aLabel.font = [UIFont systemFontOfSize:14.0];
    aLabel.textColor = [UIColor colorWithRGB:0x333333];
    aLabel.backgroundColor = [UIColor whiteColor];
    aLabel.layer.masksToBounds = YES;
    return aLabel;
}

+ (CGFloat)__defaultFontForLabelAtIndex:(NSUInteger)index {
    return 14.0;
}

+ (NSUInteger)__defaultColorForLabelAtIndex:(NSUInteger)index {
    if (index == 0 || index == 2) {
        return 0x333333;
    }
    return 0x757575;
}

- (void)__layoutContentViewWithLeftEdge:(CGFloat)edgeLeft
                              rightEdge:(CGFloat)edgeRight {
    
    CGFloat height = self.height;
    
    if (_attribute.thirdTitleAttribute) {
        [_rightTitleLabel resizeWithAttribute:_attribute.thirdTitleAttribute];
        if (_attribute.fourthTitleAttribute) {
            [_rightSubTitleLabel resizeWithAttribute:_attribute.fourthTitleAttribute];
            
            _rightTitleLabel.right = edgeRight;
            _rightSubTitleLabel.right = edgeRight;
            
            CGFloat rightLabelGap = _attribute.fourthTitleAttribute.contentOffset.vertical ?: OTSFlexibleContentViewInnerMargin;
            
            CGFloat rightLabelContentHeight = _rightTitleLabel.height + _rightSubTitleLabel.height + rightLabelGap;
            CGFloat rightOffsetY = (self.height - rightLabelContentHeight) * .5;
            _rightTitleLabel.top = rightOffsetY;
            _rightSubTitleLabel.top = _rightTitleLabel.bottom + rightLabelGap;
            
            edgeRight -= (MAX(_rightSubTitleLabel.width, _rightTitleLabel.width) + (_attribute.thirdTitleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
        } else {
            _rightSubTitleLabel.width = .0;
            _rightTitleLabel.center = CGPointMake(edgeRight - _rightTitleLabel.width * .5f, height * .5f);
            edgeRight -= (_rightTitleLabel.width + (_attribute.thirdTitleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
        }
    }
    
    if (_attribute.titleAttribute) {
        _leftTitleLabel.width = edgeRight - edgeLeft;
        [_leftTitleLabel resizeWithAttribute:_attribute.titleAttribute];
        
        if (_attribute.subTitleAttribute) {
            
            _leftSubTitleLabel.width = edgeRight - edgeLeft;
            [_leftSubTitleLabel resizeWithAttribute:_attribute.subTitleAttribute];
            
            _leftTitleLabel.left = edgeLeft;
            _leftSubTitleLabel.left = edgeLeft;
            
            CGFloat leftLabelGap = _attribute.subTitleAttribute.contentOffset.vertical ?: OTSFlexibleContentViewInnerMargin;
            
            CGFloat leftLabelContentHeight = _leftTitleLabel.height + _leftSubTitleLabel.height + leftLabelGap;
            CGFloat leftOffsetY = (self.height - leftLabelContentHeight) * .5;
            _leftTitleLabel.top = leftOffsetY;
            _leftSubTitleLabel.top = _leftTitleLabel.bottom + leftLabelGap;
            
        } else {
            _leftSubTitleLabel.width = .0;
            _leftTitleLabel.center = CGPointMake(edgeLeft + _leftTitleLabel.width * .5f, height * .5f);
        }
    }

}

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
    
    if (_attribute.imageAttribute) {
        [_leftImageView resizeWithAttribute:_attribute.imageAttribute];
        _leftImageView.center = CGPointMake(edgeLeft + _leftImageView.width * .5f, height * .5f);
        edgeLeft += (_leftImageView.width + (_attribute.titleAttribute.contentOffset.horizontal ?: UI_DEFAULT_MARGIN));
    }
    
    *oEdgeLeft = edgeLeft;
    *oEdgeRight = edgeRight;
}

@end
