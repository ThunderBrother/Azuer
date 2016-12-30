//
//  JWHandler.h
//  JWIntent
//
//  Created by Jerry on 16/7/20.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSIntent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSHandler : OTSIntent

@property (strong, nonatomic) NSString *handlerKey;
@property (strong, nonatomic, readonly) id<OTSCallBack> destination;

/**
 *  Init function.
 *
 *  @param handlerKey     used to create destination handler stored in context
 *
 */
- (instancetype)initWithHandlerKey:(NSString*)handlerKey;

/**
 *  Init function.
 *
 *  @param handlerKey     used to create destination handler stored in context
 *  @param context        if NULL, will use default context
 *
 */
- (instancetype)initWithHandlerKey:(NSString*)handlerKey
                           context:(nullable OTSIntentContext*)context;

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action;

- (instancetype)initWithBlock:(void (^)(NSDictionary *_Nullable param)) block;

@end

NS_ASSUME_NONNULL_END
