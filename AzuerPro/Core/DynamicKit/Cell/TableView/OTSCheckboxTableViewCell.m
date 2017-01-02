//
//  OTSCheckBoxTableViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCheckBoxTableViewCell.h"
#import "OTSTableViewItem.h"
#import "UIView+FDCollapsibleConstraints.h"

@interface OTSCheckBoxTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLeadingConstraint;

@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OTSCheckBoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textFieldContainer.hidden = YES;
    
    self.textFieldContainer.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.textFieldContainer.layer.borderColor = [UIColor colorWithRGB:0xe6e6e6].CGColor;
    self.textFieldContainer.layer.cornerRadius = 4.0;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self.radioButton) {
        return self.contentView;
    }
    return [super hitTest:point withEvent:event];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    self.titleLabel.text = item.titleAttribute.title;
    self.radioButton.selected = item.selected;
    
    BOOL showTextField = item.subTitleAttribute.title || item.imageAttribute;
    self.textFieldContainer.hidden = !showTextField;
    
    if (showTextField) {
        [self.textField objc_setAssociatedObject:@"ots_indexPath" value:indexPath policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        self.textField.enabled = item.selected;
        self.textFieldContainer.layer.borderColor = [UIColor colorWithRGB:item.selected ? 0xe6e6e6 : 0xf2f2f2].CGColor;
        
        self.textField.text = item.valueString;
        
        if (item.imageAttribute) {
            UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.imageAttribute.imageName]];
            self.textField.rightView = rightView;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
        } else {
            self.textField.rightView = nil;
        }
        
        if (item.keyboardType == OTSKeyboardTypeTypeArray) {
            OTSArrayPickerInputView *inputView = [OTSArrayPickerInputView pickerWithTextField:self.textField];
            self.textField.clearButtonMode = UITextFieldViewModeNever;
            inputView.dataArray = item.contentsArray;
            inputView.selectedString = item.valueString;
        } else if(item.keyboardType == OTSKeyboardTypeTypeRegion) {
            OTSRegionInputView *regionPicker = [OTSRegionInputView pickerWithTextField:self.textField];
            [regionPicker updateDataUserInfo:item.userInfo];
            self.textField.clearButtonMode = UITextFieldViewModeNever;
        } else {
            
            if (item.keyboardType == OTSKeyboardTypeTypePhone) {
                self.textField.keyboardType = UIKeyboardTypeNumberPad;
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
        
        self.textField.placeholder = item.subTitleAttribute.title;
        self.textField.delegate = self.delegate;
        if (self.titleLabel.text.length) {
            self.titleTrailingConstraint.priority = UILayoutPriorityDefaultHigh;
            self.textFieldLeadingConstraint.priority = UILayoutPriorityDefaultLow;
        } else {
            self.titleTrailingConstraint.priority = UILayoutPriorityDefaultLow;
            self.textFieldLeadingConstraint.priority = UILayoutPriorityDefaultHigh;
        }
    }
}

@end
