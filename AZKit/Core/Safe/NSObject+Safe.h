//
//  NSObject+Safe.h
//  OTSKit
//
//  Created by Jerry on 16/9/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Safe)

@property (assign, nonatomic, readonly, nullable) NSNumber *numberValue;

@end

NS_ASSUME_NONNULL_END
