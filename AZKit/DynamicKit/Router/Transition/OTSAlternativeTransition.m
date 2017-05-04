//
//  OTSAlternativeTransition.m
//  OTSKit
//
//  Created by Jerry on 2017/2/24.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSAlternativeTransition.h"
#import "UIView+Frame.h"

@implementation OTSAlternativeTransition

#pragma mark - Override
- (void)presentVC:(UIViewController *)vcToBePresent
           fromVC:(UIViewController *)fromVC
        container:(UIView *)containerView
          context:(id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalFrame = [context finalFrameForViewController:vcToBePresent];
    vcToBePresent.view.frame = finalFrame;
    [containerView addSubview:vcToBePresent.view];
    
    vcToBePresent.view.transform = CGAffineTransformMakeTranslation(0, vcToBePresent.view.height);
    [UIView animateWithDuration:self.duration animations:^{
        vcToBePresent.view.transform = CGAffineTransformIdentity;
        fromVC.view.transform = CGAffineTransformMakeTranslation(0, fromVC.view.height);
    } completion:^(BOOL finished) {
        fromVC.view.transform = CGAffineTransformIdentity;
        [context completeTransition:YES];
    }];
}

- (void)dismissVC:(UIViewController *)vcToBeDismissed toVC:(UIViewController *)toVC container:(UIView *)containerView context:(id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalFrame = [context finalFrameForViewController:toVC];
    toVC.view.frame = finalFrame;
    [containerView insertSubview:toVC.view belowSubview:vcToBeDismissed.view];
    
    toVC.view.transform = CGAffineTransformMakeTranslation(0, toVC.view.height);
    
    [UIView animateWithDuration:self.duration animations:^{
        vcToBeDismissed.view.transform = CGAffineTransformMakeTranslation(0, vcToBeDismissed.view.height);
        toVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [vcToBeDismissed.view removeFromSuperview];
        vcToBeDismissed.view.transform = CGAffineTransformIdentity;
        
        [context completeTransition:YES];
    }];
}

@end
