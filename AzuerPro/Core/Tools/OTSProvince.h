//
//  OTSProvince.h
//  OneStore
//
//  Created by huang jiming on 13-1-17.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSProvince : NSObject

/**
 *  功能:获取所有省份名称
 *  返回:所有省份名称
 */
+ (NSArray *)getAllProvinceName;

/**
 *  功能:根据省份id获取省份名称
 *  provinceId:省份id
 *  返回:省份名称
 */
+ (NSString *)getProvinceNameFromId:(NSNumber *)provinceId;

/**
 *  功能:根据省份名称获取省份id
 *  provinceName:省份名称
 *  返回:省份id
 */
+ (NSNumber *)getProvinceIdFromName:(NSString *)provinceName;
@end
