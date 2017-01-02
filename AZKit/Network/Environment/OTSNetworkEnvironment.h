//
//  OTSConnectUrl.h
//  OneStoreNetwork
//
//  Created by superair on 16/6/6.
//  Copyright © 2016年 OneStoreNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AZFuncDefine.h"

typedef NS_ENUM(NSInteger ,OTSNetworkEnvironmentType) {
    OTSNetworkEnvironmentTypeProduct = 0, //生成环境,线上环境
    OTSNetworkEnvironmentTypeTest = 1, //测试环境
    OTSNetworkEnvironmentTypeSTG = 2, //stg环境
};


@interface OTSNetworkEnvironment : NSObject

+ (NSString *)getNetworkHost;

+ (OTSNetworkEnvironmentType)getNetworkType;
+ (void)setNetworkType: (OTSNetworkEnvironmentType)type;

+ (NSString *)getNetworkHostForType: (OTSNetworkEnvironmentType)type;


@end
