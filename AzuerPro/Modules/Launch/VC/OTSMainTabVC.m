//
//  OTSMainTabVC.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSMainTabVC.h"
#import <OTSKit/OTSKit.h>
#import <KVOController/KVOController.h>

@interface OTSMainTabVC ()<UITabBarControllerDelegate>

@end

@implementation OTSMainTabVC

+ (void)load {
    [[OTSIntentContext defaultContext] registerRouterClass:[self class] forKey:@"main"];
}

- (void)setExtraData:(NSDictionary *)extraData {
    [super setExtraData:extraData];
    self.delegate = self;
    [self __setupVCs];
    WEAK_SELF;
    [self.KVOController observe:[OTSGlobalValue sharedInstance] keyPath:@"cartCount" options:NSKeyValueObservingOptionInitial block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
        STRONG_SELF;
        [self __refreshAddCartCount];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isViewLoaded] && viewController.view.window) {
        
        UIViewController *targetVC = viewController;
        if ([targetVC isKindOfClass:[UINavigationController class]]) {
            targetVC = ((UINavigationController*)viewController).topViewController;
        }
        
        for (id subView in targetVC.view.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = subView;
                [scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:true];
                break;
            }
        }
    }
    return true;
}

#pragma mark - Private
- (void)__setupVCs {
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:4];
    {
        OTSRouter *router = [[OTSRouter alloc] initWithSource:self routerKey:@"home"];
        
        NSMutableDictionary *extraData = [NSMutableDictionary dictionary];
        [extraData safeSetObject:self.homeData forKey:@"cachedData"];
        router.extraData = extraData;
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:router.destination];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        OTSRouter *router = [[OTSRouter alloc] initWithSource:self routerKey:@"category"];
        
        NSMutableDictionary *extraData = [NSMutableDictionary dictionary];
        [extraData safeSetObject:self.categoryData forKey:@"cachedData"];
        router.extraData = extraData;
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:router.destination];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Category" image:[UIImage imageNamed:@"tabbar_category"] selectedImage:[UIImage imageNamed:@"tabbar_category_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        OTSRouter *router = [[OTSRouter alloc] initWithSource:self routerKey:@"cart"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:router.destination];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cart" image:[UIImage imageNamed:@"tabbar_cart"] selectedImage:[UIImage imageNamed:@"tabbar_cart_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        OTSRouter *router = [[OTSRouter alloc] initWithSource:self routerKey:@"mystore"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:router.destination];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage imageNamed:@"tabbar_account"] selectedImage:[UIImage imageNamed:@"tabbar_account_selected"]];
        [vcArray addObject:nc];
    }
    
    [self setViewControllers:vcArray.copy animated:false];
    self.selectedIndex = 0;
}

- (void)__refreshAddCartCount {
    [self performInMainThreadBlock:^{
        UINavigationController *nc = [self.viewControllers safeObjectAtIndex:2];
        OTSGlobalValue *value = [OTSGlobalValue sharedInstance];
        NSInteger count = value.cartCount.integerValue;
        if (count > 0) {
            if (count > 99) {
                nc.tabBarItem.badgeValue = @"99+";
            }
            else {
                nc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@ ",@(count)];
            }
        } else {
            nc.tabBarItem.badgeValue = nil;
        }
    }];
}

@end
