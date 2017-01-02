//
//  OTSUpLoadNetworkInterface.h
//  OneStoreFramework
//
//  Created by airspuer on 14-11-3.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//
#import <OTSKit/OTSUploadOperationParam.h>
#import "OTSNetworkInterface.h"
@interface OTSNIUpLoad : OTSNetworkInterface

/**
 *	功能:上传图片文件的接口
 *
 *	@param aFileValues      :文件对象。可以同时上传多个同一类型的图片文件数据 NSArray<OTSUploadFileValue>
 *	@param aToken           :用户token
 *	@param aCompletionBlock :完成的回调
 *
 *	@return
 */
+ (OTSUploadOperationParam *)uploadFileForReturn:(NSArray *)aFileValues
											   token:(NSString *)aToken
									 completionBlock:(OTSCompletionBlock)aCompletionBlock;
@end
