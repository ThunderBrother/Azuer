//
//  UIView+loading.m
//  OneStoreFramework
//
//  Created by Aimy on 14/10/30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"
#import "NSObject+Runtime.h"

@implementation UIView (loading)

static NSString *OTSHudViewKey = @"OTSHudViewKey";

- (void)showLoading {
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message {
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    if (message) {
        hud.label.text = message;
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (second > 0) {
        [hud hideAnimated:true afterDelay:second];
    } else {
        [self objc_setAssociatedObject:OTSHudViewKey value:hud policy:OBJC_ASSOCIATION_RETAIN];
    }
}

- (void)hideLoading {
    MBProgressHUD *hud = [self objc_getAssociatedObject:OTSHudViewKey];
    if (hud) {
        [hud hideAnimated:true];
        [self objc_removeAssociatedObjectForPropertyName:OTSHudViewKey];
    }
}

@end
