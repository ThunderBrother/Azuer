//
//  OTSMultiLeavesPickerInputView.m
//  OTSKit
//
//  Created by Jerry on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSMultiLeavesPickerInputView.h"
#import "NSArray+safe.h"
#import "UIColor+Utility.h"
#import "UIView+Frame.h"
#import "UIView+Border.h"

@interface OTSBasePickerInputView()

- (void)didPressSubmitButton;

@end

@interface OTSMultiLeavesPickerInputView()

@property (strong, nonatomic) UIView *titleHolder;

@end

@implementation OTSMultiLeavesPickerInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.pickerView.frame = CGRectMake(0, 44 + 44, self.width, self.height - 44 - 44);
        
        self.titleHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.width, 44)];
        self.titleHolder.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleHolder];
        
    }
    return self;
}

+ (CGFloat) preferredHeight {
    return 260.0;
}

- (void)didPressSubmitButton {
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (int i = 0; i < self.levelTitles.count - 1; i++) {
        [selectedArray addObject:@([self.pickerView selectedRowInComponent:i])];
    }
    self.selectedIndexSet = selectedArray;
    [super didPressSubmitButton];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (void)setLevelTitles:(NSArray<NSString *> *)levelTitles {
    _levelTitles = levelTitles;
    [self.titleHolder.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.titleHolder.borderOption = OTSBorderOptionTop | OTSBorderOptionBottom;
    
    CGFloat titleWidth = levelTitles.count ? self.width / levelTitles.count : .0;
    
    for (int i = 0; i < levelTitles.count; i++) {
        NSString *aTitle = levelTitles[i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * titleWidth, 0, titleWidth, 44)];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [OTSColor colorWithRGB:0x333333];
        label.text = aTitle;
        label.textAlignment = NSTextAlignmentCenter;
        [self.titleHolder addSubview:label];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArray.count;
    } else {
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        OTSMultiLeavesPickerData *data = [self.dataArray safeObjectAtIndex:selectedRow];
        return data.sub.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    OTSMultiLeavesPickerData *aData;
    if (component == 0) {
        aData = [self.dataArray safeObjectAtIndex:row];
    } else {
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        OTSMultiLeavesPickerData *data = [self.dataArray safeObjectAtIndex:selectedRow];
        aData = [data.sub safeObjectAtIndex:row];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textColor = [OTSColor colorWithRGB:0x333333];
    label.text = aData.title;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    if (component == 0) {
        return label;
    }
    
    UILabel *labelTow = [[UILabel alloc] init];
    labelTow.font = [UIFont systemFontOfSize:10.0];
    labelTow.textColor = [OTSColor colorWithRGB:0x333333];
    labelTow.text = aData.subTitle;
    labelTow.textAlignment = NSTextAlignmentCenter;
    
    UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width * 2.0 / 3.0, label.height)];
    [holderView addSubview:label];
    [holderView addSubview:labelTow];
    
    label.width = holderView.width * .5f;
    labelTow.frame = CGRectMake(label.right, 0, label.width, label.height);
    
    return holderView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return self.width / 3.0;
    } else {
        return self.width * 2.0 / 3.0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:true];
    }
}

#pragma mark - Getter & Setter
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
}

@end

@implementation OTSMultiLeavesPickerData


@end
