//
//  OTSDynamicLogic.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicLogic.h"
#import "AZFuncDefine.h"
#import "OTSIntentModel.h"
#import "OTSOperationManager.h"
#import "OTSJSBridge.h"
#import "NSMutableArray+safe.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface OTSDynamicLogic()

@property (strong, nonatomic) JSContext *jsCtx;
@property (strong, nonatomic) OTSJSBridge *bridge;

@end

@implementation OTSDynamicLogic

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self->_owner respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self->_owner respondsToSelector:aSelector]) {
        return self->_owner;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)exeJS:(NSString*)jsString {
    [self.jsCtx evaluateScript:jsString];
}

- (void)setValueForJSRawData:(NSDictionary*)rawData {
    NSString *key = rawData[@"key"];
    NSString *className = rawData[@"class"];
    Class dataClass = NSClassFromString(className);
    if (![dataClass isSubclassOfClass:[OTSCodingObject class]]) {
        return;
    }
    
    NSString *setterKey = key;
    if (setterKey.length >= 1) {
        NSString *firstLetter = [setterKey substringToIndex:1];
        setterKey = [setterKey stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter uppercaseString]];
    }
    
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", setterKey]);
    if (![self respondsToSelector:setter]) {
        return;
    }
    
    NSArray *dataArray = rawData[@"dataArray"];
    NSDictionary *dataDict = rawData[@"dataDict"];
    
    id value = nil;
    if (dataArray) {
        NSMutableArray *nativeArray = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            [nativeArray safeAddObject:[[dataClass alloc] initWithDictionary:dict]];
        }
        value = nativeArray.copy;
    } else if (dataDict) {
        value = [[dataClass alloc] initWithDictionary:dataDict];
    }
    
    [self setValue:value forKey:key];
}

#pragma mark - Getter & Setter
- (OTSJSBridge*)bridge {
    if (!_bridge) {
        _bridge = [[OTSJSBridge alloc] initWithOperationManager:self.operationManager];
        WEAK_SELF;
        [OTSObserve(_bridge, intentModel) {
            STRONG_SELF;
            OTSNullReturn(NSKeyValueChangeNewKey);
            self.intentModel = change[NSKeyValueChangeNewKey];
        }];
        
        [OTSObserve(_bridge, jsDataDict) {
            STRONG_SELF;
            OTSNullReturn(NSKeyValueChangeNewKey);
            
            NSDictionary *rawData = change[NSKeyValueChangeNewKey];
            [self setValueForJSRawData:rawData];
            
        }];
        
        [OTSObserve(_bridge, jsDataArray) {
            STRONG_SELF;
            OTSNullReturn(NSKeyValueChangeNewKey);
            
            NSArray *rawDataArray = change[NSKeyValueChangeNewKey];
            for (NSDictionary *rawData in rawDataArray) {
                [self setValueForJSRawData:rawData];
            }
        }];
        
        
    }
    return _bridge;
}

- (JSContext*)jsCtx {
    if (!_jsCtx) {
        _jsCtx = [[JSContext alloc] init];
        _jsCtx[@"bridge"] = self.bridge;
    }
    return _jsCtx;
}

@end
