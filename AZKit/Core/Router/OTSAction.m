//
//  OTSAction.m
//  OTSKit
//
//  Created by Jerry on 16/9/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSAction.h"
#import <UIKit/UIKit.h>
#import "UIViewController+Loading.h"
#import "UIView+Toast.h"
#import "UIColor+Utility.h"
#import "AZFuncDefine.h"
#import "UIViewController+RefreshAction.h"



NSString const* OTSActionCancelTitleKey = @"OTSActionCancelTitleKey";
NSString const* OTSActionEventBlockKey = @"OTSActionEventBlockKey";
NSString const* OTSActionValues = @"OTSActionValues";

@interface OTSAction()

@property (strong, nonatomic) UIViewController *source;

@end

@implementation OTSAction

- (instancetype)initWithSource:(UIViewController*)source {
    if (self = [super init]) {
        self.source = source;
    }
    return self;
}

- (void)submitWithCompletion:(void (^)(void))completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.source) {
            self.source = OTS_AutoGetRootSourceViewController();
        }
        [self __submitActionWithCompletion:completionBlock];
    });
}

- (void)__submitActionWithCompletion:(void (^)(void))completionBlock {
    if (![self.source isViewLoaded]) {
        return;
    }
    
    if (self.option & OTSActionOptionShowLoading) {
        [self.source showLoadingWithMessage:self.extraData[OTSIntentMessageKey]];
        if (completionBlock) {
            completionBlock();
        }
    } else {
        [self.source hideLoading];
    }
    
    if (self.option & OTSActionOptionHideLoading) {
        if (completionBlock) {
            completionBlock();
        }
    }
    
    if (self.option & OTSActionOptionShowToast){
        [self.source.view makeToast:self.extraData[OTSIntentMessageKey] duration:2.0 position:CSToastPositionCenter];
        if (completionBlock) {
            completionBlock();
        }
    }
    
    if (self.option & OTSActionOptionHeaderSuccessfully | OTSActionOptionFooterSuccessfully | OTSActionOptionHeaderError | OTSActionOptionFooterError | OTSActionOptionFooterPause) {
        [self.source showRefreshActionWithScrollView:self.source.scrollView action:self.option message:self.extraData[OTSIntentMessageKey]];
        if (completionBlock) {
            completionBlock();
        }
    }
    
    if (!self.source.view.window || ([self.source.parentViewController isKindOfClass:[UINavigationController class]] && self.source.navigationController.topViewController != self.source)) {
        return;
    }
    
    //以下action 只有vc 显示的时候才执行
    if (self.option & OTSActionOptionHideKeyboard) {
        [OTSSharedKeyWindow endEditing:YES];
    }
    
    if (self.option & (OTSActionOptionShowAlert | OTSActionOptionShowSheet)) {
        [self __excuteAlertCommandWithCompletion:completionBlock];
    } else if(self.option & OTSActionOptionShare) {
        [self __excuteShareCommandWithCompletion:completionBlock];
    } else if(self.option & OTSActionOptionDismiss) {
        [self __excuteDismissCommandWithCompletion:completionBlock];
    }
    
}

- (void)__excuteShareCommandWithCompletion:(void (^)(void))completionBlock {
    NSArray *items = self.extraData[OTSActionValues];
    
    if ([items isKindOfClass:[NSArray class]]) {
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop];
        [self.source presentViewController:activityController animated:YES completion:completionBlock];
    }
}

- (void)__excuteDismissCommandWithCompletion:(void (^)(void))completionBlock {
    UINavigationController *nc = OTS__AutoGetNavigationViewController(self.source);
    if (nc) {
        [nc popViewControllerAnimated:true];
        if (completionBlock) {
            completionBlock();
        }
    } else {
        [self.source dismissViewControllerAnimated:true completion:completionBlock];
    }
}

- (void)__excuteAlertCommandWithCompletion:(void (^)(void))completionBlock {
    
    NSDictionary *extraData = self.extraData.copy;
    
    NSString *alertTitle = extraData[OTSIntentTitleKey];
    NSString *alertMsg = extraData[OTSIntentMessageKey];
    UIAlertControllerStyle alertStyle = self.option & OTSActionOptionShowAlert ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet;
    NSString *cancelTitle = extraData[OTSActionCancelTitleKey];
    NSArray *defaultTitles = extraData[OTSActionValues];
    void (^eventBlock)(NSInteger index) = extraData[OTSActionEventBlockKey];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertMsg preferredStyle:alertStyle];
    
    if (cancelTitle) {
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (eventBlock) {
                eventBlock(-1);
            }
        }];
        [alertController addAction:cancelButton];
    }
    
    if (defaultTitles.count) {
        for (int i = 0; i < defaultTitles.count; i++) {
            NSString *aTitle = defaultTitles[i];
            UIAlertAction *anAction = [UIAlertAction actionWithTitle:aTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (eventBlock) {
                    eventBlock(i);
                }
            }];
            [alertController addAction:anAction];
        }
    }
    
    if (!alertController.actions.count) {
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okButton];
    }
    alertController.view.tintColor = [UIColor colorWithRGB:0xfa585d];
    [self.source presentViewController:alertController animated:YES completion:completionBlock];
}

@end
