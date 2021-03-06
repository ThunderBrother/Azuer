//
//  OTSOperationManager+Upload.m
//  OneStoreFramework
//
//  Created by huangjiming on 6/12/15.
//  Copyright (c) 2015 OneStore. All rights reserved.
//

#import "OTSOperationManager+Upload.h"
#import "OTSOperationParam.h"
#import "OTSUploadOperationParam.h"
#import "OTSUploadFileValue.h"
#import "OTSServerError.h"
//category
#import "NSString+safe.h"

@interface OTSOperationParam ()

#pragma mark - 接口调用相关
@property(nonatomic, copy) NSString *requestUrl;                        //请求url
@property(nonatomic, strong) NSDictionary *requestParam;                //参数

@end

@implementation OTSOperationManager (Upload)

- (NSURLSessionTask *)uploadWithParam:(OTSUploadOperationParam *)aParam
{
    if (aParam == nil) {
        return nil;
    }
    
    //超时时间
    self.requestSerializer.timeoutInterval = aParam.timeoutTime;
    
    //dns
    NSString *requestUrl = aParam.requestUrl;
    NSString *currentDomain = [OTSServerError sharedInstance].serverDomain;
    if ([requestUrl safeRangeOfString:currentDomain].location != NSNotFound) {
        NSURL *url = [NSURL URLWithString:requestUrl];
        [self.requestSerializer setValue:url.host forHTTPHeaderField:@"Host"];
    } else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"Host"];
    }
    
    [self POST:aParam.requestUrl parameters:aParam.requestParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self uploadPart:aParam formData:formData];
    } progress:nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
        if (aParam.callbackBlock) {
            aParam.callbackBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (aParam.callbackBlock) {
            aParam.callbackBlock(nil, error);
        }
    }];
    
    return nil;
}

- (void)uploadPart:(OTSUploadOperationParam *)aParam formData:(id<AFMultipartFormData>)formData {
    NSString *mimeTypeStr = nil;
    if (aParam.uploadType == kUpLoadData) {
        switch (aParam.mimeType) {
            case kPng:
                mimeTypeStr = @"image/png";
                break;
            case kJpg:
                mimeTypeStr = @"image/jpg";
                break;
            default:
                break;
        }
        if (aParam.uploadFileValues.count > 0) {
            for (OTSUploadFileValue *fileValue in aParam.uploadFileValues) {
                [formData appendPartWithFileData:fileValue.fileData name:aParam.name fileName:fileValue.fileName mimeType:mimeTypeStr];
            }
        } else {
            [formData appendPartWithFileData:aParam.fileData name:aParam.name fileName:aParam.fileName mimeType:mimeTypeStr];
        }
    } else {
        [formData appendPartWithFileURL:aParam.fileUrl name:aParam.name error:nil];
    }
}

@end
