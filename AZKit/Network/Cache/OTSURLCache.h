//
//  OTSURLCache.h
//  OneStoreFramework
//  功能:重写URL缓存
//  Created by huang jiming on 14-7-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSURLCache : NSURLCache

+ (instancetype)standardURLCache;

/**
 *  功能:根据最新的接口版本号进行处理
 *  param:dict，格式{methodName:version}
 */
- (void)dealWithNewInterfaceVersionDict:(NSDictionary *)versionDict;

@end
