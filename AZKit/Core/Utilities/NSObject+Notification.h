//
//  NSObject+BeeNotification.h
//  OneStoreFramework
//
//  Created by Aimy on 14-6-23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BeeNotification)

/**
 *  处理处理通知
 *
 */
- (void)handleNotification:(NSNotification *)notification;
/**
 *  注册通知
 *
 *  @param name 通知名称
 */
- (void)observeNotification:(NSString *)name;
/**
 *  取消注册通知
 *
 *  @param name 通知名称
 */
- (void)unobserveNotification:(NSString *)name;
/**
 *  取消注册的所有通知
 */
- (void)unobserveAllNotifications;
/**
 *  发送通知
 *
 *  @param name 通知名称
 *
 */
- (void)postNotification:(NSString *)name;
/**
 *  发送通知并传递参数
 *
 *  @param name   通知名称
 *  @param object 传递的参数
 *
 */
- (void)postNotification:(NSString *)name withObject:(NSObject *)object;
/**
 *  发送通知并传递参数
 *
 *  @param name   通知名称
 *  @param object 传递的参数
 *  @param info 传递的参数
 *
 */
- (void)postNotification:(NSString *)name withObject:(NSObject *)object userInfo:(NSDictionary *)info;
@end



