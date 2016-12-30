//
//  JWHandler.m
//  JWIntent
//
//  Created by Jerry on 16/7/20.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSHandler.h"

@implementation OTSHandler

- (instancetype)initWithHandlerKey:(NSString*)handlerKey {
    return [self initWithHandlerKey:handlerKey context:nil];
}

- (instancetype)initWithHandlerKey:(NSString*)handlerKey
                           context:(nullable OTSIntentContext*)context {
    NSParameterAssert(handlerKey);
    if (self = [super init]) {
        _context = context ?: [OTSIntentContext defaultContext];
        self.handlerKey = handlerKey;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action {
    if (self = [super init]) {
        _destination = OTSCallBackDelegateMake(target, action);
    }
    return self;
}

- (instancetype)initWithBlock:(void (^)(NSDictionary *_Nullable param)) block {
    if (self = [super init]) {
        _destination = OTSCallBackBlockMake(block);
    }
    return self;
}

- (void)submitWithCompletion:(void (^)(void))completion {
    [super submitWithCompletion:completion];
    
    id<OTSCallBack> callBack = self.destination;
    if (callBack) {
        [callBack excuteWithParam:self.extraData];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Getter & Setter
- (id<OTSCallBack>)destination {
    if (!_destination) {
        _destination = [self.context handlerForKey:self.handlerKey];
    }
    return _destination;
}

@end
