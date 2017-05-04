//
//  OTSAssociatedTransition.m
//  OTSKit
//
//  Created by Jerry on 2017/2/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSAssociatedTransition.h"
#import "NSArray+safe.h"

@implementation OTSAssociatedTransition

#pragma mark - Override
- (void)presentVC:(UIViewController *)vcToBePresent
           fromVC:(UIViewController *)fromVC
        container:(UIView *)containerView
          context:(id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalFrame = [context finalFrameForViewController:vcToBePresent];
    vcToBePresent.view.frame = finalFrame;
    vcToBePresent.view.alpha = .0;
    [containerView addSubview:vcToBePresent.view];
    
    NSArray<UIView*> *fromViews, *toViews = nil;
    NSArray<NSValue*> *fromFixedFrames, *toFixedFrames = nil;
    
    [self calculateFromViews:&fromViews toViews:&toViews fromFixedFrames:&fromFixedFrames toFixedFrames:&toFixedFrames];
    [self deliveryParamBeforeTransitionBySender:self.fromVC executer:self.toVC];
    
    NSMutableArray *snapshotViewArray = [NSMutableArray arrayWithCapacity:fromViews.count];
    
    for (UIView *aView in toViews) {
        aView.hidden = true;
    }
    
    for (int i = 0; i < fromViews.count; i++) {
        UIView *aView = fromViews[i];
        UIView *snapshotView = [self createSnapshotViewWithReferenceView:aView referenceFrame:[[fromFixedFrames safeObjectAtIndex:i] CGRectValue] containerView:containerView];
        [snapshotViewArray addObject:snapshotView];
        [containerView addSubview:snapshotView];
    }
    
    [UIView animateWithDuration:self.duration animations:^{
        vcToBePresent.view.alpha = 1.0;
        for (int i = 0; i < snapshotViewArray.count; i++) {
            UIView *snapShopView = snapshotViewArray[i];
            UIView *desView = [toViews safeObjectAtIndex:i];
            CGRect desRect;
            if (toFixedFrames) {
                desRect = [desView.superview convertRect:[toFixedFrames safeObjectAtIndex:i].CGRectValue toView:containerView];
            } else {
                desRect = [desView.superview convertRect:desView.frame toView:containerView];
            }
            snapShopView.frame = desRect;
        }
        
    } completion:^(BOOL finished) {
        for (UIView *snapshotView in snapshotViewArray) {
            [snapshotView removeFromSuperview];
        }
        
        for (UIView *aView in toViews) {
            aView.hidden = false;
        }
        
        for (UIView *aView in fromViews) {
            aView.hidden = false;
        }
        
        [context completeTransition:YES];
    }];
}

- (void)dismissVC:(UIViewController *)vcToBeDismissed toVC:(UIViewController *)toVC container:(UIView *)containerView context:(id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalFrame = [context finalFrameForViewController:toVC];
    toVC.view.frame = finalFrame;
    [containerView insertSubview:toVC.view belowSubview:vcToBeDismissed.view];
    
    NSArray<UIView*> *fromViews, *toViews = nil;
    NSArray<NSValue*> *fromFixedFrames, *toFixedFrames = nil;
    
    [self calculateFromViews:&fromViews toViews:&toViews fromFixedFrames:&fromFixedFrames toFixedFrames:&toFixedFrames];
    [self deliveryParamBeforeTransitionBySender:self.toVC executer:self.fromVC];
    
    
    NSMutableArray *snapshotViewArray = [NSMutableArray arrayWithCapacity:toViews.count];
    
    for (UIView *aView in fromViews) {
        aView.hidden = true;
    }
    
    for (int i = 0; i < toViews.count; i++) {
        UIView *aView = toViews[i];
        
        UIView *snapshotView = [self createSnapshotViewWithReferenceView:aView referenceFrame:[[toFixedFrames safeObjectAtIndex:i] CGRectValue] containerView:containerView];
        [snapshotViewArray addObject:snapshotView];
        [containerView addSubview:snapshotView];
    }
    
    [UIView animateWithDuration:self.duration animations:^{
        vcToBeDismissed.view.alpha = .0;
        
        for (int i = 0; i < snapshotViewArray.count; i++) {
            UIView *snapShopView = snapshotViewArray[i];
            UIView *desView = [fromViews safeObjectAtIndex:i];
            
            CGRect desRect;
            if (fromFixedFrames) {
                desRect = [desView.superview convertRect:[fromFixedFrames safeObjectAtIndex:i].CGRectValue toView:containerView];
            } else {
                desRect = [desView.superview convertRect:desView.frame toView:containerView];
            }
            snapShopView.frame = desRect;
        }
        
    } completion:^(BOOL finished) {
        
        vcToBeDismissed.view.alpha = 1.0;
        [vcToBeDismissed.view removeFromSuperview];
        
        for (UIView *snapshotView in snapshotViewArray) {
            [snapshotView removeFromSuperview];
        }
        
        for (UIView *aView in toViews) {
            aView.hidden = false;
        }
        
        for (UIView *aView in fromViews) {
            aView.hidden = false;
        }
        
        [context completeTransition:YES];
    }];
}

