//
//  JWRouter.m
//  JWIntent
//
//  Created by Jerry on 16/7/20.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSRouter.h"
#import "UIViewController+Switch.h"

@interface UIViewController (__OTSDismiss)

- (void)__dismissViewController;

@end

@implementation UIViewController (__OTSDismiss)

- (void)__dismissViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end

@interface OTSRouter()

@property (strong, nonatomic) UIViewController *source;
@property (strong, nonatomic) Class destinationClass;

@end

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
    UIViewController *sourceViewController = self.source;
    if (self.option & OTSRouterPresent) {
        UIViewController *targetDestination = self.destination;
        if (self.option & OTSRouterPresentOptionWrapNC) {
            targetDestination = [[UINavigationController alloc] initWithRootViewController:self.destination];
            
            UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSeperator.width = -16;
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self.destination action:@selector(__dismissViewController)];
            backItem.imageInsets = UIEdgeInsetsMake(0, 8, 0, -8);
            self.destination.navigationItem.leftBarButtonItems = @[negativeSeperator, backItem];
        }
        [sourceViewController presentViewController:targetDestination
                                           animated:animated
                                         completion:completionBlock];
        
    } else if (self.option & OTSRouterPush) {
        UINavigationController *navigationController = OTS__AutoGetNavigationViewController(self.source);
        NSAssert(navigationController, @"Trying to submit push action with no navigationController");
        
        BOOL shouldResetHideBottomBarWhenPushed = !self.source.hidesBottomBarWhenPushed;
        self.source.hidesBottomBarWhenPushed = true;
        [navigationController pushViewController:self.destination animated:animated];
        
        if (shouldResetHideBottomBarWhenPushed) {
            self.source.hidesBottomBarWhenPushed = false;
        }
        
        if (self.option & OTSRouterPushOptionClearTop) {
            navigationController.viewControllers = @[self.destination];
        } else if (self.option & OTSRouterPushOptionSingleTop) {
            NSMutableArray *copiedArray = [NSMutableArray array];
            for (UIViewController *aViewController in navigationController.viewControllers) {
                if (aViewController != self.destination &&
                    [aViewController isMemberOfClass:[self.destination class]]) {
                    continue;
                }
                [copiedArray addObject:aViewController];
            }
            navigationController.viewControllers = copiedArray;
        } else if(self.option & OTSRouterPushOptionRootTop) {
            if (navigationController.viewControllers.count > 2) {
                NSMutableArray *copiedArray = [NSMutableArray array];
                [copiedArray addObject:navigationController.viewControllers.firstObject];
                [copiedArray addObject:self.destination];
                navigationController.viewControllers = copiedArray;
            }
            
        } else if (self.option & OTSRouterPushOptionClearLast) {
            if (navigationController.viewControllers.count > 1) {
                NSMutableArray *copiedArray = navigationController.viewControllers.mutableCopy;
                [copiedArray removeObjectAtIndex:copiedArray.count - 2];
                navigationController.viewControllers = copiedArray.copy;
            }
        }
        
        if (completionBlock) {
            completionBlock();
        }
    } else if (self.option & OTSRouterChild) {
        [self.source addChildViewController:self.destination];
        self.destination.view.frame = self.source.view.bounds;
        self.destination.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.source.view addSubview:self.destination.view];
        [self.destination didMoveToParentViewController:self.source];
        
        if (completionBlock) {
            completionBlock();
        }
        
    } else if (self.option & OTSRouterSwitch) {
        UIViewController *comparedVC = self.source;
        while (comparedVC) {
            if ([comparedVC switchToDestinationVCClass:self.destinationClass]) {
                break;
            } else {
                comparedVC = comparedVC.parentViewController;
            }
        }
        if (completionBlock) {
            completionBlock();
        }
        
    } else {
        self.option = self.option | [self __autoGetActionOptions];
        [self __submitRouterWithCompletion:completionBlock];
    }
}

@end
