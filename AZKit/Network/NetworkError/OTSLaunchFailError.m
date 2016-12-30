//
//  OTSLaunchFailError.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-8-7.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSLaunchFailError.h"
#import "OTSNetworkManager.h"
//define
#import "OTSFuncDefine.h"
//network
#import "OTSOperationManager.h"

@interface OTSOperationParam ()

@property(nonatomic, assign) BOOL rerunForLaunchFail;                   //是否重新调用启动接口后再次执行，默认为NO

@end

@interface OTSOperationManager()

/**
 *  功能:launch接口调用失败时将operation暂存
 */
- (void)cacheOperationForLaunchFail:(OTSOperationParam *)aParam;

@end

@interface OTSNetworkManager()

/**
 *  功能:relaunch成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForLaunchFail;

/**
 *  功能:relaunch失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForLaunchFail;

@end

@implementation OTSLaunchFailError

DEF_SINGLETON(OTSLaunchFailError)

/**
 *  功能:启动接口调用失败的错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(OTSOperationManager *)aManager
                  param:(OTSOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    if (aParam.rerunForLaunchFail) {
        return YES;
    }
    
    [aManager cacheOperationForLaunchFail:aParam];
    
    if (!self.handling && self.errorHandleBlock != nil) {
        self.handling = YES;
        WEAK_SELF;
        self.errorHandleBlock(^(BOOL success) {
            STRONG_SELF;
            self.handling = NO;
            if (success) {
                [[OTSNetworkManager sharedInstance] performAllCachedOperationsForLaunchFail];
            } else {
                [[OTSNetworkManager sharedInstance] clearAllCachedOperationsForLaunchFail];
            }
        });
    }
    
    return NO;
}

@end
