//
//  OTSWebVC.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/21.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSWebVC : UIViewController

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *htmlContents;
@property (copy, nonatomic) NSString *injectionScript;//在document加载结束以后执行
@property (copy, nonatomic) NSNumber *prohibitedPanPop;//禁止返回手势

@property (copy, nonatomic) BOOL (^navigationRespondBlock)(NSString *urlString);//webview即将跳转时调用，true为同意跳转
@property (copy, nonatomic) void (^didFinishLoadBlock)(void);//webview加载结束时调用
@property (copy, nonatomic) void (^didPopBlock)(void);//OTSWebVC dismiss时候调用

@property (copy, nonatomic) void (^doneButtonItemBlock)(void);
@property (copy, nonatomic) NSNumber *isImageFile;
@property (copy, nonatomic) NSString *textOrImage;

@end
