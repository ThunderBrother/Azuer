//
//  UIViewController+RefreshAction.m
//  OTSKit
//
//  Created by wenjie on 16/12/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIViewController+RefreshAction.h"
#import "UIScrollView+PullRefresh.h"
#import <objc/runtime.h>

@implementation UIViewController (RefreshAction)

- (void)setScrollView:(UIScrollView *)scrollView{
    
    objc_setAssociatedObject(self, @"ots_vc_scrollview", scrollView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)scrollView{
    
    return objc_getAssociatedObject(self, @"ots_vc_scrollview");
}


- (void)showRefreshActionWithScrollView:(UIScrollView *)scrollView action:(OTSActionOption)action message:(NSString *)message{
    
    if (scrollView != nil) {
        
        if (action & OTSActionOptionHeaderSuccessfully && scrollView.refreshHeader) {
            [scrollView headerActionSuccessfully];
        }
        
        if (action & OTSActionOptionFooterSuccessfully && scrollView.refreshFooter) {
            [scrollView footerActionSuccessfully];
        }
        
        if (action & OTSActionOptionHeaderError && scrollView.refreshHeader) {
            [scrollView headerActionError:message];
        }
        
        if (action & OTSActionOptionFooterError && scrollView.refreshFooter) {
            [scrollView footerActionError:message];
        }
        
        if (action & OTSActionOptionFooterPause && scrollView.refreshFooter) {
            [scrollView footerActionPause:message];
        }
        
    }
}


@end
