//
//  OTSLaunchLogic.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSLaunchLogic.h"
#import <OTSKit/OTSLaunchFailError.h>
#import <OTSKit/OTSTokenExpireError.h>
#import <OTSKit/OTSSignKeyExpireError.h>
#import <OTSKit/OTSTimeOutError.h>
#import <OTSKit/OTSAntiBrushError.h>
#import "NSString+RSASecurity.h"
#import "NSString+AESSecurity.h"

NSString *const kAntiBrushEnterRtnCode = @"yzm805002101";//ip列入黑名单
NSString *const kAntiBrushReVerifyRtnCode = @"yzm805002102";//重新获取验证码
NSString *const kAntiBrushVerifyFailRtnCode = @"yzm805002103";//验证码验证失败
NSString *const kAntiBrushVerifySucRtnCode = @"yzm805002100";//验证码验证成功

static NSString * const rsaPrivateKey =
@"-----BEGIN PRIVATE KEY-----\n"
"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKGcILpTe+miMF+DL\n"
"6mdm8xeSTskpcXiP0O/c/m3UxiLzvhp3bbXvODei8QH2OwdT2OGxDsRIN4MmGfQas\n"
"R8SNJvw7HA2JM1gfeToHeGi8XqPTJBGzazC76/RdYE7Q3KqU93UIAq3rqONGcMXVu\n"
"HOimpdzhsIeqvkSJKZmFVIAmbAgMBAAECgYBcVj1o2GxTOCUVXXotGm07HqAO18iT\n"
@"wMpO5iPYiQNEYhVWX/6bCrbTcLRAxA8QEUsb3ZNfAFFcLawinLV0IGLmV7DgMiY3c\n"
@"SqaW0W9A0/WTJPFgppcfaGUSCAEFvzFLmUisrfOKfdZWfOnoElXLfnh3kotKJFBRB\n"
@"JP+RWdL9a3AQJBAONN4g7/d90sx5SdwVx5QrNP7beyWQxNn3byo+VVE1XLXcLZ3RJ\n"
@"RGDzrfdbAYqFivTx7k+mvC5E8c3wG6QAd4xsCQQC2Axsk8OT7331/bG6otZyDqxFC\n"
@"TVO1GWgFJwW/FL1x2Y3q5MwsHcpYJFgpm7DLvtOAWdzkvm6M0kzJJwuCYluBAkEA0\n"
@"8F0vcAlbHkRHVSyFHIrP11Q+nc+GgYebvOw2C8fqiehG6tXFn9R8z73pp7nw6122e\n"
@"fObj9SqWUFuR++5QryzQJAEn8WTxa77myz0DMwu6xZD3he9KHvE8RVMdDZYKW26s7\n"
@"1AR3nMcSFP5fR7ciImuv1imGXdRd1HJJygy6YmNNuAQJBAI/1YURzJEZbZBphKum5\n"
@"zdugfTxsg6wREnmsXL/LkRSxP98zeT1sOhxTtI3fBz30jizayBOXoWEATO7s4fQrw\n"
@"qQ=\n"
"-----END PRIVATE KEY-----";

@interface OTSGlobalValue()

@property(nonatomic, copy) NSString *signatureKey;//解密后的签名密钥

@end

@implementation OTSLaunchLogic

- (void)dealWithCachedData {
    if ([[OTSUserDefault getValueForKey:OTSUserDefaultAutoLogin] boolValue]) {
        [OTSGlobalValue sharedInstance].token = [OTSKeychain getKeychainValueForType:OTSKeyChainUserToken];
    } else {
        [OTSGlobalValue sharedInstance].token = nil;
        [OTSKeychain setKeychainValue:nil forType:OTSKeyChainUserToken];
    }
}

