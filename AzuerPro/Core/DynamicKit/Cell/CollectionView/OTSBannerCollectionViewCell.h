//
//  OTSBannerCollectionViewCell.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

@interface OTSBannerCollectionViewCell : OTSCollectionViewCell

@property (strong, nonatomic, readonly) OTSCyclePageView *pageView;
@property (strong, nonatomic, readonly) UIPageControl *pageControl;

@end
