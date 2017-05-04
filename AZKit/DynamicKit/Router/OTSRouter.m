//
//  JWRouter.m
//  JWIntent
//
//  Created by Jerry on 16/7/20.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSRouter.h"
#import "UIViewController+Switch.h"
#import "NSObject+Runtime.h"
#import "OTSTransition.h"
#import <Masonry/Masonry.h>

@interface UIViewController (__OTSDismiss)

- (void)__dismissViewController;

@end

@interface OTSModalVC : UIViewController

@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UIVisualEffectView *dimBlurView;
@property (assign, nonatomic) OTSRouterOption option;

- (void)addContentVC:(UIViewController*)contentVC;
- (void)presentModalVC;
- (void)dismissModalVCAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end

@interface OTSRouter()

@property (strong, nonatomic) UIViewController *source;
@property (strong, nonatomic) Class destinationClass;

@end

/*************************** OTSRouter ***************************/
@implementation OTSRouter

- (instancetype)initWithSource:(UIViewController*)source
                     routerKey:(NSString*)routerKey {
    return [self initWithSource:source routerKey:routerKey context:nil];
}

- (instancetype)initWithSource:(UIViewController *)source
                     routerKey:(NSString *)routerKey
                       context:(OTSIntentContext *)context {
    _context = context ?: [OTSIntentContext defaultContext];
    Class destinationClass = [_context routerClassForKey:routerKey];
    return [self initWithSource:source destinationClass:destinationClass];
}

- (instancetype)initWithSource:(nullable UIViewController*)source
              destinationClass:(Class)destinationClass {
    NSParameterAssert(destinationClass);
    if (self = [super init]) {
        self.source = source;
        self.destinationClass = destinationClass;
        NSAssert([self.destinationClass isSubclassOfClass:[UIViewController class]], @"%@ is not kind of UIViewController.class", self.destinationClass);
    }
    return self;
}

- (void)submitWithCompletion:(void (^)(void))completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        [OTSSharedKeyWindow endEditing:true];
        [super submitWithCompletion:completionBlock];
        if (!self.source) {
            self.source = OTS_AutoGetRootSourceViewController();
        }
        
        [self __submitRouterWithCompletion:completionBlock];
    });
}

#pragma mark - Setter & Getter
- (UIViewController*)destination {
    if (!_destination && self.destinationClass) {
        _destination = [[self.destinationClass alloc] init];
    }
    return _destination;
}

- (void)setExtraData:(NSDictionary *)extraData {
    [super setExtraData:extraData];
    if ([self.destination isKindOfClass:[NSObject class]]) {
        ((NSObject*)self.destination).extraData = extraData;
    }
}

- (NSUInteger)option {
    OTSRouterOption preferredRouterOption = [self.destinationClass preferredRouterType];
    if (preferredRouterOption) {
        return preferredRouterOption;
    }
    return _option;
}

#pragma mark - Private
- (OTSRouterOption)__autoGetActionOptions {
    if (self.source.navigationController || [self.source isKindOfClass:[UINavigationController class]]) {
        return OTSRouterPush;
    } else {
        return OTSRouterPresent;
    }
}

- (void)__submitRouterWithCompletion:(void (^)(void))completionBlock {
    
    BOOL animated = !(self.option & OTSRouterOptionCancelAnimation);
    if (self.option & OTSRouterPresent) {
        [self __executePresentCommandAnimated:animated completion:completionBlock];
    } else if (self.option & OTSRouterPush) {
        [self __executePushCommandAnimated:animated completion:completionBlock];
    } else if (self.option & OTSRouterChild) {
        [self __executeAddChildCommandAnimated:animated completion:completionBlock];
    } else if (self.option & OTSRouterSwitch) {
        [self __executeSwitchCommandAnimated:animated completion:completionBlock];
    } else if (self.option & OTSRouterModal) {
        [self __executeModalCommandAnimated:animated completion:completionBlock];
    } else {
        self.option = self.option | [self __autoGetActionOptions];
        [self __submitRouterWithCompletion:completionBlock];
    }
}

- (void)__executePresentCommandAnimated:(BOOL)animated completion:(void (^)(void))completionBlock {
    OTSRouterOption forbiddenRouterType = [self.destinationClass forbiddenRouterType];
    NSAssert(!(forbiddenRouterType & OTSRouterPresent), @"router type: present is not allowed by %@", self.destinationClass);
    
    UIViewController *targetDestination = self.destination;
    if (self.option & OTSRouterPresentOptionWrapNC) {
        targetDestination = [[UINavigationController alloc] initWithRootViewController:self.destination];
        
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -16;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self.destination action:@selector(__dismissViewController)];
        backItem.imageInsets = UIEdgeInsetsMake(0, 8, 0, -8);
        self.destination.navigationItem.leftBarButtonItems = @[negativeSeperator, backItem];
    }
    
    if (animated && [self.transitionClass isSubclassOfClass:[OTSTransition class]] ) {
        __kindof OTSTransition *aniamtion = [[self.transitionClass alloc] initWithFromVC:self.source toVC:targetDestination];
        
        [targetDestination objc_setAssociatedObject:@"OTSCustomeTransitionAnimation" value:aniamtion policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
        targetDestination.transitioningDelegate = aniamtion;
    }
    
    [self.source presentViewController:targetDestination
                                       animated:animated
                                     completion:completionBlock];
}

