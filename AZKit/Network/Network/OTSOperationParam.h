//
//  OTSOperationParam.h
//  OneStoreFramework
//  功能:接口调用operation所需的参数
//  Created by huang jiming on 14-7-31.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RACSubscriber.h"

typedef enum {
    kRequestPost = 0,                   //post方式
    kRequestGet                         //get方式
} ERequestType;

typedef NS_ENUM(NSInteger, EUpLoadFileType){
    kUpLoadData = 0,                    //data方式
    kUpLoadUrl                          //url方式
};

typedef NS_ENUM(NSInteger, EUpLoadFileMimeType){
    kPng = 0,                           //png方式
    kJpg                                //jpg方式
};


typedef void(^OTSCompletionBlock)(id aResponseObject, NSError* anError);


@interface OTSOperationParam : NSObject

@property(nonatomic, assign) BOOL needSignature;                        //是否需要签名，默认为YES
@property(nonatomic, assign) BOOL needEncoderToken;                     //是否加密token，默认为YES
@property(nonatomic, assign) NSInteger retryTimes;                      //重试次数，默认为1
@property(nonatomic, assign) NSTimeInterval cacheTime;                  //缓存时间，默认为0秒
@property(nonatomic, assign) NSTimeInterval timeoutTime;                //超时时间，默认为10秒
@property(nonatomic, assign) BOOL alertError;                           //是否弹出错误提示，默认为NO
@property(nonatomic, assign) BOOL showErrorView;                        //是否显示错误界面，默认为NO
@property(nonatomic, copy) OTSCompletionBlock callbackBlock;            //回调block

#pragma mark - RACReuqest
@property (nonatomic, strong) id<RACSubscriber> subscriber; //网络请求的信号订阅者
@property (nonatomic, assign) BOOL isRACRequest; //是否使用rac方法请求数据
/**
 *  YES:暂时不向订阅的信号发送错误事件.
 *  订阅者发送了错误事件,这个订阅者就会被销毁.重试时就没办法再给信号发送其他事件了
 *
 */
@property (nonatomic, assign) BOOL blockSendError;



/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithBusinessName:(NSString *)aBusinessName
                 methodName:(NSString *)aMethodName
                 versionNum:(NSString *)aVersionNum
                       type:(ERequestType)aType
                      param:(NSDictionary *)aParam
                   callback:(OTSCompletionBlock)aCallback;

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithUrl:(NSString *)aUrl
              type:(ERequestType)aType
             param:(NSDictionary *)aParam
          callback:(OTSCompletionBlock)aCallback;

@end
