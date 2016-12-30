//
//  UIViewController+loading.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (loading)

- (void)showLoading;

- (void)showLoadingWithMessage:(NSString *)message;

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

- (void)hideLoading;

@end
