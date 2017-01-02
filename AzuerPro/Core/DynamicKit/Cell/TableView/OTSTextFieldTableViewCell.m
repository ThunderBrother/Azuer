//
//  OTSTextFieldCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/13.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextFieldTableViewCell.h"
#import "OTSTableViewItem.h"

@implementation OTSTextFieldTableViewCell {
    OTSImageAttribute *_imageAttribute;
    OTSImageAttribute *_rightImageAttribute;
    
    CGFloat _titlePreferredWidth;
}

@synthesize textField = _textField;
@synthesize rightImageView = _rightImageView;
@synthesize leftImageView = _leftImageView;
@synthesize titleLabel = _titleLabel;
@synthesize textFieldRightImageView = _textFieldRightImageView;

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.textField];
        [_textField addTarget:self action:@selector(didEditTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)didEditTextField:(UITextField*)sender {
    if ([self.delegate respondsToSelector:@selector(textFieldValueDidChanged:)]) {
        [self.delegate textFieldValueDidChanged:sender];
    }
}

#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat edgeLeft = UI_DEFAULT_PADDING;
    CGFloat edgeRight = width - UI_DEFAULT_PADDING;
    
    if (_rightImageAttribute) {
        if (_rightImageAttribute.preferredWidth && _rightImageAttribute.preferredHeight) {
            _rightImageView.width = _rightImageAttribute.preferredWidth;
            _rightImageView.height = _rightImageAttribute.preferredHeight;
        } else {
            [_rightImageView sizeToFit];
        }
        _rightImageView.center = CGPointMake(edgeRight - _rightImageView.width * .5f, height * .5f);
        edgeRight -= (_rightImageView.width + UI_DEFAULT_MARGIN);
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
    
    if (_titleLabel.text) {
        [_titleLabel sizeToFit];
        if (_titlePreferredWidth) {
            _titleLabel.width = _titlePreferredWidth;
        }
        _titleLabel.center = CGPointMake(edgeLeft + _titleLabel.width * .5f, height * .5f);
        edgeLeft += (_titleLabel.width + UI_DEFAULT_MARGIN);
    } else {
        _titleLabel.width = .0;
    }
    
    _textField.frame = CGRectMake(edgeLeft, UI_DEFAULT_MARGIN * .5, edgeRight - edgeLeft, self.height - UI_DEFAULT_MARGIN);
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    
    _imageAttribute = item.imageAttribute;
    _rightImageAttribute = item.subImageAttribute;
    _titlePreferredWidth = item.titleAttribute.preferredWidth;
    
    [self.titleLabel applyAttribute:item.titleAttribute alternativeFont:14.0 andColor:0x333333];
    
    [(item.imageAttribute ? self.leftImageView : _leftImageView) applyAttribute:item.imageAttribute];
    [(item.subImageAttribute ? self.rightImageView : _rightImageView) applyAttribute:item.subImageAttribute];
    
    if (item.accessoryImageAttibute) {
        [self.textFieldRightImageView applyAttribute:item.accessoryImageAttibute];
        self.textField.rightView = self.textFieldRightImageView;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    } else {
        self.textField.rightView = nil;
    }
    
    [self.textField objc_setAssociatedObject:@"ots_indexPath" value:indexPath policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    
    self.textField.text = item.valueString;
    self.textField.placeholder = item.subTitleAttribute.title;
    self.textField.delegate = self.delegate;
    
    if (item.keyboardType == OTSKeyboardTypeTypeArray) {
        OTSArrayPickerInputView *inputView = [OTSArrayPickerInputView pickerWithTextField:self.textField];
        inputView.dataArray = item.contentsArray;
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    } else if(item.keyboardType == OTSKeyboardTypeTypeRegion) {
        OTSRegionInputView *regionPicker = [OTSRegionInputView pickerWithTextField:self.textField];
        [regionPicker updateDataUserInfo:item.userInfo];
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    } else {
        if (item.keyboardType == OTSKeyboardTypeTypePhone) {
            self.textField.keyboardType = UIKeyboardTypePhonePad;
        } else if(item.keyboardType == OTSKeyboardTypeTypeDecimal) {
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
        } else if(item.keyboardType == OTSKeyboardTypeTypeEmail) {
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
        } else {
            self.textField.keyboardType = UIKeyboardTypeDefault;
        }
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.inputView = nil;
    }
}

#pragma mark - Getter & Setter
- (UITextField*)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.textColor = [UIColor colorWithRGB:0x333333];
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithRGB:0x333333];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView*)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView*)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UIImageView*)textFieldRightImageView {
    if (!_textFieldRightImageView) {
        _textFieldRightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_textFieldRightImageView];
    }
    return _textFieldRightImageView;
}

@end
