//
//  OTSBannerContentView.h
//  OTSKit
//
//  Created by Jerry on 2017/1/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSAbstractContentView.h"

@class OTSCyclePageView;

@interface OTSBannerContentView : OTSAbstractContentView

@property (strong, nonatomic, readonly) OTSCyclePageView *pageView;
@property (strong, nonatomic, readonly) UIPageControl *pageControl;

@end
