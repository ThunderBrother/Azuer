//
//  OTSSimpleCollectionViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/14.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSSimpleCollectionViewCell.h"
#import "OTSCollectionViewItem.h"

#define OTSDefaultCollectionViewCellInnerMargin 4.0


@implementation OTSSimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.leftTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    //do nothing
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    [self __layoutCellSubViews];
}

+ (CGSize)sizeForCellData:(id)aData {
    CGFloat originalHeight = 60.0;
    if (![aData isKindOfClass:[OTSCollectionViewItem class]]) {
        return CGSizeMake(UI_CURRENT_SCREEN_WIDTH, originalHeight);
    }
    
    OTSCollectionViewItem *item = (OTSCollectionViewItem*)aData;
   
    CGFloat itemWidth = UI_CURRENT_SCREEN_WIDTH - UI_DEFAULT_PADDING * 2.0;
    if (item.subImageAttribute) {
        itemWidth -= ((item.subImageAttribute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    CGFloat thirdWidth = item.thirdTitleAttribute.preferredWidth ?: [item.thirdTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.thirdTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:2]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    CGFloat fourthWidth = item.fourthTitleAttribute.preferredWidth ?: [item.fourthTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.fourthTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:3]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX].width;
    
    CGFloat rightTitleWidth = MAX(thirdWidth, fourthWidth);
    if (rightTitleWidth) {
        itemWidth -= (rightTitleWidth + UI_DEFAULT_MARGIN);
    }
    
    if (item.imageAttribute) {
        itemWidth -= ((item.imageAttribute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    CGFloat resultHeight = UI_DEFAULT_PADDING * 2.0;
    
    resultHeight += [item.titleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.titleAttribute.font ?: [self __defaultFontForLabelAtIndex:0]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:(item.titleAttribute.preferredWidth ?: itemWidth)].height;
    
    CGFloat subTitleHeight = [item.subTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.subTitleAttribute.font ?: [self __defaultFontForLabelAtIndex:1]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:(item.subTitleAttribute.preferredWidth ?: itemWidth)].height;
    if (subTitleHeight) {
        resultHeight += (OTSDefaultCollectionViewCellInnerMargin + subTitleHeight);
    }
    
    return CGSizeMake(UI_CURRENT_SCREEN_WIDTH, resultHeight);
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSCollectionViewItem class]]) {
        return;
    }
    
    OTSCollectionViewItem *item = (OTSCollectionViewItem*)aData;
    
    _imageAttribute = item.imageAttribute;
    _rightImageAttribute = item.subImageAttribute;
    _accessoryImageAttribute = item.accessoryImageAttibute;
    
    _preferredWidth.leftWidth = item.titleAttribute.preferredWidth;
    _preferredWidth.leftSubWidth = item.subTitleAttribute.preferredWidth;
    _preferredWidth.rightWidth = item.thirdTitleAttribute.preferredWidth;
    _preferredWidth.rightSubWidth = item.fourthTitleAttribute.preferredWidth;
    
    [self.contentView applyAttribute:item.contentAttribute];
    
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
        [self.contentView addSubview:_leftSubTitleLabel];
    }
    return _leftSubTitleLabel;
}

- (UILabel*)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [self __createLabel];
        [self.contentView addSubview:_rightTitleLabel];
    }
    return _rightTitleLabel;
}

- (UILabel*)rightSubTitleLabel {
    if (!_rightSubTitleLabel) {
        _rightSubTitleLabel = [self __createLabel];
        [self.contentView addSubview:_rightSubTitleLabel];
    }
    return _rightSubTitleLabel;
}

- (UIImageView*)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIButton*)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(didPressRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIImageView*)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_accessoryImageView];
    }
    return _accessoryImageView;
}

