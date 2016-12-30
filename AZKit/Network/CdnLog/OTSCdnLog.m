//
//  OTSCdnLog.m
//  OneStoreNetwork
//
//  Created by huangjiming on 5/3/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "OTSCdnLog.h"
#import "OTSNotificationDefine.h"
//net
#import "OTSOperationManager.h"
#import "OTSNetworkManager.h"
#import "OTSReachability.h"
//cache
#import "OTSCoreDataManager.h"
//vo
#import "CdnLog.h"
#import "CdnLogVO.h"
//object
#import "OTSClientInfo.h"
#import "OTSCurrentAddress.h"
#import "OTSGlobalValue.h"
//category
#import "NSArray+safe.h"
#import "NSMutableArray+safe.h"
#import "NSMutableDictionary+safe.h"
#import "NSNotificationCenter+RACSupport.h"

#define OTS_MAX_CDN_LOG_COUNT       200
#define OTS_MAX_CDN_LOG_TIME        300
#define OTS_MAX_DEL_CDN_LOG_TIME    600

@interface OTSCdnLog ()

@property(nonatomic, strong) OTSOperationManager *operationManager;
@property(nonatomic, strong) OTSCoreDataManager *coreDataManager;
@property(nonatomic, strong) NSDate *latestSendDate;//最近一次发送时间

@end

@implementation OTSCdnLog

DEF_SINGLETON(OTSCdnLog)

- (instancetype)init {
    self = [super init];
    if (self) {
        WEAK_SELF;
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:OTS_CDN_LOG object:nil] subscribeNext:^(id x) {
            STRONG_SELF;
            
            NSNotification *notification = x;
            NSString *obj = notification.object;
            [self saveCdnLog:obj];
            [self sendLog];
        }];
    }
    return self;
}

#pragma mark - Property
- (OTSOperationManager *)operationManager {
    if (_operationManager == nil) {
        _operationManager = [[OTSNetworkManager sharedInstance] generateOperationManagerWithOwner:self];
    }
    
    return _operationManager;
}

- (OTSCoreDataManager *)coreDataManager {
    if (_coreDataManager == nil) {
        _coreDataManager = [OTSCoreDataManager managerWithCoreDataPath:@"Model.momd"];
    }
    
    return _coreDataManager;
}

- (NSDate *)latestSendDate {
    if (_latestSendDate == nil) {
        _latestSendDate = [NSDate date];
    }
    return _latestSendDate;
}

#pragma mark - API
/**
 *  功能:保存cdn日志
 */
- (void)saveCdnLog:(NSString *)cdnLog {
    [self.coreDataManager insertAndWaitWithClass:[CdnLog class] insertBlock:^(id entity) {
        CdnLog *obj = (CdnLog *)entity;
        obj.cdnLog = cdnLog;
        obj.netType = [OTSClientInfo sharedInstance].nettype;
        obj.saveTime = [NSDate date];
    }];
}

/**
 *  功能:发送cdn日志
 */
- (void)sendLog {
    NSString *currentNetType = [OTSClientInfo sharedInstance].nettype;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K = %@)", @"netType", currentNetType];
    NSUInteger logCount = [self.coreDataManager countWithEntityName:[CdnLog class] Predicate:predicate];
    if (logCount >= OTS_MAX_CDN_LOG_COUNT) {
        NSString *cdnLogString = [self p_cdnLogForNetType:currentNetType];
        if (cdnLogString.length > 0) {
            //发送当前网络环境下日志
            [self p_sendLogWithLogs:@[cdnLogString]];
        }
        //删除当前网络环境下日志
        [self.coreDataManager deleteAndWaitWithEntityName:[CdnLog class] predicate:predicate deleteCount:0];
    } else {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.latestSendDate];//单位秒
        if (timeInterval > OTS_MAX_CDN_LOG_TIME) {//超过5分钟
            NSMutableArray *cdnLogArray = @[].mutableCopy;
            NSString *log2g = [self p_cdnLogForNetType:@"2g"];
            if (log2g.length > 0) {
                [cdnLogArray safeAddObject:log2g];
            }
            NSString *log3g = [self p_cdnLogForNetType:@"3g"];
            if (log3g.length > 0) {
                [cdnLogArray safeAddObject:log3g];
            }
            NSString *log4g = [self p_cdnLogForNetType:@"4g"];
            if (log4g.length > 0) {
                [cdnLogArray safeAddObject:log4g];
            }
            NSString *logWifi = [self p_cdnLogForNetType:@"wifi"];
            if (logWifi.length > 0) {
                [cdnLogArray safeAddObject:logWifi];
            }
            NSString *logWwan = [self p_cdnLogForNetType:@"wwan"];
            if (logWwan.length > 0) {
                [cdnLogArray safeAddObject:logWwan];
            }
            //发送所有网络环境下日志
            [self p_sendLogWithLogs:cdnLogArray];
            
            //删除所有网络环境下日志
            [self.coreDataManager deleteAndWaitWithEntityName:[CdnLog class] predicate:nil deleteCount:0];
        }
    }
}

