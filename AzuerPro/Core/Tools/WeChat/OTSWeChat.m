//
//  PhoneWeChat.m
//  OneStoreMain
//
//  Created by 黄吉明 on 10/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSWeChat.h"
#import "WXApi.h"

#define SharedWeixinAppID @""

NSString *const NotificationWeichatPay = @"notification.weixin.pay";
NSString *const NotificationWeichatShare = @"notification.weixin.share";
//NSString *const NotificationWeichatLogin = @"notification.passport.unionlogin.weichat";
//NSString *const OTS_MANUAL_WECHAT_LOGIN = @"notification.passport.unionlogin.weichat";

@interface OTSWeChat()<WXApiDelegate>

@property(nonatomic, copy) OTSWeChatRespBlock payResultBlock;

@end

@implementation OTSWeChat

DEF_SINGLETON(OTSWeChat)

#pragma mark - API
/**
 *  功能:微信注册1号店app
 */
- (BOOL)registeWithAppId:(NSString*)appID {
    if(!appID)
        appID = SharedWeixinAppID;
    return [WXApi registerApp:appID withDescription:@"YHD"];
}

/**
 *  功能:处理从微信打开的url
 */
- (BOOL)handleOpenURLFromWeChat:(NSURL *)aUrl
{
    return [WXApi handleOpenURL:aUrl delegate:self];
}

#pragma mark - WXApiDelegate

/**
 *  功能:从微信直接调用1号店时，调用的API
 */
- (void)onReq:(BaseReq *)req {
    // TODO: ...
}

/**
 *  功能:一号店发送信息到微信,微信返回时调用API
 */
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) { // 微信登录
        SendAuthResp *authResp = (SendAuthResp*)resp;
        [self postNotification:OTS_MANUAL_WECHAT_LOGIN withObject:authResp];
    } else if ([resp isKindOfClass:[PayResp class]]) { //  微信支付
        if (self.payResultBlock) {
            self.payResultBlock(resp, nil);
        }
        [self postNotification:NotificationWeichatPay withObject:resp];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) { // 微信分享
        [self postNotification:NotificationWeichatShare withObject:resp];
    }
}

#pragma mark -wechatpay
- (void)payWithInfo:(NSDictionary *)payInfo compelet:(OTSWeChatRespBlock)block {
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = payInfo[@"partnerid"];
    request.prepayId= payInfo[@"prepayid"];
    request.package = payInfo[@"package"];
    request.nonceStr = payInfo[@"noncestr"];
    request.timeStamp = [payInfo[@"timestamp"] unsignedIntValue];
    request.sign = payInfo[@"sign"];
    [WXApi safeSendReq:request];
    self.payResultBlock = block;
}

@end
