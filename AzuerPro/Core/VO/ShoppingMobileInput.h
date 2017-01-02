//
//  ShoppingMobileInput.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

@interface ShoppingMobileInput : OTSModel

@property(nonatomic, retain) NSString *clientSystem;//系统(WAPPalmOS、Symbian、Windowsmobile、WinCE、Linux和Android、iPhoneOS、黑莓)
@property(nonatomic, retain) NSString *clientVersion;//客户端版本
@property(nonatomic, retain) NSString *deviceCode;//设备唯一标识
@property(nonatomic, retain) NSString *interfaceVersion;//接口版本
@property(nonatomic, retain) NSNumber *provinceId;//省份ID
@property(nonatomic, retain) NSNumber *cityId;//市ID
@property(nonatomic, retain) NSNumber *countyId;//县ID
@property(nonatomic, copy)   NSString *sessionId;//sessionid，相当于cookie的id
@property(nonatomic, retain) NSString *ucocode;//unionKey网盟下单用
@property(nonatomic, retain) NSString *uid;//unionKey网盟下单用
@property(nonatomic, retain) NSString *unionKey;//unionKey网盟下单用
@property(nonatomic, retain) NSNumber *userId;//用户ID(由server端填充)
@property(nonatomic, retain) NSString *userToken;//登录用户凭证
@property(nonatomic, retain) NSString *webSiteId;//unionKey网盟下单用
@property(nonatomic, retain) NSString *mobileSiteType;//客户端site区分 1：一号店 2：1mall 3:合规后一号店 所有接口都必须传入
@property(nonatomic, retain) NSString *tradeName;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *clientAppVersion;
@property(nonatomic, retain) NSString *deviceCodeNotEncrypt;
@property(nonatomic, retain) NSDictionary *customParams;//cms 加车需要的自定义参数。

#pragma mark --雷购物车
@property(nonatomic, strong) NSNumber *lat;  //纬度
@property(nonatomic, strong) NSNumber *lng; //经度
@property(nonatomic, strong) NSNumber *virtualprovinceid;//虚拟省份Id
@property(nonatomic, strong) NSNumber *mobilebiztype; //22: O2O的商品  24: 小雷
/*
 * 如果mobilebiztype为22,则需要传.
 * O2O的商家id
 */
@property(nonatomic, strong) NSNumber *o2omerchantid;

@end
