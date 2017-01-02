//
//  OTSFlexibleContentView.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSFlexibleContentView.h"
#import "OTSViewModelItem.h"

@implementation OTSFlexibleContentView

static CGFloat OTSFlexibleContentViewInnerMargin = 4.0;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftTitleLabel];
    }
    return self;
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    [self __layoutCellSubViews];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return;
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    
    _attribute = item;
    [self applyAttribute:item.contentAttribute];
    
    [(item.titleAttribute ? self.leftTitleLabel : _leftTitleLabel) applyAttribute:item.titleAttribute
                                                                  alternativeFont:[[self class ] __defaultFontForLabelAtIndex:0]
                                                                         andColor:[[self class] __defaultColorForLabelAtIndex:0]];
    
    [(item.subTitleAttribute ? self.leftSubTitleLabel : _leftSubTitleLabel) applyAttribute:item.subTitleAttribute
                                                                           alternativeFont:[[self class] __defaultFontForLabelAtIndex:1]
                                                                                  andColor:[[self class] __defaultColorForLabelAtIndex:1]];
    
    [(item.thirdTitleAttribute ? self.rightTitleLabel : _rightTitleLabel) applyAttribute:item.thirdTitleAttribute
                                                                         alternativeFont:[[self class] __defaultFontForLabelAtIndex:2]
                                                                                andColor:[[self class] __defaultColorForLabelAtIndex:2]];
    
    [(item.fourthTitleAttribute ? self.rightSubTitleLabel : _rightSubTitleLabel) applyAttribute:item.fourthTitleAttribute
                                                                                alternativeFont:[[self class] __defaultFontForLabelAtIndex:3]
                                                                                       andColor:[[self class] __defaultColorForLabelAtIndex:3]];
    
    [(item.imageAttribute ? self.leftImageView : _leftImageView) applyAttribute:item.imageAttribute];
    [(item.subImageAttribute ? self.rightButton : _rightButton) applyAttribute:item.subImageAttribute];
    [(item.accessoryImageAttibute ? self.accessoryImageView : _accessoryImageView) applyAttribute:item.accessoryImageAttibute];
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    CGFloat originalHeight = 60.0;
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return originalHeight;
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    
    if (item.contentAttribute.preferredHeight) {
        return item.contentAttribute.preferredHeight;
    }
    
    CGFloat itemWidth = UI_CURRENT_SCREEN_WIDTH - (UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.insets, UIEdgeInsetsZero) ?UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.insets.left + item.contentAttribute.insets.right));
    
    if (item.accessoryImageAttibute) {
        itemWidth -= ((item.accessoryImageAttibute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    if (item.subImageAttribute) {
        itemWidth -= ((item.subImageAttribute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    CGFloat thirdWidth = item.thirdTitleAttribute.preferredWidth ?: [item.thirdTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.thirdTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:2]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    if (item.thirdTitleAttribute.maxWidth) {
        thirdWidth = MIN(thirdWidth, item.thirdTitleAttribute.maxWidth);
    }
    if (item.thirdTitleAttribute.minWidth) {
        thirdWidth = MAX(thirdWidth, item.thirdTitleAttribute.minWidth);
    }
    
    CGFloat fourthWidth = item.fourthTitleAttribute.preferredWidth ?: [item.fourthTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.fourthTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:3]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    if (item.fourthTitleAttribute.maxWidth) {
        fourthWidth = MIN(fourthWidth, item.fourthTitleAttribute.maxWidth);
    }
    if (item.fourthTitleAttribute.minWidth) {
        fourthWidth = MAX(fourthWidth, item.fourthTitleAttribute.minWidth);
    }
    
    CGFloat rightTitleWidth = MAX(thirdWidth, fourthWidth);
    if (rightTitleWidth) {
        itemWidth -= (rightTitleWidth + UI_DEFAULT_MARGIN);
    }
    
    if (item.imageAttribute) {
        itemWidth -= ((item.imageAttribute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    CGFloat resultHeight = UIEdgeInsetsEqualToEdgeInsets(item.contentAttribute.insets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING * 2.0 : (item.contentAttribute.insets.top + item.contentAttribute.insets.bottom);
    
    CGFloat firstTitleHeight = item.titleAttribute.preferredHeight ?: [item.titleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.titleAttribute.font ?: [self __defaultFontForLabelAtIndex:0]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:(item.titleAttribute.preferredWidth ?: itemWidth)].height;
    
    if (item.titleAttribute.maxWidth) {
        firstTitleHeight = MIN(firstTitleHeight, item.titleAttribute.maxWidth);
    }
    if (item.titleAttribute.minWidth) {
        firstTitleHeight = MAX(firstTitleHeight, item.titleAttribute.minWidth);
    }
    
    resultHeight += firstTitleHeight;
    
    CGFloat subTitleHeight = item.subTitleAttribute.preferredHeight ?: [item.subTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.subTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:1]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:(item.subTitleAttribute.preferredWidth ?: itemWidth)].height;
    
    if (item.subTitleAttribute.maxWidth) {
        subTitleHeight = MIN(subTitleHeight, item.subTitleAttribute.maxWidth);
    }
    if (item.subTitleAttribute.minWidth) {
        subTitleHeight = MAX(subTitleHeight, item.subTitleAttribute.minWidth);
    }
    
    if (subTitleHeight) {
        resultHeight += (OTSFlexibleContentViewInnerMargin + subTitleHeight);
    }
    
    if (item.contentAttribute.minHeight) {
        resultHeight = MAX(resultHeight, item.contentAttribute.minHeight);
    }
    
    if (item.contentAttribute.maxHeight) {
        resultHeight = MIN(resultHeight, item.contentAttribute.maxHeight);
    }
    
    return resultHeight;
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

- (UIImageView*)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(didPressRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIImageView*)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
        [self addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}

#pragma mark - Action
- (void)didPressRightButton:(UIButton *)sender {
    switch (_attribute.itemType) {
        case OTSViewModelItemTypeCell:
            if ([self.delegate respondsToSelector:@selector(didPressRightButton:indexPath:)]) {
                [self.delegate didPressRightButton:sender indexPath:self.indexPath];
            }
            break;
            
        case OTSViewModelItemTypeHeader:
            if ([self.delegate respondsToSelector:@selector(didSelectHeaderAtSection:)]) {
                [self.delegate didSelectHeaderAtSection:self.indexPath.section];
            }
            break;
            
        case OTSViewModelItemTypeFooter:
            if ([self.delegate respondsToSelector:@selector(didSelectFooterAtSection:)]) {
                [self.delegate didSelectFooterAtSection:self.indexPath.section];
            }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Private
- (UILabel*)__createLabel {
    UILabel *aLabel = [[UILabel alloc] init];
    aLabel.font = [UIFont systemFontOfSize:14.0];
    aLabel.textColor = [UIColor colorWithRGB:0x333333];
    aLabel.backgroundColor = [UIColor whiteColor];
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

- (void)__layoutCellSubViews {
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat edgeLeft = (UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.insets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.insets.left);
    CGFloat edgeRight = width - (UIEdgeInsetsEqualToEdgeInsets(_attribute.contentAttribute.insets, UIEdgeInsetsZero) ? UI_DEFAULT_PADDING : _attribute.contentAttribute.insets.right);
    
    if (_attribute.accessoryImageAttibute) {
        [_accessoryImageView layoutAttribute:_attribute.accessoryImageAttibute];
        _accessoryImageView.center = CGPointMake(edgeRight - _accessoryImageView.width * .5f, height * .5f);
        edgeRight -= (_accessoryImageView.width + UI_DEFAULT_MARGIN);
    }
    
    if (_attribute.subImageAttribute) {
        [_rightButton layoutAttribute:_attribute.subImageAttribute];
        _rightButton.center = CGPointMake(edgeRight - _rightButton.width * .5f, height * .5f);
        edgeRight -= (_rightButton.width + UI_DEFAULT_MARGIN);
    }
    
    if (_attribute.thirdTitleAttribute) {
        [_rightTitleLabel layoutAttribute:_attribute.thirdTitleAttribute];
        if (_attribute.fourthTitleAttribute) {
            [_rightSubTitleLabel layoutAttribute:_attribute.fourthTitleAttribute];
            
            _rightSubTitleLabel.right = edgeRight;
            _rightSubTitleLabel.top = height * .5f + OTSFlexibleContentViewInnerMargin * .5f;
            
            _rightTitleLabel.right = edgeRight;
            _rightTitleLabel.bottom = height * .5f - OTSFlexibleContentViewInnerMargin * .5f;
            
            edgeRight -= (MAX(_rightSubTitleLabel.width, _rightTitleLabel.width) + UI_DEFAULT_MARGIN);
        } else {
            _rightSubTitleLabel.width = .0;
            _rightTitleLabel.center = CGPointMake(edgeRight - _rightTitleLabel.width * .5f, height * .5f);
            edgeRight -= (_rightTitleLabel.width + UI_DEFAULT_MARGIN);
        }
    }
    
    if (_attribute.imageAttribute) {
        [_leftImageView layoutAttribute:_attribute.imageAttribute];
        _leftImageView.center = CGPointMake(edgeLeft + _leftImageView.width * .5f, height * .5f);
        edgeLeft += (_leftImageView.width + UI_DEFAULT_MARGIN);
    }
    
    if (_attribute.titleAttribute) {
        _leftTitleLabel.width = edgeRight - edgeLeft;
        [_leftTitleLabel layoutAttribute:_attribute.titleAttribute];
        
        if (_attribute.subTitleAttribute) {
            _leftTitleLabel.left = edgeLeft;
            _leftTitleLabel.top = UI_DEFAULT_PADDING;
            
            _leftSubTitleLabel.width = edgeRight - edgeLeft;
            [_leftSubTitleLabel layoutAttribute:_attribute.subTitleAttribute];
            
            _leftSubTitleLabel.left = edgeLeft;
            _leftSubTitleLabel.top = _leftTitleLabel.bottom + OTSFlexibleContentViewInnerMargin;
            
        } else {
            _leftSubTitleLabel.width = .0;
            _leftTitleLabel.center = CGPointMake(edgeLeft + _leftTitleLabel.width * .5f, height * .5f);
        }
    }
}

@end
