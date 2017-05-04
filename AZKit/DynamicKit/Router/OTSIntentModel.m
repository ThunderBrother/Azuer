//
//  OTSIntentModel.m
//  OTSKit
//
//  Created by Jerry on 2016/11/25.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSIntentModel.h"
#import "NSMutableDictionary+safe.h"
#import "OTSIntentContext.h"
#import "NSString+safe.h"
#import "OTSJsonKit.h"

FOUNDATION_EXTERN NSString *const OTSSystemErrorString;
NSString const* OTSIntentParamKey = @"body";

@interface OTSIntentModel ()

@property (strong, nonatomic, nullable) id destinationValue;

@end

@implementation OTSIntentModel

+ (instancetype)routerModelWithKey:(NSString*)key
                            option:(NSUInteger)option
                              data:(NSDictionary*)extraData {
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    item.option = option;
    item.extraData = extraData;
    item.type = OTSIntentTypeRouter;
    item.key = key;
    
    return item;
}

+ (instancetype)routerModelWithDestinationClass:(Class)destinationClass
                                         option:(NSUInteger)option
                                           data:(nullable NSDictionary*)extraData {
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    item.option = option;
    item.extraData = extraData;
    item.type = OTSIntentTypeRouter;
    item.destinationValue = destinationClass;
    
    return item;
}

+ (instancetype)actionModelWithOption:(NSUInteger)option
                                data:(NSDictionary*)extraData {
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    item.option = option;
    item.extraData = extraData;
    item.type = OTSIntentTypeAction;
    
    return item;
}

+ (instancetype)actionModelWithError:(nullable NSError*)anError
                          altMessage:(nullable NSString*)alternativeMessage
                                type:(NSUInteger)actionType {
    NSString *errorMsg = alternativeMessage;
    if(!errorMsg.length && anError.localizedDescription.length){
        errorMsg = anError.localizedDescription;
    }
    
    if(!errorMsg.length){
        errorMsg = OTSSystemErrorString;
    }
    
    return [OTSIntentModel actionModelWithOption:actionType
                                            data:@{OTSIntentMessageKey:errorMsg}];
    
}

+ (instancetype)handlerModelWithKey:(NSString *)key
                              param:(NSDictionary *)param {
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    item.extraData = param;
    item.type = OTSIntentTypeHandler;
    item.key = key;
    
    return item;
}

+ (instancetype)handlerModelWithTarget:(id)target
                                action:(SEL)action
                                 param:(nullable NSDictionary*)param {
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    item.extraData = param;
    item.destinationValue = OTSCallBackDelegateMake(target, action);
    item.type = OTSIntentTypeHandler;
    
    return item;
}

+ (instancetype)modelWithUrlString:(NSString*)destinationUrlString
                             param:(nullable NSDictionary*)param {
    OTSIntentContext *context = [OTSIntentContext defaultContext];
    OTSIntentModel *item = [[OTSIntentModel alloc] init];
    
    if ([destinationUrlString hasPrefix:@"http"]) {
        item = [self routerModelWithKey:@"web" option:OTSRouterPush data:@{@"url":destinationUrlString}];
        return item;
    }
    
    NSString *urlEncodedString = [destinationUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlEncodedString];
    NSString *scheme = url.scheme;
    NSString *query = url.query;
    NSString *host = url.host;
    
    if ([scheme isEqualToString:context.routerScheme]) {
        item = [self routerModelWithKey:host option:OTSRouterPush data:param];
    } else if([scheme isEqualToString:context.handlerScheme]) {
        item = [self handlerModelWithKey:host param:param];
    } else if([scheme isEqualToString:context.actionScheme]) {
        item = [self actionModelWithOption:0 data:param];
    }
    
    if (item) {
        [item __setExtraDataByQueryString:query];
    }
    
    return item;
}

+ (instancetype)alertWithTitle:(NSString*)title
                       message:(NSString*)msg
                   cancelTitle:(NSString*)cancelTitle
                 positiveTitle:(NSString*)positiveTitle
                    eventBlock:(void (^)(NSInteger index))eventBlock {
    return [self __alertWithTitle:title message:msg cancelTitle:cancelTitle positiveTitles:(positiveTitle ? @[positiveTitle] : nil) type:OTSActionOptionShowAlert eventBlock:eventBlock];
}

+ (instancetype)actionSheetWithTitle:(nullable NSString*)title
                             message:(nullable NSString*)msg
                         cancelTitle:(nullable NSString*)cancelTitle
                      positiveTitles:(nullable NSArray<NSString*>*)positiveTitles
                          eventBlock:(nullable void (^)(NSInteger index))eventBlock {
    return [self __alertWithTitle:title message:msg cancelTitle:cancelTitle positiveTitles:positiveTitles type:OTSActionOptionShowSheet eventBlock:eventBlock];
}

#pragma mark - Private
- (void)__setExtraDataByQueryString:(NSString*)queryString {
    if (!queryString.length) {
        return;
    }
    
    NSString *jsonString = [queryString stringByRemovingPercentEncoding];
    NSMutableDictionary *dict = self.extraData.mutableCopy ?: [NSMutableDictionary dictionary];
    
    NSArray *subStrings = [jsonString componentsSeparatedByString:@"="];
    if ([OTSIntentParamKey isEqualToString:subStrings[0]]) {
        if (subStrings[1]) {
            NSRange endCharRange = [jsonString rangeOfString:@"}" options:NSBackwardsSearch];
            if (endCharRange.location != NSNotFound) {
                jsonString = [jsonString substringToIndex:endCharRange.location + 1];
            }
            NSRange range = [jsonString rangeOfString:@"="];
            //除去body＝剩下纯json格式string
            NSString *jsonStr = [jsonString substringFromIndex:range.location + 1];
            
            if ([[jsonStr safeSubstringFromIndex:(jsonStr.length - 1)] isEqualToString:@"\""]) { // 去掉末尾"号
                jsonStr = [jsonStr substringToIndex:(jsonStr.length-1)];
            }
            
            NSDictionary *resultDict = [OTSJsonKit dictFromString:jsonStr];
            dict[OTSIntentParamKey] = resultDict;
        }
    }
    
    [dict.copy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            dict[key] = [obj stringValue];
        }
    }];
    
    NSDictionary *data = dict[OTSIntentParamKey];
    if ([data isKindOfClass:[NSDictionary class]]) {
        self.extraData = data;
    }
}

+ (instancetype)__alertWithTitle:(NSString*)title
                         message:(NSString*)msg
                     cancelTitle:(NSString*)cancelTitle
                  positiveTitles:(nullable NSArray<NSString*>*)positiveTitles
                            type:(OTSActionOption)type
                      eventBlock:(void (^)(NSInteger index))eventBlock {
    
    NSMutableDictionary *extraData = [NSMutableDictionary dictionary];
    [extraData safeSetObject:title forKey:OTSIntentTitleKey];
    [extraData safeSetObject:msg forKey:OTSIntentMessageKey];
    [extraData safeSetObject:cancelTitle forKey:OTSActionCancelTitleKey];
    [extraData safeSetObject:positiveTitles forKey:OTSActionValues];
    [extraData safeSetObject:eventBlock forKey:OTSActionEventBlockKey];
    
    return [OTSIntentModel actionModelWithOption:type
                                            data:extraData.copy];
}

@end
