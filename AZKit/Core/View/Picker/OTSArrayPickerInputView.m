//
//  OTSPickerView.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSArrayPickerInputView.h"
#import "NSArray+safe.h"
#import "UIView+Frame.h"
#import "AZFuncDefine.h"

@interface OTSBasePickerInputView ()

@property (weak, nonatomic) UITextField *textField;

- (void)didPressSubmitButton;

@end

@implementation OTSArrayPickerInputView

#pragma mark - Action
- (void)didPressSubmitButton {
    self.selectedString = [self.dataArray safeObjectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.textField.text = self.selectedString;
    
    [super didPressSubmitButton];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dataArray safeObjectAtIndex:row];
}

#pragma mark - Getter & Setter
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
}

- (void)setSelectedString:(NSString *)selectedString {
    if (![_selectedString isEqualToString:selectedString]) {
        _selectedString = selectedString;
        if (self.dataArray.count) {
            NSInteger idx = [self.dataArray safeIndexOfObject:selectedString];
            if (idx != NSNotFound) {
                [self.pickerView selectRow:idx inComponent:0 animated:false];
            }
        }
    }
}

@end