#pragma mark - Action
- (void)didPressRightButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didPressRightButton:indexPath:)]) {
        [self.delegate didPressRightButton:sender indexPath:self.indexPath];
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
    
    CGFloat edgeLeft = UI_DEFAULT_PADDING;
    CGFloat edgeRight = width - UI_DEFAULT_PADDING;
    
    if (_accessoryImageAttribute) {
        if (_accessoryImageAttribute.preferredWidth && _accessoryImageAttribute.preferredHeight) {
            _accessoryImageView.width = _accessoryImageAttribute.preferredWidth;
            _accessoryImageView.height = _accessoryImageAttribute.preferredHeight;
        } else {
            [_accessoryImageView sizeToFit];
        }
        _accessoryImageView.center = CGPointMake(edgeRight - _accessoryImageView.width * .5f, height * .5f);
        edgeRight -= (_accessoryImageView.width + UI_DEFAULT_MARGIN);
    }
    
    if (_rightImageAttribute) {
        if (_rightImageAttribute.preferredWidth && _rightImageAttribute.preferredHeight) {
            _rightButton.width = _rightImageAttribute.preferredWidth;
            _rightButton.height = _rightImageAttribute.preferredHeight;
        } else {
            [_rightButton sizeToFit];
        }
        _rightButton.center = CGPointMake(edgeRight - _rightButton.width * .5f, height * .5f);
        edgeRight -= (_rightButton.width + UI_DEFAULT_MARGIN);
    }
    
    if (_rightTitleLabel.text) {
        [_rightTitleLabel sizeToFit];
        if (_preferredWidth.rightWidth) {
            _rightTitleLabel.width = _preferredWidth.rightWidth;
        }
        if (_rightSubTitleLabel.text) {
            [_rightSubTitleLabel sizeToFit];
            if (_preferredWidth.rightSubWidth) {
                _rightSubTitleLabel.width = _preferredWidth.rightSubWidth;
            }
            _rightSubTitleLabel.right = edgeRight;
            _rightSubTitleLabel.top = height * .5f + OTSDefaultCollectionViewCellInnerMargin * .5f;
            
            _rightTitleLabel.right = edgeRight;
            _rightTitleLabel.bottom = height * .5f - OTSDefaultCollectionViewCellInnerMargin * .5f;
            
            edgeRight -= (MAX(_rightSubTitleLabel.width, _rightTitleLabel.width) + UI_DEFAULT_MARGIN);
        } else {
            _rightSubTitleLabel.width = .0;
            _rightTitleLabel.center = CGPointMake(edgeRight - _rightTitleLabel.width * .5f, height * .5f);
            edgeRight -= (_rightTitleLabel.width + UI_DEFAULT_MARGIN);
        }
    }
    
    if (_imageAttribute) {
        if (_imageAttribute.preferredWidth && _imageAttribute.preferredHeight) {
            _leftImageView.width = _imageAttribute.preferredWidth;
            _leftImageView.height = _imageAttribute.preferredHeight;
        } else {
            [_leftImageView sizeToFit];
        }
        _leftImageView.center = CGPointMake(edgeLeft + _leftImageView.width * .5f, height * .5f);
        edgeLeft += (_leftImageView.width + UI_DEFAULT_MARGIN);
    }
    
    if (_leftTitleLabel.text) {
        _leftTitleLabel.width = (_preferredWidth.leftWidth ?: edgeRight - edgeLeft);
        [_leftTitleLabel sizeToFit];
        
        if (_preferredWidth.leftWidth) {
            _leftTitleLabel.width = _preferredWidth.leftWidth;
        }
        
        if (_leftSubTitleLabel.text) {
            _leftTitleLabel.left = edgeLeft;
            _leftTitleLabel.top = UI_DEFAULT_PADDING;
            
            _leftSubTitleLabel.width = (_preferredWidth.leftSubWidth ?: (edgeRight - edgeLeft));
            [_leftSubTitleLabel sizeToFit];
            _leftSubTitleLabel.width = (_preferredWidth.leftSubWidth ?: (edgeRight - edgeLeft));
            
            _leftSubTitleLabel.left = edgeLeft;
            _leftSubTitleLabel.top = _leftTitleLabel.bottom + OTSDefaultCollectionViewCellInnerMargin;
            
        } else {
            _leftSubTitleLabel.width = .0;
            _leftTitleLabel.center = CGPointMake(edgeLeft + _leftTitleLabel.width * .5f, height * .5f);
        }
    }
}

@end
