//
//  OTSGlobalValue.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-7-31.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSGlobalValue.h"
//category
#import "NSObject+JsonToVO.h"
#import "NSNumber+safe.h"
//cache
#import "OTSKeychain.h"
#import "OTSUserDefault.h"


@interface OTSGlobalValue()

@property (nonatomic, copy) NSString *signatureKey;                  //解密后的签名密钥

@end

@implementation OTSGlobalValue

@synthesize signatureKey = _signatureKey,
            locatedCityId = _locatedCityId,
            serverTime = _serverTime,
            userId = _userId;


DEF_SINGLETON(OTSGlobalValue)

- (instancetype)init {
    if (self = [super init]) {
        NSNumber *isActive = [OTSKeychain getKeychainValueForType:OTSKeyChainIsActive];
        if (!isActive.boolValue) {
            self.activeLaunch = YES;
            [OTSKeychain setKeychainValue:@(YES) forType:OTSKeyChainIsActive];
        }
        
        //是否新版本第一次启动
        NSString *lastRunVersion = [OTSUserDefault getValueForKey:OTSUserDefaultLastVersion];
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        if (!lastRunVersion || ![lastRunVersion isEqualToString:currentVersion]) {
            self.firstLaunch = YES;
            [OTSUserDefault setValue:currentVersion forKey:OTSUserDefaultLastVersion];
        } else {
            self.firstLaunch = NO;
        }
        
        self.sessionId = [OTSUserDefault getValueForKey:OTSUserDefaultSessionId];
        
        self.customerInfos = @{}.mutableCopy;
        self.messagerSessionInfos = @{}.mutableCopy;
    }
    return self;
}

- (NSString *)signatureKey {
    if (_signatureKey == nil) {
        _signatureKey = [OTSKeychain getKeychainValueForType:OTSKeyChainSignatureKey];
    }
    return _signatureKey;
}

- (void)setSignatureKey:(NSString *)signatureKey {
    if (![_signatureKey isEqualToString:signatureKey]) {
        _signatureKey = [signatureKey copy];
        [OTSKeychain setKeychainValue:signatureKey forType:OTSKeyChainSignatureKey];
    }
}

- (NSNumber *)locatedCityId {
    if (_locatedCityId == nil) {
        _locatedCityId = [OTSUserDefault getValueForKey:@"OTS_DEF_KEY_LOCATED_CITYID"];
    }
    return _locatedCityId;
}

- (void)setLocatedCityId:(NSNumber *)locatedCityId {
    if ([locatedCityId safeIsEqualToNumber:_locatedCityId]) {
            return;
        }
    _locatedCityId = @(locatedCityId.integerValue);
    [OTSUserDefault setValue:locatedCityId forKey:@"OTS_DEF_KEY_LOCATED_CITYID"];
    
}
- (NSDate *)serverTime {
    //根据本地时间与服务器时间的差异 算出的当前服务器的时间  **不要乱改，其他地方有用到
    _serverTime = [NSDate dateWithTimeIntervalSinceNow:self.dTime];
    return _serverTime;
}

- (NSString*)deviceToken {
    if (_deviceToken == nil) {
        _deviceToken = [OTSKeychain getKeychainValueForType:OTSKeyChainDeviceToken];
    }
    return _deviceToken;
}

/**
 *  功能:方法重写，保证返回不为nil
 */
- (NSString *)sessionId {
    if (_sessionId == nil) {
        return @"";
    } else {
        return _sessionId;
    }
}

- (NSNumber *)userId {
    _userId = [OTSUserDefault getValueForKey:@"userid"];
    return _userId;
}


- (void)setUserId:(NSNumber *)userId {
    if (userId == nil) {
        _userId = nil;
        [OTSUserDefault setValue:_userId forKey:@"userid"];
    } else if (![_userId isKindOfClass:[NSNumber class]] || ![_userId isEqualToNumber:userId]) {
        _userId = userId;
        [OTSUserDefault setValue:_userId forKey:@"userid"];
    }
}

- (NSNumber *)redRainH5Control {
    if (!_redRainH5Control) {
        _redRainH5Control = @(0);
    }
    return _redRainH5Control;
}

@end
