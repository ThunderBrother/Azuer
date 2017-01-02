//
//  ShoppingMobileInput.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "ShoppingMobileInput.h"

@implementation ShoppingMobileInput

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.mobileSiteType = @"3";//bamboo 合规
    }
    return self;
}

- (NSString *)mobileSiteType {
    return @"3";
}

@end
