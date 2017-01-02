//
//  MobileReceiverSaveInputVo.h
//  OneStore
//
//  Created by yuan jun on 13-8-23.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingMobileInput.h"

@interface MobileReceiverSaveInputVo : ShoppingMobileInput

@property(nonatomic, strong)NSString *address1;
@property(nonatomic, strong)NSNumber *cityID;//long二级id
@property(nonatomic, strong)NSNumber *countryID;//long国家id
@property(nonatomic, strong)NSNumber *countyID;//long 三级id
@property(nonatomic, strong)NSNumber *defaultReceiver;//int 是否默认
@property(nonatomic, strong)NSNumber *nid;//long
@property(nonatomic, strong)NSString *mobile;//手机
@property(nonatomic, strong)NSString *phone;//固定电话
@property(nonatomic, strong)NSNumber *provinceID;//long
@property(nonatomic, strong)NSString *receiverName;//收货人姓名
@property(nonatomic, strong)NSString *mobileBizType;//社区团标志
@property(nonatomic, strong)NSNumber *buildingID;//微便利、社区团专用 必填
@property(nonatomic, strong)NSString *buildingName;//微便利、社区团专用 必填
@property(nonatomic, strong)NSNumber *virtualProvinceId;//虚拟省份id
@property(nonatomic, strong)NSNumber *fastbuyflag;//一键购
@property(nonatomic, strong)NSNumber *selfpickup;//自提类型

@end
