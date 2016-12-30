//
//  OTSOperationManager.h
//  OneStoreFramework
//  功能:重写AFHTTPSessionManager
//  Created by huang jiming on 14-7-22.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "OTSOperationParam.h"
#import "OTSBatchOperaionParam.h"
#import <ReactiveCocoa/RACSignal.h>

FOUNDATION_EXTERN NSString *const OTSSystemErrorString;

@interface OTSOperationManager : AFHTTPSessionManager

/**
 *  初始化函数,宿主owner
 */
+ (instancetype)managerWithOwner:(id)owner;

/**
 *  功能:发送请求
 */
- (NSURLSessionDataTask *)requestWithParam:(OTSOperationParam *)aParam;

/**
 *  发送网络请求，创建信号
 *
 */
- (RACSignal *)rac_requestWithParam:(OTSOperationParam *)aParam;

/**
 *  功能:取消当前manager queue中所有网络请求
 */
- (void)cancelAllOperations;

@end
