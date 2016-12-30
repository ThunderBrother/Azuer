//
//  OTSRegionInputView.m
//  OTSKit
//
//  Created by Jerry on 16/9/13.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSRegionInputView.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"

#import "OTSCurrentAddress.h"
#import "NSArray+safe.h"
#import "NSMutableDictionary+safe.h"
#import "NSObject+Runtime.h"

@interface OTSBasePickerInputView()

@property (weak, nonatomic) UITextField *textField;
- (void)didPressSubmitButton;

@end

@interface OTSRegionInputView ()

@property (strong, nonatomic) NSArray<ProvinceVO*> *dataArray;
@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation OTSRegionInputView

+ (CGFloat) preferredHeight {
    return 220.0;
}

- (void)updateDataUserInfo:(NSDictionary*)userInfo {
    self.userInfo = userInfo;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && self.userInfo) {
        NSNumber *provinceId = self.userInfo[@"provinceid"];
        NSNumber *cityId = self.userInfo[@"cityid"];
        NSNumber *countyId = self.userInfo[@"countyid"];
        
        self.userInfo = nil;
        
        int i = 0;
        
        for (ProvinceVO *province in self.dataArray) {
            if ([province.nid isEqualToNumber:provinceId]) {
                [self.pickerView selectRow:i inComponent:0 animated:YES];
                [self.pickerView reloadComponent:1];
                i = 0;
                self->_selectedProvince = province;
                
                for (CityVO *city in province.cityVoList) {
                    if ([city.nid isEqualToNumber:cityId]) {
                        [self.pickerView selectRow:i inComponent:1 animated:YES];
                        [self.pickerView reloadComponent:2];
                        i = 0;
                        self->_selectedCity = city;
                        
                        for (CountyVO *county in city.countyVoList) {
                            if ([county.nid isEqualToNumber:countyId]) {
                                [self.pickerView selectRow:i inComponent:2 animated:YES];
                                self->_selectedCountyVO = county;
                                break;
                            }
                            i++;
                        }
                        break;
                    }
                    i++;
                }
                break;
            }
            i++;
        }
    }
}

#pragma mark - Action
- (void)didPressSubmitButton {
    NSInteger provinceRow = [self.pickerView selectedRowInComponent:0];
    NSInteger cityRow = [self.pickerView selectedRowInComponent:1];
    NSInteger countyRow = [self.pickerView selectedRowInComponent:2];
    
    ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:provinceRow];
    CityVO *cityVO = [provinceVO.cityVoList safeObjectAtIndex:cityRow];
    CountyVO *countyVO = [cityVO.countyVoList safeObjectAtIndex:countyRow];
    
    self->_selectedProvince = provinceVO;
    self->_selectedCity = cityVO;
    self->_selectedCountyVO = countyVO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict safeSetObject:provinceVO forKey:@"province"];
    [dict safeSetObject:cityVO forKey:@"city"];
    [dict safeSetObject:countyVO forKey:@"county"];
    
    self.textField.text = [NSString stringWithFormat:@"%@, %@, %@", countyVO.countyName, cityVO.cityName, provinceVO.provinceName];
    [super didPressSubmitButton];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArray.count;
    } else if (component == 1) {
        NSInteger firstIndex = [pickerView selectedRowInComponent:0];
        ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:firstIndex];
        return provinceVO.cityVoList.count;
    } else {
        NSInteger firstIndex = [pickerView selectedRowInComponent:0];
        ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:firstIndex];
        NSInteger secondIndex = [pickerView selectedRowInComponent:1];
        CityVO *cityVO = [provinceVO.cityVoList safeObjectAtIndex:secondIndex];
        
        return cityVO.countyVoList.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    NSString *titleString = nil;
    if (component == 0) {
        ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:row];
        titleString = provinceVO.provinceName;
    } else if (component == 1) {
        NSInteger firstIndex = [pickerView selectedRowInComponent:0];
        ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:firstIndex];
        CityVO *cityVO = [provinceVO.cityVoList safeObjectAtIndex:row];
        titleString = cityVO.cityName;
    } else {
        NSInteger firstIndex = [pickerView selectedRowInComponent:0];
        ProvinceVO *provinceVO = [self.dataArray safeObjectAtIndex:firstIndex];
        NSInteger secondIndex = [pickerView selectedRowInComponent:1];
        CityVO *cityVO = [provinceVO.cityVoList safeObjectAtIndex:secondIndex];
        CountyVO *countyVO = [cityVO.countyVoList safeObjectAtIndex:row];
        
        titleString = countyVO.countyName;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [OTSColor colorWithRGB:0x333333];
    label.text = titleString;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    } else if (component == 1) {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

#pragma mark - Getter & Setter
- (NSArray<ProvinceVO*>*)dataArray {
    if (!_dataArray) {
        NSMutableArray *array = [NSMutableArray array];
        
        NSArray *allProvincesArray = [OTSCurrentAddress allProvincesArray];
        for (NSDictionary *dict in allProvincesArray) {
            ProvinceVO *provinceVO  = [[ProvinceVO alloc] initWithDictionary:dict error:nil];
            if (provinceVO) {
                [array addObject:provinceVO];
            }
        }
        _dataArray = array;
    }
    return _dataArray;
}

@end
