//
//  UIViewController+Switch.m
//  OTSKit
//
//  Created by Jerry on 16/10/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIViewController+Switch.h"

@implementation UIViewController (Switch)

- (BOOL)switchToDestinationVCClass:(Class)aClass {
    NSArray *viewControllers = self.childViewControllers;
    for (int i = 0; i < viewControllers.count; i++) {
        id aVC = viewControllers[i];
        if ([aVC isMemberOfClass:aClass] && [self switchToVCAtIndex:i]) {
            return true;
        } else if([aVC isKindOfClass:[UITabBarController class]]) {
            BOOL hasFound = [aVC switchToDestinationVCClass:aClass];
            if (hasFound && [self switchToVCAtIndex:i]) {
                return true;
            }
        } else if([aVC isKindOfClass:[UINavigationController class]]) {
            BOOL hasFound = [aVC switchToDestinationVCClass:aClass];
            if (hasFound && [self switchToVCAtIndex:i]) {
                return true;
            }
        }
    }
    return false;
}

- (BOOL)switchToVCAtIndex:(NSInteger)index {
    NSArray *viewControllers = self.childViewControllers;
    if (index >= 0 && index < viewControllers.count) {
        UIViewController *selectedVC = viewControllers[index];
        [selectedVC viewWillAppear:true];
        if ([self isKindOfClass:[UITabBarController class]]) {
            ((UITabBarController*)self).selectedIndex = index;
        } else if([self isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController*)self) popToViewController:viewControllers[index] animated:true];
        }
        [selectedVC viewDidAppear:true];
        return true;
    } else {
        return false;
    }
}

@end
