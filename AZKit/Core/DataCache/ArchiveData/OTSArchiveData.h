//
//  OTSArchiveData.h
//  OneStoreFramework
//
//  Created by Aimy on 14-6-29.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSArchiveData : NSObject

/**
 *  功能:存档
 */
+ (void)archiveDataInDoc:(id<NSCoding>)aData withFileName:(NSString *)aFileName;

/**
 *  功能:取档，从document中取文件
 */
+ (id<NSCoding>)unarchiveDataInDocWithFileName:(NSString *)aFileName;

/**
 *  功能:存档到cache
 */
+ (void)archiveDataInCache:(id<NSCoding>)aData withFileName:(NSString *)aFileName;

/**
 *  功能:取档，从cache中取文件
 */
+ (id<NSCoding>)unarchiveDataInCacheWithFileName:(NSString *)aFileName;

/**
 *  功能:取档,从[[NSBundle mainBundle] resourcePath]取文件
 */
+ (id<NSCoding>)unarchiveDataInMainBundleWithFileName:(NSString *)aFileName;

/**
 *  功能:取档,从[[NSBundle mainBundle] resourcePath]取文件
 */
+ (id<NSCoding>)unarchiveDataWithFileName:(NSString *)aFileName andBundleName:(NSString *)aBundleName;

@end