- (void)__executePushCommandAnimated:(BOOL)animated completion:(void (^)(void))completionBlock {
    UINavigationController *navigationController = OTS__AutoGetNavigationViewController(self.source);
    NSAssert(navigationController, @"Trying to submit push action with no navigationController");
    
    OTSRouterOption forbiddenRouterType = [self.destinationClass forbiddenRouterType];
    NSAssert(!(forbiddenRouterType & OTSRouterPush), @"router type: push is not allowed by %@", self.destinationClass);
    
    BOOL shouldResetHideBottomBarWhenPushed = !self.source.hidesBottomBarWhenPushed;
    self.source.hidesBottomBarWhenPushed = true;
    
    if (self.option & OTSRouterPushOptionClearTop) {
        for (UIViewController *vc in navigationController.viewControllers) {
            vc.isRemovingFromStack = true;
        }
    } else if (self.option & OTSRouterPushOptionSingleTop) {
        for (UIViewController *vc in navigationController.viewControllers) {
            if (vc != self.destination &&
                [vc isMemberOfClass:[self.destination class]]) {
                vc.isRemovingFromStack = true;
            }
        }
    } else if(self.option & OTSRouterPushOptionRootTop) {
        for (int i = 1; i < navigationController.viewControllers.count; i++) {
            UIViewController *vc = navigationController.viewControllers[i];
            vc.isRemovingFromStack = true;
        }
    } else if (self.option & OTSRouterPushOptionClearLast) {
        navigationController.viewControllers.lastObject.isRemovingFromStack = true;
    }
    
    [navigationController pushViewController:self.destination animated:animated];
    
    if (shouldResetHideBottomBarWhenPushed) {
        self.source.hidesBottomBarWhenPushed = false;
    }
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (UIViewController *vc in navigationController.viewControllers) {
        if (!vc.isRemovingFromStack) {
            [vcArray addObject:vc];
        }
    }
    [navigationController setViewControllers:vcArray.copy animated:true];
    
    if (completionBlock) {
        completionBlock();
    }
}

- (void)__executeAddChildCommandAnimated:(BOOL)animated completion:(void (^)(void))completionBlock {
    
    OTSRouterOption forbiddenRouterType = [self.destinationClass forbiddenRouterType];
    NSAssert(!(forbiddenRouterType & OTSRouterChild), @"router type: child is not allowed by %@", self.destinationClass);
    
    [self.source addChildViewController:self.destination];
    self.destination.view.frame = self.source.view.bounds;
    self.destination.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.source.view addSubview:self.destination.view];
    [self.destination didMoveToParentViewController:self.source];
    
    if (completionBlock) {
        completionBlock();
    }
}

- (void)__executeSwitchCommandAnimated:(BOOL)animated completion:(void (^)(void))completionBlock {
    if ([self.source isKindOfClass:self.destinationClass]) {
        return;
    }
    
    OTSRouterOption forbiddenRouterType = [self.destinationClass forbiddenRouterType];
    NSAssert(!(forbiddenRouterType & OTSRouterSwitch), @"router type: switch is not allowed by %@", self.destinationClass);
    
    [self.source viewWillDisappear:animated];
    UIViewController *comparedVC = self.source;
    while (comparedVC) {
        if ([comparedVC switchToDestinationVCClass:self.destinationClass]) {
            [self.source viewDidDisappear:animated];
            break;
        } else {
            comparedVC = comparedVC.parentViewController;
        }
    }
    if (completionBlock) {
        completionBlock();
    }
}

- (void)__executeModalCommandAnimated:(BOOL)animated completion:(void (^)(void))completionBlock {
    
    OTSRouterOption forbiddenRouterType = [self.destinationClass forbiddenRouterType];
    NSAssert(!(forbiddenRouterType & OTSRouterModal), @"router type: modal is not allowed by %@", self.destinationClass);
    
    OTSModalVC *modalVC = [[OTSModalVC alloc] init];
    modalVC.option = self.option;
    [modalVC addContentVC:self.destination];
    [modalVC presentModalVC];
    
    if (completionBlock) {
        completionBlock();
    }
}

@end

/*************************** UIViewController + __OTSDismiss ***************************/
@implementation UIViewController (__OTSDismiss)

- (void)__dismissViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

/*************************** UIViewController + OTSRouterStack ***************************/
@implementation UIViewController (OTSRouterStack)

static NSString *isRemovingFromStackKey = @"ots_isRemovingFromStack";

