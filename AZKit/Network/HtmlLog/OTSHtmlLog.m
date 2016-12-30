//
//  OTSHtmlLog.m
//  OneStoreNetwork
//
//  Created by huangjiming on 5/11/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "OTSHtmlLog.h"
//category
#import "NSMutableDictionary+safe.h"
//net
#import "OTSOperationParam.h"
#import "OTSOperationManager.h"
#import "OTSNetworkManager.h"
//vo
#import "HtmlLogVO.h"
//object
#import "OTSClientInfo.h"
#import "NSNotificationCenter+RACSupport.h"

NSString *const OTS_SEND_HTML_LOG = @"OTS_SEND_HTML_LOG";

@interface OTSHtmlLog ()

@property(nonatomic, strong) OTSOperationManager *operationManager;

@end

@implementation OTSHtmlLog

DEF_SINGLETON(OTSHtmlLog)

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        WEAK_SELF;
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:OTS_SEND_HTML_LOG object:nil] subscribeNext:^(id x) {
            STRONG_SELF;
            
            if (self.needSendHtmlLog) {
                NSNotification *notification = x;
                UIWebView *webView = notification.object;
                NSString *urlStr = webView.request.URL.absoluteString;
                NSString *htmlStr = [webView stringByEvaluatingJavaScriptFromString:self.jsCode];
                [self sendHtmlLog:htmlStr withUrl:urlStr];
            }
        }];
    }
    return self;
}

#pragma mark - Property
- (NSString *)jsCode
{
    if (_jsCode == nil) {
        _jsCode = @"var elements = document.documentElement.getElementsByTagName('iframe');var elementsStr = '';for (var i=0; i<elements.length; i++) {var elementStr = elements[i].outerHTML;elementsStr = elementsStr + elementStr;}elementsStr;";
    }
    
    return _jsCode;
}

- (OTSOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [[OTSNetworkManager sharedInstance] generateOperationManagerWithOwner:self];
    }
    
    return _operationManager;
}

#pragma mark - API
/**
 *  功能:根据接口功能开关处理
 */
- (void)dealWithFuncSwitch:(NSDictionary *)aFuncSwitchDict
{
    NSDictionary *switchDict = [aFuncSwitchDict[@"XPath_IOS"] toDictionary];
    if (switchDict != nil) {
        self.needSendHtmlLog = [switchDict[@"functionSwitch"] boolValue];
        self.jsCode = switchDict[@"functionValue"];
    }
}

/**
 *  功能:发送html日志
 */
- (void)sendHtmlLog:(NSString *)aHtmlLog
            withUrl:(NSString *)aUrl
{
    if (aHtmlLog.length <= 0) {
        return;
    }
    
    //发送日志
    HtmlLogVO *vo = [HtmlLogVO new];
    vo.xpath = aHtmlLog;
    vo.cmsurl = aUrl;
    
    OTSOperationParam *param = [OTSOperationParam paramWithUrl:@"http://interface.m.yhd.com/mobilelog/dnsReceive.action" type:kRequestPost param:vo.toDictionary callback:nil];
    param.needSignature = NO;//http://interface.m.yhd.com/mobilelog/dnsReceive.action，http://192.168.128.55:8090/mobilelog/dnsReceive.action
    [self.operationManager requestWithParam:param];
}

@end
