//
//  OTSNetworkManager.h
//  OneStoreFramework
//  功能:网络管理
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
//define
#import "OTSFuncDefine.h"

@class OTSOperationManager;

@interface OTSNetworkManager : NSObject

AS_SINGLETON(OTSNetworkManager)

@property (copy, nonatomic) NSString* (^encryptByAESKey)(NSString *input, NSString *key);

/**
 *  功能:产生一个operation manager,当owner销毁的时候一并销毁OTSOperationManager
 */
- (OTSOperationManager *)generateOperationManagerWithOwner:(id)owner;

/**
 *  功能:移除operation manager
 */
- (void)removeOperationManager:(OTSOperationManager *)aOperationManager;

@end
