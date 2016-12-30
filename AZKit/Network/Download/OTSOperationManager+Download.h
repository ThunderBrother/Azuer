//
//  OTSOperationManager+Download.h
//  OneStoreFramework
//
//  Created by huangjiming on 6/12/15.
//  Copyright (c) 2015 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
//network
#import "OTSOperationManager.h"

@interface OTSOperationManager (Download)

- (void)downloadFrom:(NSString *)aURL
                  to:(NSString *)aPath
   completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