- (void)registNetworkHandler {
    //注册启动接口失败处理block
    WEAK_SELF;
    
    [OTSNetworkManager sharedInstance].encryptByAESKey = ^NSString*(NSString *input, NSString *key){
        NSError *anError;
        return [input encryptByAESKey:key error:&anError];
    };
    
    [[OTSLaunchFailError sharedInstance] setErrorHandleBlock:^(OTSErrorHandleCompleteBlock errorHandleCompleteBlock) {
        STRONG_SELF;
        [self getSecretKeyWithHandler:errorHandleCompleteBlock];
    }];
    
    //注册token过期错误码
    [[OTSTokenExpireError sharedInstance] addTokenExpireRtnCode:@"000000000002"];
    //特殊处理（getUnionLoginCodeByUt接口token失效 状态码0110160090006）
    [[OTSTokenExpireError sharedInstance] addTokenExpireRtnCode:@"0110160090006"];
    
    [[OTSTokenExpireError sharedInstance] setErrorHandleBlock:^(OTSErrorHandleCompleteBlock errorHandleCompleteBlock) {
        
        OTSHandler *handler = [[OTSHandler alloc] initWithHandlerKey:@"autoLogin"];
        if (errorHandleCompleteBlock) {
            handler.extraData = @{OTSIntentCallBackKey: errorHandleCompleteBlock};
        }
        [handler submit];
    }];
    
    //注册密钥过期错误码
    [[OTSSignKeyExpireError sharedInstance] addSignKeyExpireRtnCode:@"000000000003"];
    //时间不匹配
    [[OTSSignKeyExpireError sharedInstance] addSignKeyExpireRtnCode:@"000000000004"];
    
    [[OTSSignKeyExpireError sharedInstance] setErrorHandleBlock:^(OTSErrorHandleCompleteBlock errorHandleCompleteBlock) {
        STRONG_SELF;
        [self getSecretKeyWithHandler:errorHandleCompleteBlock];
    }];
    
    //功能:注册接口超时错误码
    [[OTSTimeOutError sharedInstance] addTimeOutRtnCode:@"000000000006"];
    [[OTSTimeOutError sharedInstance] addTimeOutRtnCode:@"000000000007"];
    
    [[OTSAntiBrushError sharedInstance] addAntiBrushRtnCode:kAntiBrushEnterRtnCode];//ip在黑名单中
    [[OTSAntiBrushError sharedInstance] addAntiBrushRtnCode:kAntiBrushReVerifyRtnCode];//重新获取验证码
    [[OTSAntiBrushError sharedInstance] addAntiBrushRtnCode:kAntiBrushVerifyFailRtnCode];//验证码验证失败
    [[OTSAntiBrushError sharedInstance] addAntiBrushRtnCode:kAntiBrushVerifySucRtnCode];//验证码验证成功
    
    [[OTSAntiBrushError sharedInstance] setAntiBrushErrorHandleBlock:^(id aResponseObject) {
//        [[OTSAntiBrushPC sharedPC] dealWithResponseObject:aResponseObject];
    }];
}

#pragma mark - Network
- (void)getSecretKeyWithHandler:(OTSErrorHandleCompleteBlock)handler {
//    WEAK_SELF;
    OTSOperationParam *param = [OTSOperationParam paramWithBusinessName:@"mobileservice" methodName:@"getMySecretKey" versionNum:nil type:kRequestPost param:nil callback:^(id aResponseObject, NSError *anError) {
//        STRONG_SELF;
        if (!anError && [aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *theDict = aResponseObject;
            NSString *ckey = theDict[@"ckey"];
            NSString *signatureKey = [ckey decryptByRSAKey:rsaPrivateKey keyType:OTSRSAKeyTypePrivate error:NULL];
            [OTSGlobalValue sharedInstance].signatureKey = signatureKey;
            NSNumber *sTime = theDict[@"stime"];
            NSTimeInterval lTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval dTime = sTime.doubleValue/1000 - lTime;
            [OTSGlobalValue sharedInstance].dTime = dTime;
        }
        
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(!anError);
            });
        }
        
    }];
    param.needSignature = NO;
    [self.operationManager requestWithParam:param];
}

//- (void)trunToPemKey {
//    void (^trun)(NSString *) = ^(NSString *oriStr) {
//        for (int i=0; true; i++) {
//            NSRange range = NSMakeRange(65*i, 65);
//            bool stop = false;
//            if (range.location+ range.length >= oriStr.length) {
//                range.length = oriStr.length - range.location;
//                stop = true;
//            }
//            NSString *str = [oriStr substringWithRange:range];
//            NSLog(@"%@", str);
//            if (stop) {
//                return;
//            }
//        }
//    };
//    NSString *oriStr = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKGcILpTe+miMF+DL6mdm8xeSTskpcXiP0O/c/m3UxiLzvhp3bbXvODei8QH2OwdT2OGxDsRIN4MmGfQasR8SNJvw7HA2JM1gfeToHeGi8XqPTJBGzazC76/RdYE7Q3KqU93UIAq3rqONGcMXVuHOimpdzhsIeqvkSJKZmFVIAmbAgMBAAECgYBcVj1o2GxTOCUVXXotGm07HqAO18iTwMpO5iPYiQNEYhVWX/6bCrbTcLRAxA8QEUsb3ZNfAFFcLawinLV0IGLmV7DgMiY3cSqaW0W9A0/WTJPFgppcfaGUSCAEFvzFLmUisrfOKfdZWfOnoElXLfnh3kotKJFBRBJP+RWdL9a3AQJBAONN4g7/d90sx5SdwVx5QrNP7beyWQxNn3byo+VVE1XLXcLZ3RJRGDzrfdbAYqFivTx7k+mvC5E8c3wG6QAd4xsCQQC2Axsk8OT7331/bG6otZyDqxFCTVO1GWgFJwW/FL1x2Y3q5MwsHcpYJFgpm7DLvtOAWdzkvm6M0kzJJwuCYluBAkEA08F0vcAlbHkRHVSyFHIrP11Q+nc+GgYebvOw2C8fqiehG6tXFn9R8z73pp7nw6122efObj9SqWUFuR++5QryzQJAEn8WTxa77myz0DMwu6xZD3he9KHvE8RVMdDZYKW26s71AR3nMcSFP5fR7ciImuv1imGXdRd1HJJygy6YmNNuAQJBAI/1YURzJEZbZBphKum5zdugfTxsg6wREnmsXL/LkRSxP98zeT1sOhxTtI3fBz30jizayBOXoWEATO7s4fQrwqQ=";
//    trun(oriStr);
//}

@end
