//
//  OTSTransition.h
//  OTSKit
//
//  Created by Jerry on 2017/2/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSTransition : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) NSTimeInterval duration; //default is .5;
@property (weak, nonatomic, readonly) UIViewController *fromVC;
@property (weak, nonatomic, readonly) UIViewController *toVC;

- (instancetype)initWithFromVC:(UIViewController*)fromVC
                          toVC:(UIViewController*)toVC NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

//from -> to
- (void)presentVC:(UIViewController*)transitionVCToBePresent
           fromVC:(UIViewController*)transitionFromVC
        container:(UIView*)transitionContainerView
          context:(id<UIViewControllerContextTransitioning>)transitionContext;;

//to -> from
- (void)dismissVC:(UIViewController*)transitionVCToBeDismissed
             toVC:(UIViewController*)transitionToVC
        container:(UIView*)transitionContainerView
          context:(id<UIViewControllerContextTransitioning>)context;

@end

@protocol OTSTransitionAnimationDelegate <NSObject>

- (void)transitionWillBeginWithParam:(NSDictionary*)param;//e.g., when A -> B, after transition, B will receive param sent from A

@end

@protocol OTSTransitionAnimationDataSource <NSObject>

@optional
- (NSArray<UIView*>*)viewsForAssociatedTransitionAnimation;
- (NSArray<NSValue*>*)fixedFramesForAssociatedTransitionAnimation;//NSValue(CGRect)
- (NSDictionary*)paramBeforeTransitionBegin;//e.g., when A -> B, before transition, animation will delivery A's param to B

@end

NS_ASSUME_NONNULL_END
