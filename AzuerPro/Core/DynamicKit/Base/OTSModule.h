//
//  OTSModule.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSModule : NSObject

@property (assign, nonatomic, readonly) BOOL mounted;

- (void)mountSubModule:(__kindof OTSModule*)aModule
                forKey:(NSString*)key;

- (__kindof  OTSModule* _Nullable)unmountSubModuleForKey:(NSString*)key;

- (__kindof OTSModule* _Nullable)subModuleForKey:(NSString*)key;

- (void)moduleDidMount;//subclass should call super
- (void)moduleDidUnmount;//subclass should call super

@end

@interface NSObject (OTSModuleUtility)

+ (__kindof OTSModule*)mainModule;
+ (__kindof  OTSModule* _Nullable )subModuleForKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
