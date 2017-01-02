//
//  OTSHtmlLog.h
//  OneStoreNetwork
//
//  Created by huangjiming on 5/11/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "AZFuncDefine.h"

FOUNDATION_EXTERN NSString *const OTS_SEND_HTML_LOG;

@interface OTSHtmlLog : NSObject

AS_SINGLETON(OTSHtmlLog)

@property(nonatomic, assign) BOOL needSendHtmlLog;//是否需要发送html日志
@property(nonatomic, copy) NSString *jsCode;//接口返回的js代码

/**
 *  功能:根据接口功能开关处理
 */
- (void)dealWithFuncSwitch:(NSDictionary *)aFuncSwitchDict;

@end
