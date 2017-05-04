//
//  UIViewController+NavigationBarUtility.h
//  OTSKit
//
//  Created by Jerry on 2017/1/5.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OTSNavigationBarTransparentStyle){
    OTSNavigationBarTransparentStyleContentLight,//content above bar should be light, used when item behind the bar be dark
    OTSNavigationBarTransparentStyleContentDark,
    OTSNavigationBarTransparentStyleBackgroundWhite//transparent navigation bar and set bar white
};

@interface UIViewController (NavigationBarUtility)

//stash current navigation bar attribute
- (void)stashNavigationBarAttribute;

//restore stashed navigation bar attribute
- (void)restoreNavigationBarAttribute;

- (void)removeStoredNavigationBarAttribute;

//transparent navigation bar(clear bar background image, bar tint color and shadow image) with different styles
- (void)transparentNavigationBarWithStyle:(OTSNavigationBarTransparentStyle)style;

@end
