//
//  OTSRegionInputView.h
//  OTSKit
//
//  Created by Jerry on 16/9/13.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBasePickerInputView.h"
#import "ProvinceVO.h"



@interface OTSRegionInputView : OTSBasePickerInputView

@property (strong, nonatomic, readonly) ProvinceVO *selectedProvince;
@property (strong, nonatomic, readonly) CityVO *selectedCity;
@property (strong, nonatomic, readonly) CountyVO *selectedCountyVO;

- (void)updateDataUserInfo:(NSDictionary*)userInfo;

@end