#pragma mark - Private
- (void)calculateFromViews:(out NSArray<UIView*> **)fromViews
                   toViews:(out NSArray<UIView*> **)toViews
           fromFixedFrames:(out NSArray<NSValue*> **)fromFixedFrames
             toFixedFrames:(out NSArray<NSValue*> **)toFixedFrames {
    
    NSAssert([self.toVC respondsToSelector:@selector(viewsForAssociatedTransitionAnimation)], @"%@ must respondToSelector viewsForAssociatedTransitionAnimation", self.toVC);
    NSAssert([self.fromVC respondsToSelector:@selector(viewsForAssociatedTransitionAnimation)], @"%@ must respondToSelector viewsForAssociatedTransitionAnimation", self.fromVC);
    
    *fromViews = [(id)self.fromVC viewsForAssociatedTransitionAnimation];
    *toViews = [(id)self.toVC viewsForAssociatedTransitionAnimation];
    
    if ([self.fromVC respondsToSelector:@selector(fixedFramesForAssociatedTransitionAnimation)]) {
        *fromFixedFrames = [(id)self.fromVC fixedFramesForAssociatedTransitionAnimation];
        if ((*fromViews).count && (*fromFixedFrames).count != (*fromViews).count) {
            *fromFixedFrames = nil;
        }
    }
    
    if ([self.toVC respondsToSelector:@selector(fixedFramesForAssociatedTransitionAnimation)]) {
        *toFixedFrames = [(id)self.toVC fixedFramesForAssociatedTransitionAnimation];
        if ((*toViews).count && (*toFixedFrames).count != (*toViews).count) {
            *toFixedFrames = nil;
        }
    }
}

- (UIView*)createSnapshotViewWithReferenceView:(UIView*)aView
                             referenceFrame:(CGRect)destFrame
                              containerView:(UIView*)containerView {
    UIView *snapshotView = nil;
    if (!CGRectEqualToRect(destFrame, CGRectZero)) {
    
        CGFloat offsetX, offsetY = 0;
        if ([aView isKindOfClass:[UIScrollView class]]) {
            offsetX = ((UIScrollView*)aView).contentOffset.x;
            offsetY = ((UIScrollView*)aView).contentOffset.y;
        }
        
        snapshotView = [aView resizableSnapshotViewFromRect:CGRectMake((aView.frame.size.width - destFrame.size.width) * .5 + offsetX, (aView.frame.size.height - destFrame.size.height) * .5 + offsetY, destFrame.size.width, destFrame.size.height) afterScreenUpdates:false withCapInsets:UIEdgeInsetsZero];
        snapshotView.frame = [aView.superview convertRect:destFrame toView:containerView];
        
    } else {
        snapshotView = [aView snapshotViewAfterScreenUpdates:false];
        snapshotView.frame = [aView.superview convertRect:aView.frame toView:containerView];
    }
    
    aView.hidden = true;
    
    return snapshotView;
}

- (void)deliveryParamBeforeTransitionBySender:(UIViewController*)sender
                                     executer:(UIViewController*)executor {
    if ([executor respondsToSelector:@selector(transitionWillBeginWithParam:)]) {
        NSDictionary *inputParam = nil;
        if ([sender respondsToSelector:@selector(paramBeforeTransitionBegin)]) {
            inputParam = [(id)sender paramBeforeTransitionBegin];
        }
        [(id)executor transitionWillBeginWithParam:inputParam];
    }
}

@end
