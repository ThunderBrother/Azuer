//
//  OTSFuncDefine.h
//  OneStoreFramework
//
//  Created by Aimy on 14-6-23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef OTSFuncDefine_h
#define OTSFuncDefine_h

typedef void(^OTSNoParamNoReturnBlock)(void);

typedef void(^OTSIndexAndValueNoReturnBlock)(NSUInteger index, id value);

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf


//init view
#define OTSViewInit \
\
- (instancetype)init {\
if (self = [super init]) {\
[self __setup];\
}\
return self;\
}\
\
- (instancetype)initWithCoder:(NSCoder *)aDecoder {\
if (self = [super initWithCoder:aDecoder]) {\
[self __setup];\
}\
return self;\
}\
\
- (instancetype)initWithFrame:(CGRect)frame {\
if (self = [super initWithFrame:frame]) {\
[self __setup];\
}\
return self;\
}\
\
- (void)__setup \

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//判断ios版本
#define IOS_SDK_MORE_THAN_OR_EQUAL(__num) [UIDevice currentDevice].systemVersion.floatValue >= (__num)
#define IOS_SDK_MORE_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue > (__num)
#define IOS_SDK_LESS_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue < (__num)

//判断设备
#define IS_IPAD_DEVICE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE_DEVICE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define ISIPHONE3_5  CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_0  CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE4_7  CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE5_5  CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE9_7  CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] bounds].size)
#define ISIPHONE9_7_LAND  CGSizeEqualToSize(CGSizeMake(1024, 768), [[UIScreen mainScreen] bounds].size)

//判断横竖屏
#define IS_LANDSCAPE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)

//横竖屏宽度
#define UI_CURRENT_SCREEN_HEIGHT (IS_LANDSCAPE?(IOS_SDK_LESS_THAN(8.0)?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height)):([[UIScreen mainScreen] bounds].size.height))

#define UI_CURRENT_SCREEN_WIDTH (IS_LANDSCAPE?\
(IOS_SDK_LESS_THAN(8.0)?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width))\
:([[UIScreen mainScreen] bounds].size.width))

#define UI_REFRENCE_WIDTH MIN(UI_CURRENT_SCREEN_HEIGHT, UI_CURRENT_SCREEN_WIDTH)

//默认间距
#define UI_DEFAULT_PADDING 15.0
#define UI_DEFAULT_MARGIN 10.0

#define OTSSharedKeyWindow ((UIWindow*)[((NSObject*)[UIApplication sharedApplication].delegate) valueForKey:@"window"])
#define OTSSharedModalWindow ((UIWindow*)[((NSObject*)[UIApplication sharedApplication].delegate) valueForKey:@"modalWindow"])
#define OTSSharedTopWindow ((UIWindow*)[((NSObject*)[UIApplication sharedApplication].delegate) valueForKey:@"topWindow"])

// 本地化
#define OTSSTRING(_str)  NSLocalizedString((_str),(_str))

//remove perform selector leak warning
#define OTSSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* OTSFuncDefine_h */


