//
//  OTSTransition.m
//  OTSKit
//
//  Created by Jerry on 2017/2/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSTransition.h"

@implementation OTSTransition

- (instancetype)initWithFromVC:(UIViewController*)fromVC
                          toVC:(UIViewController*)toVC {
    if (self = [super init]) {
        _fromVC = fromVC;
        _toVC = toVC;
        _duration = .5;
    }
    return self;
}

- (void)presentVC:(UIViewController *)vcToBePresent fromVC:(UIViewController *)previousVC container:(UIView *)containerView context:(id<UIViewControllerContextTransitioning>)context {
    
}

- (void)dismissVC:(UIViewController *)vcToBeDismissed toVC:(UIViewController *)previousVC container:(UIView *)containerView context:(id<UIViewControllerContextTransitioning>)context {
    
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.fromVC) {
        return self;
    }
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (toVC == self.toVC) {//present
        [self presentVC:toVC fromVC:fromVC container:containerView context:transitionContext];
    } else {//dismiss
        [self dismissVC:fromVC toVC:toVC container:containerView context:transitionContext];
    }
}

@end
