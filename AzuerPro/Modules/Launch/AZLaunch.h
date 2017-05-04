//
//  AZLaunch.h
//  AzuerPro
//
//  Created by zhangzuming on 12/31/16.
//  Copyright © 2016 Azuer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZLaunch : NSObject

+ (AZLaunch *)sharedInstance;

/**
 *  功能:window显示之前调用
 */
- (void)launchBeforeShowWindow;

/**
 *  功能:window显示之后调用
 */
- (void)launchAfterShowWindow;

/**
 *  功能:从后台到前台
 */
- (void)launchAfterEnterForeground;

@end
