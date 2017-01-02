//
//  OTSLaunchLogic.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSLogic.h"

@interface OTSLaunchLogic : OTSLogic

- (void)dealWithCachedData;

- (void)registNetworkHandler;

- (void)getSecretKeyWithHandler:(OTSErrorHandleCompleteBlock)handler;

@end
