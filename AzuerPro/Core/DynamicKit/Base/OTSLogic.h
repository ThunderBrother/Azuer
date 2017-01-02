//
//  OTSLogic.h
//  OneStoreFramework
//
//  Created by Aimy on 14-6-24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OTSKit/OTSKit.h>
#import <KVOController/KVOController.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSLogic : NSObject {
    OTSOperationManager *_operationManager;
    OTSIntentModel *_intentModel;
    __weak id _owner;
}

@property (strong, nonatomic, readonly) OTSOperationManager *operationManager;
@property (strong, nonatomic) OTSIntentModel *intentModel;
@property (assign, nonatomic) BOOL loading;

- (instancetype)initWithOwner:(id)owner NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
