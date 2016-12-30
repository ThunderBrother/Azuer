//
//  UIViewController+loading.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "UIView+Loading.h"
#import "NSObject+Runtime.h"

@implementation UIViewController (loading)

- (void)showLoading {
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second {
    [self.view showLoadingWithMessage:message hideAfter:second];
}

- (void)hideLoading {
    [self.view hideLoading];
}

@end
