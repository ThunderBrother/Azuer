//
//  OTSCyclePageView.h
//  OneStoreFramework
//
//  Created by Aimy on 8/25/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTSCyclePageViewScrollDirection) {
    OTSCyclePageViewScrollDirectionHorizontal,
    OTSCyclePageViewScrollDirectionVertical
};

@class OTSCyclePageView;

@protocol OTSCyclePageViewDataSource <NSObject>

@required
/**
 *  轮播图数量
 *
 *
 */
- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView;
/**
 *  轮播图view
 *
 *  @param aPageView self
 *  @param aIndex    次序
 *
 */
- (UIView* _Nullable)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex reuseView: (UIView* _Nullable )oldView;

@end

@protocol OTSCyclePageViewDelegate <NSObject>

@optional
/**
 *  点击事件
 *
 */
- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex;

/**
 *	功能:从当前页 切换另一页时,此方法会被调用
 *
 *	@param pageView :
 *	@param aIndex   :另一页面的索引
 */
- (void)pageView:(OTSCyclePageView *)pageView didChangeToIndex:(NSUInteger)aIndex;

/**
 *  功能:非循环页面，滑动到最后一页继续往后滑动
 */
- (void)pageViewScrollEndOfPage:(OTSCyclePageView *)aPageView;

@end

@interface OTSCyclePageView : UIView

@property (nonatomic, weak, nullable) id <OTSCyclePageViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <OTSCyclePageViewDelegate> delegate;

/**
 *  reload之后显示第几个图片
 */
@property (nonatomic) NSInteger startPageIndex;

/**
 *  是否自动轮播
 */
@property (nonatomic) BOOL autoRunPage;
/**
 *  轮播循环间隔
 */
@property (nonatomic) NSTimeInterval interval;
/**
 *  分页控件
 */
@property (nonatomic, weak, nullable) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL disableCycle;//是否禁止循环

@property (nonatomic, assign) BOOL disableClickEffect;//是否禁止点击特效

@property (nonatomic, assign) OTSCyclePageViewScrollDirection scrollDirection;

@property (nonatomic) NSInteger currentPage;


/**
 *  显示第n个
 *
 */
- (void)showPageAtIndex:(NSUInteger)aIndex;
/**
 *  刷新数据
 */
- (void)reloadData;

- (void)runCyclePageView;

@end

NS_ASSUME_NONNULL_END
