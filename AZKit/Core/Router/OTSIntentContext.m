//
//  JWIntentContext.m
//  JWIntentDemo
//
//  Created by Jerry on 16/5/10.
//  copyright (c) 2016 Jerry Wong jerrywong0523@icloud.com
//

#import "OTSIntentContext.h"
//#import <libkern/OSAtomic.h>
#import "OTSWeakObjectDeathNotifier.h"
#import "OTSFuncDefine.h"
#import "NSObject+Runtime.h"

@implementation OTSIntentContext {
    NSMutableDictionary *_handlerDict;
    NSMutableDictionary *_routerDict;
    dispatch_queue_t _innerQueue;
}

/*
static void ots_performLocked(dispatch_block_t block) {
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}
*/

+ (instancetype) defaultContext {
    static dispatch_once_t once;
    static OTSIntentContext * _singleton;
    dispatch_once(&once, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (instancetype)init {
    if (self = [super init]) {
        _innerQueue = dispatch_queue_create("com.ots.intentContext", DISPATCH_QUEUE_SERIAL);
        
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        _routerScheme = [NSString stringWithFormat:@"%@.router", bundleIdentifier];;
        _handlerScheme = [NSString stringWithFormat:@"%@.func", bundleIdentifier];
        _actionScheme = [NSString stringWithFormat:@"%@.action", bundleIdentifier];
        
        _routerDict = [NSMutableDictionary dictionary];
        _handlerDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerHandlerForTarget:(id)target
                        selector:(SEL)action
                          forKey:(NSString*)key {
    NSParameterAssert(target);
    NSParameterAssert(action);
    NSParameterAssert([target respondsToSelector:action]);
    NSParameterAssert(key);
    
    dispatch_async(_innerQueue, ^{
        [_handlerDict setObject:OTSCallBackDelegateMake(target, action) forKey:key];
        OTSWeakObjectDeathNotifier *deadNotifier = [[OTSWeakObjectDeathNotifier alloc] init];
        deadNotifier.owner = target;
        WEAK_SELF;
        [deadNotifier setBlock:^(OTSWeakObjectDeathNotifier *sender) {
            STRONG_SELF;
            [self unRegisterHandlerForKey:key];
        }];
    });
}

- (void)registerHandlerForBlock:(void (^)(NSDictionary *param))block
                         andKey:(NSString*)key {
    NSParameterAssert(block);
    NSParameterAssert(key);
    
    dispatch_async(_innerQueue, ^{
        [_handlerDict setObject:OTSCallBackBlockMake(block) forKey:key];
    });
}

- (void)unRegisterHandlerForKey:(NSString*)key {
    NSParameterAssert(key.length);
    dispatch_async(_innerQueue, ^{
        [_handlerDict removeObjectForKey:key];
    });
}

- (id<OTSCallBack>)handlerForKey:(NSString *)key {
    NSParameterAssert(key.length);
    __block id<OTSCallBack> aHandler;
    dispatch_sync(_innerQueue, ^{
        aHandler = [_handlerDict objectForKey:key];
    });
    return aHandler;
}

- (void)registerRouterClass:(Class)aClass
                     forKey:(NSString*)key {
    NSParameterAssert(aClass);
    NSParameterAssert(key.length);
    dispatch_async(_innerQueue, ^{
        [_routerDict setObject:aClass forKey:key];
    });
}

- (void)unRegisterRouterClassForKey:(NSString*)key {
    NSParameterAssert(key.length);
    dispatch_async(_innerQueue, ^{
        [_routerDict removeObjectForKey:key];
    });
}

- (Class)routerClassForKey:(NSString*)key {
    NSParameterAssert(key.length);
    __block Class aClass;
    dispatch_sync(_innerQueue, ^{
        aClass = [_routerDict objectForKey:key];
    });
   return aClass;
}

@end

@implementation OTSCallBackDelegate

- (void)excuteWithParam:(NSDictionary*)extraData {
    NSParameterAssert(self.target);
    NSParameterAssert(self.action);
    
    if ([self.target respondsToSelector:self.action]) {
        OTSSuppressPerformSelectorLeakWarning (
                                               [self.target performSelector:self.action withObject:extraData];
                                               );
    }
}

@end

@implementation OTSCallBackBlock

- (void)excuteWithParam:(NSDictionary *)extraData {
    NSParameterAssert(self.block);
    self.block(extraData);
}

@end

@implementation NSObject (ExtraData)

- (void)setExtraData:(NSDictionary*)extraData {
    if ([extraData isKindOfClass:[NSDictionary class]]) {
        [extraData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *keyDescription = [key description];
            NSString *setterKey = keyDescription;
            if (keyDescription.length >= 1) {
                NSString *firstLetter = [keyDescription substringToIndex:1];
                setterKey = [keyDescription stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter uppercaseString]];
            }
            SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", setterKey]);
            if ([self respondsToSelector:setter]) {
                [self setValue:obj forKey:keyDescription];
                
//                IMP imp = [self methodForSelector:setter];
//                void (*setterFunc)(id, SEL, id) = (void *)imp;
//                setterFunc(self, setter, obj);
            }
        }];
        
        if (extraData.count) {
            [self objc_setAssociatedObject:@"ots_extraData" value:extraData policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        }
    }
}

- (NSDictionary*)extraData {
    return [self objc_getAssociatedObject:@"ots_extraData"];
}

@end
