//
//  OTSMultiLinesLabelTableViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/22.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSMultiLinesLabelTableViewCell.h"
#import "OTSTableViewItem.h"

@implementation OTSMultiLinesLabelTableViewCell

#pragma mark - Override
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

    if (_imageAttribute) {
        if (_imageAttribute.preferredWidth && _imageAttribute.preferredHeight) {
            _leftImageView.width = _imageAttribute.preferredWidth;
            _leftImageView.height = _imageAttribute.preferredHeight;
        } else {
            [_leftImageView sizeToFit];
        }
        _leftImageView.center = CGPointMake(edgeLeft + _leftImageView.width * .5f, height * .5f);
        edgeLeft += (_leftImageView.width + UI_DEFAULT_PADDING);
    }
    
    CGFloat yOffset = UI_DEFAULT_PADDING;
    CGFloat labelWidth = edgeRight - edgeLeft;
    
    if (_leftTitleLabel.text) {
        [self __layoutLabel:_leftTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
             preferredWidth:_preferredWidth.leftWidth];
    }
    
    if (_leftSubTitleLabel.text) {
        [self __layoutLabel:_leftSubTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
             preferredWidth:_preferredWidth.leftSubWidth];
    }
    
    if (_rightTitleLabel.text) {
        [self __layoutLabel:_rightTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
             preferredWidth:_preferredWidth.rightWidth];
    }
    
    if (_rightSubTitleLabel.text) {
        [self __layoutLabel:_rightSubTitleLabel
                      withX:edgeLeft
                          Y:&yOffset
                      width:labelWidth
             preferredWidth:_preferredWidth.rightSubWidth];
    }
}

+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return 120.0;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    
    CGFloat resultHeight = UI_DEFAULT_PADDING * 2.0;
    CGFloat labelWidth = UI_CURRENT_SCREEN_WIDTH - UI_DEFAULT_PADDING * 2.0;
    
    if (item.accessoryImageAttibute) {
        labelWidth -= ((item.accessoryImageAttibute.preferredWidth ?: 20.0) + UI_DEFAULT_MARGIN);
    }
    
    if (item.imageAttribute) {
        labelWidth -= (item.imageAttribute.preferredWidth ?: 20.0 + UI_DEFAULT_PADDING);
    }
    
    if (item.subImageAttribute) {
        labelWidth -= (item.subImageAttribute.preferredWidth ?: 20.0 + UI_DEFAULT_MARGIN);
    }
    
    if (item.titleAttribute.title) {
        resultHeight += ([item.titleAttribute.title sizeWithFont:[UIFont systemFontOfSize:[self __defaultFontForLabelAtIndex:0]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:labelWidth].height);
    }
    
    if (item.subTitleAttribute.title) {
        resultHeight += (6.0 + [item.subTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:[self __defaultFontForLabelAtIndex:1]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:labelWidth].height);
    }
    
    if (item.thirdTitleAttribute.title) {
        resultHeight += (6.0 + [item.thirdTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:[self __defaultFontForLabelAtIndex:2]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:labelWidth].height);
    }
    
    if (item.fourthTitleAttribute.title) {
        resultHeight += (6.0 + [item.fourthTitleAttribute.title sizeWithFont:[UIFont systemFontOfSize:[self __defaultFontForLabelAtIndex:3]] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:labelWidth].height);
    }
    
    return resultHeight;
}

#pragma mark - Getter & Setter
- (UILabel*)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [self __createLabel];
        _rightTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:_rightTitleLabel];
    }
    return _rightTitleLabel;
}

- (UILabel*)rightSubTitleLabel {
    if (!_rightSubTitleLabel) {
        _rightSubTitleLabel = [self __createLabel];
        _rightSubTitleLabel.numberOfLines = 0;
        [self.contentView addSubview:_rightSubTitleLabel];
    }
    return _rightSubTitleLabel;
}

#pragma mark - Private
- (void)__layoutLabel:(UILabel*)label
                withX:(CGFloat)x
                    Y:(CGFloat*)y
                width:(CGFloat)width
       preferredWidth:(CGFloat)preferredWidth {
    
    label.left = x;
    label.top = *y;
    label.width = (preferredWidth ?: width);
    [label sizeToFit];
    
    if (preferredWidth) {
        label.width = preferredWidth;
    }
    
    *y = label.bottom + 6.0f;
}

@end
