//
//  OTSNetworkError.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-8-4.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSNetworkError.h"
#import "OTSNetworkManager.h"
//network
#import "OTSOperationManager.h"

@implementation OTSNetworkError

/**
 *  功能:错误处理
 *  返回:是否需要继续执行call back
 */
- (BOOL)dealWithManager:(OTSOperationManager *)aManager
                  param:(OTSOperationParam *)aParam
              operation:(NSURLSessionDataTask *)aOperation
         responseObject:(id)aResponseObject
                  error:(NSError *)aError
{
    return YES;
}

@end
