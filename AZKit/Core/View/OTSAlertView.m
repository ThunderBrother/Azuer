//
//  OTSAlertView.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSAlertView.h"
#import "AZFuncDefine.h"
#import "UIColor+Utility.h"

@interface OTSAlertView () <UIAlertViewDelegate>


@end

@implementation OTSAlertView

+ (instancetype)alertWithMessage:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock {
    return [self alertWithTitle:nil message:aMessage andCompleteBlock:aBlock];
}

+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock {
    return [self alertWithTitle:aTitle message:aMessage leftBtn:@"YES" rightBtn:nil extraData:nil andCompleteBlock:aBlock];
}

+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage leftBtn:(NSString *)leftBtnName rightBtn:(NSString *)rightBtnName extraData:(id)aData andCompleteBlock:(OTSAlertViewBlock)aBlock {
    if (!leftBtnName) {
        leftBtnName = @"YES";
    }
    
    if (!aTitle) {
        aTitle = @"";
    }
    
    OTSAlertView *alertView = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        alertView = [[OTSAlertView alloc] init];
       
        // 不知道下面三个参数干什么用
        alertView.data = aData;
        alertView.block = aBlock;
        alertView.delegate = alertView;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
        
        if (leftBtnName) {
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:leftBtnName style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (aBlock) {
                    aBlock(alertView,0);
                }
            }];
            [alertController addAction:cancelButton];
        }
        
        if (rightBtnName) {
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:rightBtnName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (aBlock) {
                    aBlock(alertView,1);
                }
            }];
            
            [alertController addAction:okButton];
        }
        alertController.view.tintColor = [UIColor colorWithRGB:0xfa585d];
        [OTSSharedKeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return nil;
    } else {
        alertView = [[self alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:leftBtnName otherButtonTitles:nil];
        
        alertView.delegate = alertView;
        
        if (rightBtnName) {
            [alertView addButtonWithTitle:rightBtnName];
        }
        
        alertView.data = aData;
        alertView.block = aBlock;
        alertView.delegate = alertView;
    }
    
    return alertView;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(OTSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block) {
        self.block(alertView,buttonIndex);
    }
    
    self.block = nil;
}


@end
