//
//  OTSNetworkManager.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
//category
#import "NSMutableArray+safe.h"
//network
#import "OTSOperationManager.h"

@interface OTSOperationManager()

#pragma mark - Token Expire
/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForTokenExpire;

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForTokenExpire;

#pragma mark - Sign Key Expire
/**
 *  功能:获取密钥接口成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForSignKeyExpire;

/**
 *  功能:获取密钥接口失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForSignKeyExpire;

#pragma mark - Launch Fail
/**
 *  功能:relaunch成功后执行所有暂存的operation
 */
- (void)performCachedOperationsForLaunchFail;

/**
 *  功能:relaunch失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForLaunchFail;

#pragma mark - Server Error
/**
 *  功能:服务器错误时将operation暂存
 */
- (void)cacheOperationForServerError:(OTSOperationParam *)aParam;

/**
 *  功能:服务器错误更换ip后执行所有暂存的operation
 */
- (void)performCachedOperationsForServerError;

/**
 *  功能:更换ip仍然失败后清除所有暂存的operation
 */
- (void)clearCachedOperationsForServerError;

@end

@interface OTSNetworkManager()

@property(nonatomic, strong) NSMutableArray *operationManagers;

@end

@implementation OTSNetworkManager

DEF_SINGLETON(OTSNetworkManager)

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (NSMutableArray *)operationManagers
{
    if (_operationManagers == nil) {
        _operationManagers = [NSMutableArray array];
    }
    
    return _operationManagers;
}

/**
 *  功能:产生一个operation manager
 */
- (OTSOperationManager *)generateOperationManagerWithOwner:(id)owner
{
    OTSOperationManager *operationManager = [OTSOperationManager managerWithOwner:owner];
    [self.operationManagers safeAddObject:operationManager];
    
    return operationManager;
}

/**
 *  功能:移除operation manager
 */
- (void)removeOperationManager:(OTSOperationManager *)aOperationManager
{
    [self.operationManagers removeObject:aOperationManager];
}

/**
 *  功能:取消所有operation
 */
- (void)cancelAllOperations
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *operationManager in copyArray) {
        [operationManager.tasks makeObjectsPerformSelector:@selector(cancel)];
        [self.operationManagers removeObject:operationManager];
    }
}

#pragma mark - Token Expire
/**
 *  功能:登录成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForTokenExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager performCachedOperationsForTokenExpire];
    }
}

/**
 *  功能:登录失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForTokenExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForTokenExpire];
    }
}

#pragma mark - Sign Key Expire
/**
 *  功能:获取密钥成功后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForSignKeyExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager performCachedOperationsForSignKeyExpire];
    }
}

/**
 *  功能:获取密钥失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForSignKeyExpire
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForSignKeyExpire];
    }
}

#pragma mark - Launch Fail
/**
 *  功能:执行所有暂存的operation
 */
- (void)performAllCachedOperationsForLaunchFail
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager performCachedOperationsForLaunchFail];
    }
}

/**
 *  功能:清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForLaunchFail
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForLaunchFail];
    }
}

#pragma mark - Server Error
/**
 *  功能:更换ip后执行所有暂存的operation
 */
- (void)performAllCachedOperationsForServerError
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager performCachedOperationsForServerError];
    }
}

/**
 *  功能:更换ip仍然失败后清除所有暂存的operation
 */
- (void)clearAllCachedOperationsForServerError
{
    NSArray *copyArray = self.operationManagers.copy;
    for (OTSOperationManager *manager in copyArray) {
        [manager clearCachedOperationsForServerError];
    }
}

@end