/**
 *  功能:获取netType下所有日志字符串
 */
- (NSString *)p_cdnLogForNetType:(NSString *)netType {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K = %@)", @"netType", netType];
    NSArray *allCdnLogs = [self.coreDataManager fetchWithEntityName:[CdnLog class] predicate:predicate fetchLimit:0 sortDescriptors:nil];
    
    //过滤太久之前的日志
    NSMutableArray *cdnLogs = @[].mutableCopy;
    for (CdnLog *log in allCdnLogs) {
        NSTimeInterval timeInterval = [log.saveTime timeIntervalSinceNow];
        if (timeInterval>-OTS_MAX_DEL_CDN_LOG_TIME && timeInterval<0) {
            [cdnLogs safeAddObject:log];
        }
    }
    
    if (cdnLogs.count <= 0) {
        return nil;
    }
    
    //拼装日志
    CdnLogVO *cdnLogVO = [CdnLogVO new];
    NSTimeInterval dTime = [OTSGlobalValue sharedInstance].dTime;//服务器时间-本地时间
    long long serverTimeStamp = ([[NSDate date] timeIntervalSince1970]+dTime) * 1000;//精确到毫秒
    cdnLogVO.time = [NSString stringWithFormat:@"%lld", serverTimeStamp];
    NSMutableArray *allLogs = @[].mutableCopy;
    for (int i=0; i<cdnLogs.count; i++) {
        CdnLog *fetchedObj = (CdnLog*)[cdnLogs safeObjectAtIndex:i];
        NSString *oneLog = [fetchedObj cdnLog];
        if (oneLog != nil) {
            [allLogs safeAddObject:oneLog];
        }
    }
    cdnLogVO.data = allLogs;
    cdnLogVO.netType = netType;
    cdnLogVO.provinceId = [OTSCurrentAddress sharedInstance].currentProvinceId.description;
    cdnLogVO.cityId = [OTSCurrentAddress sharedInstance].currentCityId.description;
    cdnLogVO.deviceCode = [OTSClientInfo sharedInstance].deviceCode;
    cdnLogVO.clientSystem = [OTSClientInfo sharedInstance].clientSystem;
    cdnLogVO.clientSystemVersion = [OTSClientInfo sharedInstance].clientVersion;
    cdnLogVO.appVersion = [OTSClientInfo sharedInstance].clientAppVersion;
    NSString *cdnLogString = [cdnLogVO toJSONString];
    
    return cdnLogString;
}

/**
 *  功能:发送所有日志，日志用$连接
 */
- (void)p_sendLogWithLogs:(NSArray *)cdnLogs {
    NSString *cdnLogString = [cdnLogs componentsJoinedByString:@"$"];
    
    //发送日志
    NSMutableDictionary *mDict = @{}.mutableCopy;
    [mDict safeSetObject:cdnLogString forKey:@"message"];
    [mDict safeSetObject:@(1) forKey:@"type"];
    OTSOperationParam *param = [OTSOperationParam paramWithUrl:@"http://interface.m.yhd.com/mobilelog/receive.action" type:kRequestPost param:mDict callback:nil];//http://192.168.128.55:8090/mobilelog/receive.action，http://interface.m.yhd.com/mobilelog/receive.action
    param.needSignature = NO;
    [self.operationManager requestWithParam:param];
    
    //记录最新发送时间
    self.latestSendDate = [NSDate date];
}

@end
