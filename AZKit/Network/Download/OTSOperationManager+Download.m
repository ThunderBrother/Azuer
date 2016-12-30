//
//  OTSOperationManager+Download.m
//  OneStoreFramework
//
//  Created by huangjiming on 6/12/15.
//  Copyright (c) 2015 OneStore. All rights reserved.
//

#import "OTSOperationManager+Download.h"
#import "OTSServerError.h"
//category
#import "NSObject+PerformBlock.h"
#import "NSString+safe.h"

@implementation OTSOperationManager (Download)

- (void)downloadFrom:(NSString *)aURL
                  to:(NSString *)aPath
   completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    //dns
    NSString *requestUrl = aURL;
    NSString *currentDomain = [OTSServerError sharedInstance].serverDomain;
    if ([requestUrl safeRangeOfString:currentDomain].location != NSNotFound) {
        NSURL *url = [NSURL URLWithString:requestUrl];
        [self.requestSerializer setValue:url.host forHTTPHeaderField:@"Host"];
    } else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"Host"];
    }
    
    [self performInThreadBlock:^{
        NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:aURL]] progress:NULL destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSString *fullPath = [aPath stringByAppendingPathComponent:response.suggestedFilename];
            if (fullPath) {
                return [NSURL fileURLWithPath:fullPath];
            } else {
                return nil;
            }
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (completionHandler) {
                completionHandler(response, filePath, error);
            }
        }];
        [downloadTask resume];
    }];
}

@end
