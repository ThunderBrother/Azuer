//
//  OTSConnectUrl.m
//  OneStoreNetwork
//
//  Created by superair on 16/6/6.
//  Copyright © 2016年 OneStoreNetwork. All rights reserved.
//

#import "OTSNetworkEnvironment.h"
#import "NSArray+safe.h"
#import "OTSUserDefault.h"

#pragma mark - Adress

//==**以下代码不要轻易改动，按照Venus提供的为准**==
//NSString * const OTSNetworkHostProduct = @"http://mapi.yhd.com";//OneStore Product环境
NSString * const OTSNetworkHostProduct = @"http://mgalaxy.yhd.com/yhden";//OneStore Product环境
NSString * const OTSNetworkHostTest = @"http://10.161.146.223:8080/yhden";//OneStore Test环境 host 10.161.144.154
NSString * const OTSNetworkHostSTG = @"http://mgalaxy.yhd.com/yhden";//OneStore STG环境 host 10.63.12.1

#pragma mark - Key
NSString * const OTSCurrentEnvironmentTypeKey = @"OTSCurrentEnvironmentTypeKey";


@implementation OTSNetworkEnvironment

+ (NSString *)getNetworkHost {
    OTSNetworkEnvironmentType type = [self getNetworkType];
    return [self getNetworkHostForType:type];
}

+ (OTSNetworkEnvironmentType)getNetworkType {
    NSNumber *typeNum = [OTSUserDefault getValueForKey:(NSString *)OTSCurrentEnvironmentTypeKey];
    if (!typeNum) {
        typeNum = @0;
    }
    return typeNum.integerValue;
}

+ (void)setNetworkType: (OTSNetworkEnvironmentType)type {
    [OTSUserDefault setValue:@(type) forKey:OTSCurrentEnvironmentTypeKey];
}

+ (NSString *)getNetworkHostForType: (OTSNetworkEnvironmentType)type {
    NSString *connectUrlAddress = OTSNetworkHostProduct;
    switch (type) {
        case OTSNetworkEnvironmentTypeProduct:
            connectUrlAddress = OTSNetworkHostProduct;
            break;
        case OTSNetworkEnvironmentTypeTest:
            connectUrlAddress = OTSNetworkHostTest;
            break;
        case OTSNetworkEnvironmentTypeSTG:
            connectUrlAddress = OTSNetworkHostSTG;
            break;
        default:
            connectUrlAddress = OTSNetworkHostProduct;
            break;
    }
    return connectUrlAddress;
}

@end
