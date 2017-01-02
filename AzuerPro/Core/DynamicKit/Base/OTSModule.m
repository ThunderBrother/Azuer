//
//  OTSModule.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSModule.h"
#import <UIKit/UIApplication.h>

@interface OTSModule()

@property (strong, nonatomic) NSMutableDictionary<NSString*, __kindof OTSModule*> *subModuleDict;

@end

@implementation OTSModule {
    dispatch_semaphore_t _ioSemaphore;
}

- (instancetype)init {
    if (self = [super init]) {
        _ioSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)mountSubModule:(__kindof OTSModule*)aModule
                forKey:(NSString*)key {
    
    NSAssert(aModule, @"trying to mount nil subModule");
    NSAssert(key.length, @"trying to mount subModule %@ for nil key", aModule.class);
    
    dispatch_semaphore_wait(_ioSemaphore, DISPATCH_TIME_FOREVER);
    
    __kindof OTSModule* existModule = [self.subModuleDict valueForKey:key];
    if (existModule) {
        [existModule moduleDidUnmount];
    }
    [self.subModuleDict setObject:aModule forKey:key];
    [aModule moduleDidMount];
    
    dispatch_semaphore_signal(_ioSemaphore);
}

- (__kindof OTSModule*)unmountSubModuleForKey:(NSString*)key {
    NSAssert(key.length, @"trying to unmount subModule for nil key");
    
    dispatch_semaphore_wait(_ioSemaphore, DISPATCH_TIME_FOREVER);
    
    __kindof OTSModule* existModule = [self.subModuleDict valueForKey:key];
    if (existModule) {
        [existModule moduleDidUnmount];
        [self.subModuleDict removeObjectForKey:key];
    }
    dispatch_semaphore_signal(_ioSemaphore);
    
    return existModule;
}

- (__kindof OTSModule*)subModuleForKey:(NSString*)key {
    NSAssert(key.length, @"trying to get subModule for nil key");
    
    dispatch_semaphore_wait(_ioSemaphore, DISPATCH_TIME_FOREVER);
    __kindof OTSModule* existModule = [self.subModuleDict valueForKey:key];
    dispatch_semaphore_signal(_ioSemaphore);
    
    return existModule;
}

- (void)moduleDidMount {
    _mounted = true;
}

- (void)moduleDidUnmount {
    _mounted = false;
    for (__kindof OTSModule *aModule in _subModuleDict.allValues) {
        [aModule moduleDidUnmount];
    }
}

#pragma mark - Getter & Setter
- (NSMutableDictionary<NSString*, __kindof OTSModule*> *)subModuleDict {
    if (!_subModuleDict) {
        _subModuleDict = [NSMutableDictionary dictionary];
    }
    return _subModuleDict;
}

@end


@implementation NSObject (OTSModuleUtility)

+ (__kindof OTSModule*)mainModule {
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    return [((NSObject*)sharedApplication.delegate) valueForKey:@"launchModule"];
}

+ (__kindof OTSModule*)subModuleForKey:(NSString *)key {
    return [[self mainModule] subModuleForKey:key];
}

@end
