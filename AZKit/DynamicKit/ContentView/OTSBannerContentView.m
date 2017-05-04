//
//  OTSBannerContentView.m
//  OTSKit
//
//  Created by Jerry on 2017/1/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSBannerContentView.h"
#import "AZFuncDefine.h"
#import "OTSCyclePageView.h"
#import "OTSViewModelItem.h"
#import "OTSPlaceHolderImageView.h"
#import "NSArray+safe.h"
#import "UIView+Frame.h"

@interface OTSBannerContentView()<OTSCyclePageViewDelegate, OTSCyclePageViewDataSource>

@property (strong, nonatomic) NSArray<OTSViewModelItem*> *itemsArray;

@end

@implementation OTSBannerContentView

@synthesize pageView = _pageView;
@synthesize pageControl = _pageControl;

OTSViewInit {
    [self addSubview:self.pageView];
    [self addSubview:self.pageControl];
    self.pageView.pageControl = self.pageControl;
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[NSArray class]] || aData == self.itemsArray) {
        return;
    }
    self.itemsArray = aData;
    self.pageView.autoRunPage = self.itemsArray.count > 1;
    self.pageView.disableCycle = self.itemsArray.count <= 1;
    self.pageControl.hidden = self.itemsArray.count <= 1;
    [self.pageView reloadData];
}

#pragma mark - OTSCyclePageViewDelegate & OTSCyclePageViewDataSource
- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView {
    return self.itemsArray.count;
}

- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:aIndex inSection:self.indexPath.section];
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
}

- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex reuseView: (UIView*)oldView {
    OTSViewModelItem *item = [self.itemsArray safeObjectAtIndex:aIndex];
    if (![item isKindOfClass:[OTSViewModelItem class]]) {
        return nil;
    }
    
    OTSPlaceHolderImageView *aImageView = nil;
    if ([oldView isKindOfClass:[OTSPlaceHolderImageView class]]) {
        aImageView = (id)oldView;
    } else {
        aImageView = [[OTSPlaceHolderImageView alloc] initWithFrame:aPageView.bounds];
    }
    
    [aImageView applyAttribute:item.imageAttribute delegate:self.delegate];
    return aImageView;
}

#pragma mark - Getter & Setter
- (OTSCyclePageView*)pageView {
    if (!_pageView) {
        _pageView = [[OTSCyclePageView alloc] initWithFrame:self.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageView.autoRunPage = YES;
        _pageView.delegate = self;
        _pageView.dataSource = self;
    }
    return _pageView;
}

- (UIPageControl*)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 40, self.width, 30)];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pageControl.userInteractionEnabled = false;
    }
    return _pageControl;
}

@end
