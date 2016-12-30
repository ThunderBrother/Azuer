//
//  JWRefreshHeaderView.h
//  JWUIKit
//
//  Created by Jerry on 16/4/8.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSRefreshContentViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class OTSRefreshHeaderView;
typedef void (^OTSRefreshHeaderBlock)(OTSRefreshHeaderView *refreshView);

typedef NS_ENUM(NSInteger, OTSPullRefreshStyle) {
    OTSPullRefreshStyleStill,
    OTSPullRefreshStyleFollow
};

@interface OTSRefreshHeaderView : UIView

@property (assign, nonatomic) OTSPullRefreshStyle style;
@property (strong, nonatomic, nullable) NSString *contentViewClass;

@property (assign, nonatomic, readonly) OTSPullRefreshState state;
@property (strong, nonatomic, readonly) UIView<OTSRefreshContentViewProtocol> *contentView;

@property (copy, nonatomic, nullable) OTSRefreshHeaderBlock refreshingBlock;

- (void)startRefreshing;

- (void)endRefreshing;
- (void)endRefreshingWithDelay:(NSTimeInterval)delay;

- (void)pauseRefreshing;

@end

NS_ASSUME_NONNULL_END
