//
//  OTSWeiXinShare.h
//  OneStore
//
//  Created by airspuer on 13-12-31.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <OTSKit/OTSKit.h>
#import "WXApi.h"

typedef enum{
	WeixinStatusSuccess,
	WeixinStatusNoInstall, //没有安装微信
	WeixinStatusNoSupportApi,//当前api不支持
} WeixinStatus;

@interface OTSWeiXinShare : NSObject
AS_SINGLETON(OTSWeiXinShare);

/**
 *	功能:客服端向微信发送文字内容,默认是发送给好友
 *
 *	@param aText:内容
 */
- (void)sendTextContentWithText:(NSString*)aText;

/**
 * 功能:客服端向微信发送文字内容,默认是发送给好友
 *
 *	@param aText aText:内容
 *	@param aScene:参见(WXScene)
 */
- (void)sendTextContentWithText:(NSString *)aText
					  withScene:(enum WXScene)aScene;

/**
 *	功能:客服端向微信发送可点击的页面信息,默认是发送给好友
 *
 *	@param aTitle       :页面的title
 *	@param aDescription :页面的描述
 *	@param withThumbData  :消息内容的缩略图Data
 *	@param aLinkUrl     :页面的url
 *  @param aScene       :(enum WXScene)aScene,发送到微信不同的场景
 */
- (void)sendLinkContentWithTitle:(NSString *)aTitle
                 withDescription:(NSString *)aDescription
                   withThumbData:(NSData *)aThumbData
                     withLineUrl:(NSString *)aLinkUrl
                       withScene:(enum WXScene)aScene;

/**
 *	功能:客服端向微信发送可点击的页面信息,默认是发送给好友
 *
 *	@param aTitle       :页面的title
 *	@param aDescription :页面的描述
 *	@param aThumbImage  :消息内容的缩略图
 *	@param aLinkUrl     :页面的url
 *  @param aScene       :(enum WXScene)aScene,发送到微信不同的场景
 */
- (void)sendLinkContentWithTitle:(NSString *)aTitle
                 withDescription:(NSString *)aDescription
                   withThumbImage:(NSData *)aThumbImage
                     withLineUrl:(NSString *)aLinkUrl
                       withScene:(enum WXScene)aScene;


/**
 *	功能:客服端向微信发送可点击的页面信息,默认是发送给好友
 *
 *	@param aTitle       :页面的title
 *	@param aDescription :页面的描述
 *	@param aImageUrl    :图片url
 *	@param aLinkUrl     :页面的url
 *  @param aScene       :(enum WXScene)aScene,发送到微信不同的场景
 */
- (void)sendLinkContentWithTitle:(NSString *)aTitle
				 withDescription:(NSString *)aDescription
                    withImageUrl:(NSString *)aImageUrl
					 withLineUrl:(NSString *)aLinkUrl
					   withScene:(enum WXScene)aScene;

/**
 *功能:客服端向微信发送可点击的页面信息,默认是发送给好友
 *
 *	@param contentMessage :页面的描述信息,参见WXMediaMessage
 *	@param aLinkUrl       :页面url
 *	@param aScene         :(enum WXScene)aScene,发送到微信不同的场景
 */
- (void)sendLinkContentWithMessageContent:(WXMediaMessage *)contentMessage
					 withLineUrl:(NSString *)aLinkUrl
					   withScene:(enum WXScene)aScene;
/**
 *	功能:获取微信的状态
 *
 *	@return 参见WeixinStatus
 */
- (WeixinStatus)weixinPublishStatus;

/**
 *	功能:查看微信的状态，如果没有安装就弹提示让其去安装
 *
 *	@return:WeixinStatus 状态
 */
- (WeixinStatus)checkingWeiXinStatus;

@end
