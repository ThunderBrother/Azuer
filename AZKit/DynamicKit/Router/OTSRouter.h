//
//  JWRouter.h
//  JWIntent
//
//  Created by Jerry on 16/7/20.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSIntent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSRouter : OTSIntent

@property (strong, nonatomic, readonly) UIViewController *source;
@property (strong, nonatomic, readonly) Class destinationClass;

@property (strong, nonatomic, readonly) UIViewController *destination;
@property (strong, nonatomic) Class transitionClass;//custom transition animation, must be subclass of OTSTransition. Only custom presentation animation is supported.

/**
 *  Init function.
 *
 *  @param source        if not set, will auto iterate window and get a UIViewController to perform router
 *  @param routerKey     used to create destination UIViewController stored in context
 *
 */
#pragma warning - Source cannot hold OTSRouter
- (instancetype)initWithSource:(nullable UIViewController*)source
                     routerKey:(NSString*)routerKey;

/**
 *  Init function.
 *
 *  @param source        if not set, will auto iterate window and get a UIViewController to perform router
 *  @param routerKey     used to create destinationUIViewController stored in context
 *  @param context       if NULL, will use default context
 *
 */
#pragma warning - Source cannot hold OTSRouter
- (instancetype)initWithSource:(nullable UIViewController*)source
                     routerKey:(NSString*)routerKey
                       context:(nullable OTSIntentContext*)context;

- (instancetype)initWithSource:(nullable UIViewController*)source
              destinationClass:(Class)destinationClass;

@end

@interface UIViewController (OTSRouterStack)

@property (assign, nonatomic) BOOL isRemovingFromStack;

@end

@interface UIViewController (OTSModalDismiss)

- (void)dismissModalVCAnimated:(BOOL)flag completion:(void (^__nullable)(void))completion;

@end

@interface UIViewController (OTSRouterPermission)

+ (OTSRouterOption)forbiddenRouterType; //default is 0, meaning forbid nothing
+ (OTSRouterOption)preferredRouterType; //default is 0, meaning doing nothing. if greater than 0, router option will be ignored and preferred router type will be used

@end

NS_ASSUME_NONNULL_END
