//
//  UIScrollView+PullRefresh.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIScrollView+PullRefresh.h"
#import "NSObject+Runtime.h"
#import "UIView+Frame.h"
#import "NSObject+FBKVOController.h"
#import "AZFuncDefine.h"

@implementation UIScrollView (PullRefresh)

#pragma mark - Public
- (void)addRefreshHeaderWithBlock:(OTSRefreshHeaderBlock)aBlock {
    OTSRefreshHeaderView *headerView = [[OTSRefreshHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, .0)];
    headerView.refreshingBlock = aBlock;

    WEAK_SELF;
    [self.KVOController observe:headerView keyPath:@"state" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
        STRONG_SELF;
        OTSPullRefreshState newState = [change[NSKeyValueChangeNewKey] integerValue];
        if (newState == OTSPullRefreshStateRefreshing) {
            [self.refreshFooter endRefreshing];
        }
    }];
    
    self.refreshHeader = headerView;
}

- (void)addLoadMoreFooterWithBlock:(OTSRefreshFooterBlock)aBlock {
    OTSRefreshFooterView *footerView = [[OTSRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, self.width, .0)];
    footerView.refreshingBlock = aBlock;
    self.refreshFooter = footerView;
}

- (void)triggerRefreshing {
    [self.refreshHeader startRefreshing];
}

- (void)headerActionError:(NSString*)errorMsg {
    if (self.refreshHeader.state == OTSPullRefreshStateRefreshing) {
        [self.refreshHeader pauseRefreshing];
    }
    if ([self.refreshHeader.contentView respondsToSelector:@selector(loadedError:)]) {
        [self.refreshHeader.contentView loadedError:errorMsg];
    }
}

- (void)footerActionError:(NSString*)errorMsg {
    if (self.refreshFooter.state == OTSPullRefreshStateRefreshing) {
        [self.refreshFooter pauseRefreshing];
    }
    if ([self.refreshFooter.contentView respondsToSelector:@selector(loadedError:)]) {
        [self.refreshFooter.contentView loadedError:errorMsg];
    }
}

- (void)footerActionPause:(NSString*)pauseMsg {
    if (self.refreshFooter.state == OTSPullRefreshStateRefreshing) {
        [self.refreshFooter pauseRefreshing];
    }
    self.refreshFooter.hidden = false;
    if ([self.refreshFooter.contentView respondsToSelector:@selector(loadedPause:)]) {
        [self.refreshFooter.contentView loadedPause:pauseMsg];
    }
}

- (void)headerActionSuccessfully {
    if (self.refreshHeader.state != OTSPullRefreshStateIdle) {
        if ([self.refreshHeader.contentView respondsToSelector:@selector(loadedSuccess)]) {
            [self.refreshHeader.contentView loadedSuccess];
            [self.refreshHeader endRefreshingWithDelay:.6];
        } else {
            [self.refreshHeader endRefreshing];
        }
    }
}

- (void)footerActionSuccessfully {
    if (self.refreshFooter.state != OTSPullRefreshStateIdle) {
        [self.refreshHeader endRefreshing];
        self.refreshFooter.hidden = true;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshFooter endRefreshing];
        });   
    }
}

#pragma mark - Getter & Setter
- (OTSRefreshHeaderView*)refreshHeader {
    return [self objc_getAssociatedObject:@"ots_refresh_header"];
}

- (void)setRefreshHeader:(OTSRefreshHeaderView *)refreshHeader {
    if (self.refreshHeader) {
        [self.refreshHeader removeFromSuperview];
    }
    if (refreshHeader) {
        [self addSubview:refreshHeader];
    }
    [self objc_setAssociatedObject:@"ots_refresh_header" value:refreshHeader policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (OTSRefreshFooterView*)refreshFooter {
    return [self objc_getAssociatedObject:@"ots_refresh_footer"];
}

- (void)setRefreshFooter:(OTSRefreshFooterView *)refreshFooter {
    if (self.refreshFooter) {
        [self.refreshFooter removeFromSuperview];
    }
    if (refreshFooter) {
        [self addSubview:refreshFooter];
    }
    [self objc_setAssociatedObject:@"ots_refresh_footer" value:refreshFooter policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end