- (void)setIsRemovingFromStack:(BOOL)isRemovingFromStack {
    [self objc_setAssociatedObject:isRemovingFromStackKey value:@(isRemovingFromStack) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (BOOL)isRemovingFromStack {
    return [[self objc_getAssociatedObject:isRemovingFromStackKey] boolValue];
}

@end

/*************************** UIViewController + OTSRouterPermission ***************************/
@implementation UIViewController (OTSRouterPermission)

+ (OTSRouterOption)forbiddenRouterType {
    return 0;
}

+ (OTSRouterOption)preferredRouterType {
    return 0;
}

@end

/*************************** UIViewController + OTSModalDismiss ***************************/
@implementation UIViewController (OTSModalDismiss)

- (void)dismissModalVCAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIWindow *modalWindow = OTSSharedModalWindow;
    UIViewController *rootVC = modalWindow.rootViewController;
    if ([rootVC isKindOfClass:[OTSModalVC class]]) {
        [(id)rootVC dismissModalVCAnimated:flag completion:completion];
    }
    
    UIWindow *topWindow = OTSSharedTopWindow;
    rootVC = topWindow.rootViewController;
    if ([rootVC isKindOfClass:[OTSModalVC class]]) {
        [(id)rootVC dismissModalVCAnimated:flag completion:completion];
    }
}

@end


/*************************** OTSModalVC ***************************/
#import "UIView+Frame.h"

@implementation OTSModalVC

- (void)viewDidLoad {
    if (self.option & OTSRouterModalOptionOnTopWindow) {
        //do nothing
    } else if (self.option & OTSRouterModalOptionBlur) {
        [self.view addSubview:self.dimBlurView];
    } else {
        [self.view addSubview:self.dimView];
    }
}

- (void)addContentVC:(UIViewController*)contentVC {
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC isViewLoaded] && childVC.view.superview == self.view) {
            [childVC.view removeFromSuperview];
        }
        [childVC removeFromParentViewController];
    }
    
    [self addChildViewController:contentVC];
    UIView *contentView = contentVC.view;
    [self.view addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView.superview);
        if (self.option & OTSRouterModalOptionContentBottom) {
            make.bottom.equalTo(contentView.superview);
        } else if(self.option & OTSRouterModalOptionContentTop) {
            make.top.equalTo(contentView.superview);
        } else {//centered
            make.centerY.equalTo(contentView.superview);
        }
    }];
    
    [contentView layoutIfNeeded];
}

- (void)applyTransformForAnimation {
    UIViewController *childVC = self.childViewControllers.firstObject;
    if (!childVC) {
        return;
    }
    UIView *contentView = childVC.view;
    if (self.option & OTSRouterModalOptionContentBottom) {
        contentView.transform = CGAffineTransformMakeTranslation(0, contentView.height);
    } else if(self.option & OTSRouterModalOptionContentTop) {
        contentView.transform = CGAffineTransformMakeTranslation(0, -contentView.height);
    } else {//centered
        contentView.transform = CGAffineTransformMakeScale(0, 0);
    }
}

- (void)__dismissViewController {
    [self dismissModalVCAnimated:true completion:nil];
}

- (void)presentModalVC {
    UIViewController *childVC = self.childViewControllers.firstObject;
    if (!childVC) {
        return;
    }
    UIViewController *bottomRootVC = OTS_AutoGetRootSourceViewController();
    [bottomRootVC viewWillDisappear:true];
    
    UIView *contentView = childVC.view;
    
    if (self.option & OTSRouterOptionCancelAnimation) {
        _dimBlurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _dimView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.6];
    } else {
        [self applyTransformForAnimation];
        _dimBlurView.effect = nil;
        _dimView.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:.3 animations:^{
            _dimBlurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _dimView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.6];
            contentView.transform = CGAffineTransformIdentity;
        }];
    }
    
    UIWindow *topWindow = (self.option & OTSRouterModalOptionOnTopWindow ? OTSSharedTopWindow : OTSSharedModalWindow);
    topWindow.rootViewController = self;
    topWindow.hidden = false;
    
    [bottomRootVC viewDidDisappear:true];
}

- (void)dismissModalVCAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *bottomRootVC = OTS_AutoGetRootSourceViewController();
    [bottomRootVC viewWillAppear:animated];
    
    void (^ completionBlock)(BOOL finished) = ^(BOOL finished) {
        UIWindow *topWindow = (self.option & OTSRouterModalOptionOnTopWindow ? OTSSharedTopWindow : OTSSharedModalWindow);
        topWindow.rootViewController = [UIViewController new];
        topWindow.hidden = true;
        [bottomRootVC viewDidAppear:animated];
        if (completion) {
            completion();
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            _dimBlurView.effect = nil;
            _dimView.backgroundColor = [UIColor clearColor];
            [self applyTransformForAnimation];
        } completion:completionBlock];
    } else {
        completionBlock(true);
    }
}

#pragma mark - Getter & Setter
- (UIVisualEffectView*)dimBlurView {
    if (!_dimBlurView) {
        _dimBlurView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
        _dimBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__dismissViewController)];
        [_dimBlurView addGestureRecognizer:tap];
    }
    return _dimBlurView;
}

- (UIView*)dimView {
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
        _dimView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__dismissViewController)];
        [_dimView addGestureRecognizer:tapGes];
    }
    return _dimView;
}

@end
