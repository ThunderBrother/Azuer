//
//  UIScrollView+PullRefresh.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshHeaderView.h"
#import "OTSRefreshFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (PullRefresh)

@property (strong, nonatomic, nullable) OTSRefreshHeaderView *refreshHeader;
@property (strong, nonatomic, nullable) OTSRefreshFooterView *refreshFooter;


- (void)addRefreshHeaderWithBlock:(OTSRefreshHeaderBlock)aBlock;
- (void)addLoadMoreFooterWithBlock:(OTSRefreshFooterBlock)aBlock;

- (void)triggerRefreshing;

- (void)headerActionSuccessfully;
- (void)footerActionSuccessfully;

- (void)headerActionError:(NSString*)errorMsg;
- (void)footerActionError:(NSString*)errorMsg;

- (void)footerActionPause:(NSString*)pauseMsg;

@end

NS_ASSUME_NONNULL_END
