//
//  OTSJSBridge.m
//  OTSKit
//
//  Created by Jerry on 2017/2/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSJSBridge.h"
#import "OTSOperationManager.h"
#import "OTSIntentModel.h"

@implementation OTSJSBridge {
    OTSOperationManager *_manager;
}

@synthesize intentModel;

NS_INLINE NSString* OTSConvertedJSString(NSString *rawString) {
    if ([rawString isEqualToString:@"undefined"] || [rawString isEqualToString:@"null"]) {
        return nil;
    }
    return rawString;
}

- (instancetype)initWithOperationManager:(OTSOperationManager*)operationManager {
    if (self = [super init]) {
        _manager = operationManager;
    }
    return self;
}

- (void)setIntentModelDict:(NSDictionary*)dict {
    if (dict) {
        self.intentModel = [[OTSIntentModel alloc] initWithDictionary:dict];
    }
}

- (void)sendDataDict:(NSDictionary *)dict {
    if (dict) {
        self.jsDataDict = dict;
    }
}

- (void)sendDataArray:(NSArray<NSDictionary*>*)array {
    if (array) {
        self.jsDataArray = array;
    }
}

- (void)showToast:(NSString*)toast {
    self.intentModel = [OTSIntentModel actionModelWithOption:OTSActionOptionShowToast data:@{OTSIntentMessageKey: OTSConvertedJSString(toast) ?: OTSSystemErrorString}];
}

- (void)showLoading: (NSString*)msg {
    self.intentModel = [OTSIntentModel actionModelWithOption:OTSActionOptionShowLoading data:(OTSConvertedJSString(msg) ? @{OTSIntentMessageKey: msg} : nil)];
}

- (void)hideLoading {
    self.intentModel = [OTSIntentModel actionModelWithOption:OTSActionOptionHideLoading data:nil];
}

- (void)showAlertWith:(NSString *)title
              message:(NSString *)msg
          cancelTitle:(NSString *)cancelTitle
        positiveTitle:(NSString *)positiveTitle
           eventBlock:(JSValue*)event {
    self.intentModel = [OTSIntentModel alertWithTitle:OTSConvertedJSString(title) message:OTSConvertedJSString(msg) cancelTitle:OTSConvertedJSString(cancelTitle) positiveTitle:OTSConvertedJSString(positiveTitle) eventBlock:^(NSInteger index) {
        [event callWithArguments:@[@(index)]];
    }];
}

- (void)showSheetWith:(NSString *)title
              message:(NSString *)msg
          cancelTitle:(NSString *)cancelTitle
       positiveTitles:(NSArray<NSString*>*)positiveTitles
           eventBlock:(JSValue*)event {
    self.intentModel = [OTSIntentModel actionSheetWithTitle:OTSConvertedJSString(title) message:OTSConvertedJSString(msg) cancelTitle:OTSConvertedJSString(cancelTitle) positiveTitles:positiveTitles eventBlock:^(NSInteger index) {
        [event callWithArguments:@[@(index)]];
    }];
}

- (void)postWithBusinessName:(NSString*)businessName
                  methodName:(NSString*)methodName
                       param:(NSDictionary*)param
                    callBack:(JSValue*)callBack {
    
    
    OTSCompletionBlock resultCallBlock = ^(id aResponseObject, NSError *anError) {
        [callBack callWithArguments:@[aResponseObject ?: @{}, anError ?: @{}]];
    };
    
    OTSOperationParam *operationParam = [OTSOperationParam paramWithBusinessName:OTSConvertedJSString(businessName)
                                                                      methodName:OTSConvertedJSString(methodName)
                                                                      versionNum:nil
                                                                            type:kRequestPost
                                                                           param:param
                                                                        callback:resultCallBlock];
    [_manager requestWithParam:operationParam];
}

@end
