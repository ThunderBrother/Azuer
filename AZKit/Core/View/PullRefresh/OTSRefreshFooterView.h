//
//  OTSRefreshFooterView.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class OTSRefreshFooterView;
typedef void (^OTSRefreshFooterBlock)(OTSRefreshFooterView *refreshView);

@interface OTSRefreshFooterView : UIView

@property (strong, nonatomic, nullable) NSString *contentViewClass;

@property (assign, nonatomic, readonly) OTSPullRefreshState state;
@property (strong, nonatomic, readonly) UIView<OTSRefreshContentViewProtocol> *contentView;

@property (assign, nonatomic) CGFloat preFetchedDistance;

@property (copy, nonatomic, nullable) OTSRefreshFooterBlock refreshingBlock;

- (void)endRefreshing;
- (void)pauseRefreshing;

@end

NS_ASSUME_NONNULL_END
