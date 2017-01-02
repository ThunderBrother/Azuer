//
//  OTSCurrentAddress.h
//  OneStoreBase
//
//  Created by huangjiming on 10/13/15.
//  Copyright © 2015 OneStoreBase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZFuncDefine.h"
#import "OTSModel.h"

@interface OTSCurrentAddress : OTSModel

AS_SINGLETON(OTSCurrentAddress)

@property(nonatomic, copy, readonly) NSNumber *currentProvinceId;//当前省份id
@property(nonatomic, copy, readonly) NSString *currentProvinceName;//当前省份名称
@property(nonatomic, copy, readonly) NSNumber *currentCityId;//当前城市id
@property(nonatomic, copy, readonly) NSString *currentCityName;//当前城市名称
@property(nonatomic, copy, readonly) NSNumber *currentCountyId;//当前区域id
@property(nonatomic, copy, readonly) NSString *currentCountyName;//当前区域名称

- (void)changeProvinceWithProvinceName:(NSString *)aProvinceName;

- (void)changeProvinceWithProvinceId:(NSNumber *)aProvinceId;

- (void)updateAddressWithProvinceName:(NSString *)aProvinceName
                             cityName:(NSString *)aCityName
                           countyName:(NSString *)aCountyName;
- (void)changeToDefaultAddress;//切换默认地址

- (BOOL)checkIsDefaultAddress;//确认是否是默认地址

- (void)updateWithProvinceId:(NSNumber *)aProvinceId
                provinceName:(NSString *)aProvinceName
                      cityId:(NSNumber *)aCityId
                    cityName:(NSString *)aCityName
                    countyId:(NSNumber *)aCountyId
                  countyName:(NSString *)aCountyName;

- (BOOL)isEqualToAddressWithProvinceId:(NSNumber *)aProvinceId
                                cityId:(NSNumber *)aCityId
                              countyId:(NSNumber *)aCountyId;


/**
 *  功能:获取省市区缓存文件路径
 */
+ (NSString *)allProvincesFilePathForCache;

/**
 *  功能:获取省市区资源文件路径
 */
+ (NSString *)allProvincesFilePathForResource;

/**
 *  功能:获取所有省市区
 */
+ (NSArray<NSDictionary*> *)allProvincesArray;

@end
