//
//  AppDelegate.h
//  AzuerPro
//
//  Created by zhangzuming on 12/26/16.
//  Copyright © 2016 Azuer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//key window
@property (strong, nonatomic) UIWindow *window;
//modal window(above key window)
@property (strong, nonatomic) UIWindow *modalWindow;
//top window(above alert window)
@property (strong, nonatomic) UIWindow *topWindow;

@end

