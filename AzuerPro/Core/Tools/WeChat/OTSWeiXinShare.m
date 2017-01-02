//
//  OTSWeiXinShare.m
//  OneStore
//
//  Created by airspuer on 13-12-31.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//
#import "OTSWeiXinShare.h"

@interface OTSWeiXinShare()

@property(nonatomic, strong) OTSAlertView *safeAlertView;

@end

@implementation OTSWeiXinShare
DEF_SINGLETON(OTSWeiXinShare);

- (WeixinStatus)checkingWeiXinStatus
{
	WeixinStatus status = [self  weixinPublishStatus];
	if (status != WeixinStatusSuccess) {
		[[OTSAlertView alertWithTitle:@"Tips" message:@"Wechat is not found, would you like to download and install Wechat?" leftBtn:@"No" rightBtn:@"Yes" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {

			if (buttonIndex == 1) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
			}

		}] show];
	}
	return status;
}

- (SendMessageToWXReq *)respWithText:(NSString*)aText
{
	SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = aText;
    req.bText = YES;
	return req;
}

- (void)sendTextContentWithText:(NSString*)aText
{
	if ([self  checkingWeiXinStatus] != WeixinStatusSuccess) {
		return;
	}

	SendMessageToWXReq *req = [self  respWithText:aText];
    [WXApi sendReq:req];
}

- (void)sendTextContentWithText:(NSString *)aText
					  withScene:(enum WXScene)aScene
{
	if ([self checkingWeiXinStatus] != WeixinStatusSuccess) {
		return;
	}
	SendMessageToWXReq *req = [self respWithText:aText];
	req.scene = aScene;
}

- (void)sendLinkContentWithTitle:(NSString *)aTitle
                 withDescription:(NSString *)aDescription
                  withThumbImage:(UIImage *)aThumbImage
                     withLineUrl:(NSString *)aLinkUrl
                       withScene:(enum WXScene)aScene
{
    if ([self  checkingWeiXinStatus] != WeixinStatusSuccess) {
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = aTitle;
    message.description = aDescription;
    [message setThumbImage:[aThumbImage scaleToSize:CGSizeMake(150, 150)]];
    
    [self sendLinkContentWithMessageContent:message withLineUrl:aLinkUrl withScene:aScene];
}

- (void)sendLinkContentWithTitle:(NSString *)aTitle
				 withDescription:(NSString *)aDescription
				  withThumbData:(NSData *)aThumbData
					 withLineUrl:(NSString *)aLinkUrl
					   withScene:(enum WXScene)aScene
{
	if ([self  checkingWeiXinStatus] != WeixinStatusSuccess) {
		return;
	}

	WXMediaMessage *message = [WXMediaMessage message];
    message.title = aTitle;
    message.description = aDescription;
    [message setThumbImage:[UIImage imageWithData: aThumbData]];
    message.thumbData=aThumbData;
	[self sendLinkContentWithMessageContent:message withLineUrl:aLinkUrl withScene:aScene];
}

- (void)sendLinkContentWithTitle:(NSString *)aTitle
				 withDescription:(NSString *)aDescription
				  withImageUrl:(NSString *)aImageUrl
					 withLineUrl:(NSString *)aLinkUrl
					   withScene:(enum WXScene)aScene
{
	if ([self  checkingWeiXinStatus] != WeixinStatusSuccess) {
		return;
	}
    
	WXMediaMessage *message = [WXMediaMessage message];
    message.title = aTitle;
    message.description = aDescription;
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageUrl = aImageUrl;
    message.mediaObject = imageObject;
    
	[self sendLinkContentWithMessageContent:message withLineUrl:aLinkUrl withScene:aScene];
}

- (void)sendLinkContentWithMessageContent:(WXMediaMessage *)contentMessage
							  withLineUrl:(NSString *)aLinkUrl
								withScene:(enum WXScene)aScene
{
	if ([self checkingWeiXinStatus] != WeixinStatusSuccess) {
		return;
	}

	WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = aLinkUrl;

    contentMessage.mediaObject = ext;

	SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = contentMessage;
    req.scene = aScene;

    [WXApi sendReq:req];
}

- (WeixinStatus)weixinPublishStatus
{
	WeixinStatus status = WeixinStatusSuccess;
    if (![WXApi isWXAppInstalled]) {
        status = WeixinStatusNoInstall;
    }
    if (![WXApi isWXAppSupportApi]) {
        status = WeixinStatusNoSupportApi;
    }
    return status;
}

@end
