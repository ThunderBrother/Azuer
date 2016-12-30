//
//  UIViewController+RefreshAction.h
//  OTSKit
//
//  Created by wenjie on 16/12/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSIntentModel.h"

@interface UIViewController (RefreshAction)

@property (nonatomic, assign) UIScrollView *scrollView;

- (void)showRefreshActionWithScrollView:(UIScrollView *)scrollView action:(OTSActionOption)action message:(NSString *)message;

@end
