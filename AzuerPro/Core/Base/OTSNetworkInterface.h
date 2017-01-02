//
//  OTSNetworkInterface.h
//  OneStoreFramework
//  功能:网络接口
//  Created by Aimy on 14-6-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OTSKit/OTSKit.h>

@interface OTSNetworkInterface : NSObject

/**
 *  功能:从SEL获取接口名称
 */
+ (NSString *)interfaceNameFromSelector:(SEL)aSelector;

/**
 *	功能:获取类型不匹配的错误
 *
 *	@param aMathType   :需要匹配的数据类型,需要正确返回的数据类
 *	@param aSourceType :真实返回的数据类型
 *
 *	@return
 */
+ (NSError *)typeMismatchErrorWithMatchType:(Class)aMathType
								 sourceType:(Class)aSourceType;

@end
