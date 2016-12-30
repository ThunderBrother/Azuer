//
//  JWIntentContext.h
//  JWIntentDemo
//
//  Created by Jerry on 16/5/10.
//  copyright (c) 2016 Jerry Wong jerrywong0523@icloud.com
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OTSCallBack <NSObject>

- (void)excuteWithParam:(NSDictionary*)extraData;

@end

@interface OTSIntentContext : NSObject

@property (strong, nonatomic) NSString *routerScheme;//default is app bundleDentifier append string ".router"
@property (strong, nonatomic) NSString *handlerScheme;//default is app bundleDentifier append string ".func"
@property (strong, nonatomic) NSString *actionScheme;//default is app bundleDentifier append string ".action"

/**
 *  singleton
 *
 */
+ (instancetype) defaultContext;

@end

@interface OTSIntentContext(Handler)

/**
 * register handler with target and action
 *
 *
 */
- (void)registerHandlerForTarget:(id)target
                        selector:(SEL)action
                          forKey:(NSString*)key;

/**
 * register handler with block
 *
 *
 */
- (void)registerHandlerForBlock:(void (^)(NSDictionary *param))block
                         andKey:(NSString*)key;

/**
 *  unregister handler with key
 *
 *
 */
- (void)unRegisterHandlerForKey:(NSString*)key;

/**
 *  get handler with key
 *
 *
 */
- ( id<OTSCallBack> _Nullable )handlerForKey:(NSString*)key;

@end

@interface OTSIntentContext(Router)

/**
 *  register view controller class so that we can router to it
 *
 *  @param aClass UIViewController subclass
 *
 */
- (void)registerRouterClass:(Class)aClass
                     forKey:(NSString*)key;

/**
 *  unregister router with key
 *
 *
 */
- (void)unRegisterRouterClassForKey:(NSString*)key;

/**
 *  get uiviewcontroller class with key
 *
 *
 */
- (_Nullable Class)routerClassForKey:(NSString*)key;

@end

@interface OTSCallBackDelegate : NSObject<OTSCallBack>

@property(nullable, nonatomic, weak) id target;
@property(nullable, nonatomic) SEL action;

@end

@interface OTSCallBackBlock : NSObject<OTSCallBack>

@property (nullable, nonatomic, copy) void (^block)(NSDictionary *_Nullable param);

@end

NS_INLINE OTSCallBackDelegate* OTSCallBackDelegateMake(id target, SEL action) {
    OTSCallBackDelegate *callback = [[OTSCallBackDelegate alloc] init];
    callback.target = target;
    callback.action = action;
    return callback;
}

NS_INLINE OTSCallBackBlock* OTSCallBackBlockMake(void (^block)(NSDictionary *_Nullable param)) {
    OTSCallBackBlock *callback = [[OTSCallBackBlock alloc] init];
    callback.block = block;
    return callback;
}

@interface NSObject (ExtraData)

@property (strong, nonatomic, nullable) NSDictionary *extraData;

@end

NS_ASSUME_NONNULL_END
