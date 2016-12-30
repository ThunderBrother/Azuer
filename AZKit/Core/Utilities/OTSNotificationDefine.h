//
//  OTSNotificationDefine.h
//  OTSKit
//
//  Created by Jerry on 16/8/25.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#ifndef OTSNotificationDefine_h
#define OTSNotificationDefine_h

//网络
#define OTS_CDN_LOG                         @"OTS_CDN_LOG"//cdn日志
#define OTS_SHOW_ERROR_VIEW                 @"OTS_SHOW_ERROR_VIEW"//显示错误界面(无网络连接，或者服务器忙)
#define OTS_HIDE_NO_CONNECT_ERROR_VIEW      @"OTS_HIDE_NO_CONNECT_ERROR_VIEW"//隐藏无网络错误界面


//注册登录
#define OTS_MANUAL_AUTO_LOGIN_SUCCESS  = @"userdefault.passport.autoLogin";//自动登录
#define OTS_MANUAL_LOGIN_SUCCESS    @"notification.passport.login"//登录成功
#define OTS_MANUAL_LOGIN_FAILED     @"notificatoin.passport.loginfailed"//登录失败
#define OTS_MANUAL_LOGIN_OUT        @"notification.passport.logout"//退出登录

#define OTS_MANUAL_ACCOUNT_REFRESH       @"OTS_MANUAL_ACCOUNT_REFRESH"//个人中心刷新
#define OTS_MANUAL_REVIEW_REFRESH       @"OTS_MANUAL_REVIEW_REFRESH"//评论刷新

/**
 *  微信联合登录成功后从微信转到app时发送的通知，登录模块会处理，其它模块不需要处理。
 *  登录成功后还会再发送 OTS_MANUAL_LOGIN_SUCCESS 通知。
 */
#define OTS_MANUAL_WECHAT_LOGIN        @"OTS_MANUAL_WECHAT_LOGIN"//评论登录

#define OTS_CARTCOUNT_NEED_UPDATED          @"OTS_CARTCOUNT_NEED_UPDATED"//购物车需要刷新数量
#define OTS_CARTCOUNT_UPDATED               @"OTS_CARTCOUNT_UPDATED"//购物车里面购物数量发生更新

#define OTS_GET_PRODUCT_DETAIL_FOR_CALL_MSG_VO  @"OTS_GET_PRODUCT_DETAIL_FOR_CALL_MSG_VO"

//客服中心
#define OTS_RECEIVE_MSG                     @"OTS_RECEIVE_MSG"//收到消息
#define OTS_MESSAGE_SEND_MERCHANTINFO @"OTS_MESSAGE_SEND_MERCHANTINFO"  // 历史消息获取商家名字
#define OTS_MESSAGE_SEND_SESSIONINFO  @"OTS_MESSAGE_SEND_SESSIONINFO"   // 发送商家名字
#define OTS_GLOBAL_SHOW_MESSAGE       @"OTS_GLOBAL_SHOW_MESSAGE"        // 会话里获取商家名字
#define OTS_GLOBAL_HIDEN_MESSAGE       @"OTS_GLOBAL_HIDEN_MESSAGE"        // 隐藏全局消息展示
#define OTS_GLOBAL_CAN_SHOW_MESSAGE    @"OTS_GLOBAL_CAN_SHOW_MESSAGE"        //是否可以展示全局消息展示
#define OTS_CALLCENTER_UPDATE_MESSAGE_COUNT @"OTS_CALLCENTER_UPDATE_MESSAGE_COUNT"  // 更新消息数字
#define MSG_IM_MSG_IMG_STATUS_CHANGE             @"Msg_Im_MSG_IMG_STATUS_CHANGE"       //接受图片状态更新通知
#define OTS_REFRESH_PRODUCTURL        @"OTS_REFRESH_PRODUCTURL"         // 刷新url可视化
#define OTS_CALLCENTER_FOOTERORDER    @"OTS_CALLCENTER_FOOTERORDER"     // 订单或足迹
#define OTS_GET_MSG_APPRAISE @"OTS_GET_MSG_APPRAISE"

/**
 *  网络状态更新
 */
#define NotificationNetworkStatusChange  @"NotificationNetworkStatusChange"
/**
 *  有网络
 */
#define NotificationNetworkStatusReachable  @"NotificationNetworkStatusReachable"

#endif /* OTSNotificationDefine_h */
