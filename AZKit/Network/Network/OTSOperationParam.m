//
//  OTSOperationParam.m
//  OneStoreFramework
//
//  Created by huang jiming on 14-7-31.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSOperationParam.h"

#import "OTSNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
//define
#import "OTSUserDefaultDefine.h"
//object
#import "OTSGlobalValue.h"

//connetAddress
#import "OTSNetworkEnvironment.h"

@interface OTSOperationParam ()

#pragma mark - 拼装requestUrl相关
@property(nonatomic, copy) NSString *businessName;                      //业务名
@property(nonatomic, copy) NSString *methodName;                        //方法名
@property(nonatomic, copy) NSString *versionNum;                        //版本，如"v2.3"

#pragma mark - 接口调用相关
@property(nonatomic, copy) NSString *requestUrl;                        //请求url
@property(nonatomic, assign) ERequestType requestType;                  //请求类型，post还是get方式，默认为post方式
@property(nonatomic, strong) NSDictionary *requestParam;                //参数

#pragma mark - 接口错误相关
@property(nonatomic, assign) BOOL rerunForTokenExpire;                  //是否token过期自动登录后再次执行，默认为NO
@property(nonatomic, assign) BOOL rerunForSignKeyExpire;                //是否重新调用获取密钥接口后再次执行，默认为NO
@property(nonatomic, assign) BOOL rerunForLaunchFail;                   //是否重新调用启动接口后再次执行，默认为NO
@property(nonatomic, copy) NSString *usedToken;                         //记录当前请求使用的token
@property(nonatomic, copy) NSString *usedIp;                            //记录当前请求使用的ip
@property(nonatomic, assign) BOOL needUseIp;                            //是否需要使用ip，默认为NO

#pragma mark - 接口日志相关
@property(nonatomic, assign) NSTimeInterval startTimeStamp;             //接口调用开始时间，精确到ms
@property(nonatomic, assign) NSTimeInterval endTimeStamp;               //接口调用结束时间，精确到ms
@property(nonatomic, assign) NSInteger errorType;                       //接口错误类型(0无错误，1接口超时，2接口出错，3rtn_code不为0)
@property(nonatomic, strong) NSString *errorCode;                       //接口错误码

@end

@implementation OTSOperationParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needSignature = YES;
        self.needEncoderToken = YES;
        self.retryTimes = 1;
        self.cacheTime = 0;
        self.timeoutTime = 10;
        
        self.rerunForTokenExpire = NO;
        self.rerunForLaunchFail = NO;
        self.alertError = NO;
        self.showErrorView = NO;
    }
    return self;
}


/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithBusinessName:(NSString *)aBusinessName
                 methodName:(NSString *)aMethodName
                 versionNum:(NSString *)aVersionNum
                       type:(ERequestType)aType
                      param:(NSDictionary *)aParam
                   callback:(OTSCompletionBlock)aCallback
{
    OTSOperationParam *param = [self new];
    param.businessName = aBusinessName;
    param.methodName = aMethodName;
    param.versionNum = aVersionNum;
    NSString *domain = param.currentDomain;
    
    if (aVersionNum.length > 0) {
        param.requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@", domain, aBusinessName, aMethodName, aVersionNum];
    } else {
        param.requestUrl = [NSString stringWithFormat:@"%@/%@/%@", domain, aBusinessName, aMethodName];
    }
    param.requestType = aType;
    param.requestParam = aParam ? aParam : [NSMutableDictionary dictionary];
    param.callbackBlock = aCallback;
    
    return param;
}

/**
 *  功能:初始化方法
 */
+ (instancetype)paramWithUrl:(NSString *)aUrl
              type:(ERequestType)aType
             param:(NSDictionary *)aParam
          callback:(OTSCompletionBlock)aCallback
{
    OTSOperationParam *param = [self new];
    param.requestUrl = aUrl;
    param.requestType = aType;
    param.requestParam = aParam ? aParam : [NSMutableDictionary dictionary];
    param.callbackBlock = aCallback;
    
    //for print log
    param.methodName = aUrl;
    
    return param;
}

/**
 *  功能:当前域名
 */
- (NSString *)currentDomain
{
    return  [OTSNetworkEnvironment getNetworkHost];
}

@end

