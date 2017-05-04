//
//  OTSLogic.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSLogic.h"
#import "OTSOperationManager.h"
#import "OTSNetworkManager.h"
#import "AZFuncDefine.h"
#import "OTSLog.h"
#import "NSObject+Notification.h"

@implementation OTSLogic

- (instancetype)initWithOwner:(id)owner {
    if (self = [super init]) {
        OTSOperationManager *aOperationManager = [[OTSNetworkManager sharedInstance] generateOperationManagerWithOwner:owner];
        self->_operationManager = aOperationManager;
        self->_owner = owner;
        
        self.loading = NO;
    }
    return self;
}

- (void)dealloc {
    OTSLogFuncW;
    [self unobserveAllNotifications];
}

@end
