//
//  UIViewController+NavigationBarUtility.m
//  OTSKit
//
//  Created by Jerry on 2017/1/5.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "UIViewController+NavigationBarUtility.h"
#import "NSObject+Runtime.h"
#import "UIImage+Utility.h"
#import "UIColor+Utility.h"

@implementation UIViewController (NavigationBarUtility)

NSString *const OTSNavigationBarUtilityKey = @"OTSNavigationBarUtilityKey";

- (void)stashNavigationBarAttribute {
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    UINavigationBar *bar = self.navigationController.navigationBar;
    
    [attribute setObject:(bar.tintColor ?: [NSNull null]) forKey:@"tintColor"];
    [attribute setObject:(bar.barTintColor ?: [NSNull null]) forKey:@"barTintColor"];
    [attribute setObject:@(bar.barStyle) forKey:@"barStyle"];
    [attribute setObject:(bar.shadowImage ?: [NSNull null]) forKey:@"shadowImage"];
    [attribute setObject:(bar.titleTextAttributes ?: [NSNull null]) forKey:@"titleTextAttributes"];
    
    UIImage *backgroundImage = [bar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [attribute setObject:(backgroundImage ?: [NSNull null]) forKey:@"backgroundImage"];
    
    [self objc_setAssociatedObject:OTSNavigationBarUtilityKey value:attribute.copy policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)restoreNavigationBarAttribute {
    NSDictionary *attribute = [self objc_getAssociatedObject:OTSNavigationBarUtilityKey];
    if (attribute) {
        UINavigationBar *bar = self.navigationController.navigationBar;
        [attribute enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            id value = (obj == [NSNull null] ? nil : obj);
            if ([key isEqualToString:@"backgroundImage"]) {
                [bar setBackgroundImage:value forBarMetrics:UIBarMetricsDefault];
            } else {
                [bar setValue:value forKey:key];
            }
        }];
    }
}

- (void)removeStoredNavigationBarAttribute {
    [self objc_removeAssociatedObjectForPropertyName:OTSNavigationBarUtilityKey];
}

- (void)transparentNavigationBarWithStyle:(OTSNavigationBarTransparentStyle)style {
    NSDictionary *attribute = [self objc_getAssociatedObject:OTSNavigationBarUtilityKey];
    if (!attribute) {
        [self stashNavigationBarAttribute];
    }
    
    UIImage *backgroundImage = (style == OTSNavigationBarTransparentStyleBackgroundWhite ? [UIImage imageWithColor:[UIColor whiteColor]] : [UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:.0]]);
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithWhite:.0 alpha:.0]]];
    
    BOOL contentAboveBarShouldBeLight = style == OTSNavigationBarTransparentStyleContentLight;
    
    self.navigationController.navigationBar.barStyle = (contentAboveBarShouldBeLight ? UIBarStyleBlack : UIBarStyleDefault);
    self.navigationController.navigationBar.tintColor = (contentAboveBarShouldBeLight ? [UIColor whiteColor] : [UIColor colorWithRGB:0x333333]);
    
    NSDictionary *titleAttr = contentAboveBarShouldBeLight ? @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]} : @{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x333333],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
}

@end
