//
//  OTSBannerCollectionViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBannerCollectionViewCell.h"
#import "OTSCollectionViewItem.h"

@interface OTSCollectionViewCell ()

- (UICollectionView *)__getCollectionView;

@end

@interface OTSBannerCollectionViewCell()<OTSCyclePageViewDelegate, OTSCyclePageViewDataSource>

@property (strong, nonatomic) NSArray<OTSCollectionViewItem*> *itemsArray;

@end

@implementation OTSBannerCollectionViewCell

@synthesize pageView = _pageView;
@synthesize pageControl = _pageControl;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.pageView];
        [self.contentView addSubview:self.pageControl];
        self.pageView.pageControl = self.pageControl;
    }
    return self;
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
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:[self __getCollectionView] didSelectItemAtIndexPath:indexPath];
    }
}

- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex reuseView: (UIView*)oldView {
    OTSCollectionViewItem *item = [self.itemsArray safeObjectAtIndex:aIndex];
    if (![item isKindOfClass:[OTSCollectionViewItem class]]) {
        return nil;
    }
    
    OTSPlaceHolderImageView *aImageView = nil;
    if ([oldView isKindOfClass:[OTSPlaceHolderImageView class]]) {
        aImageView = (id)oldView;
    } else {
        aImageView = [[OTSPlaceHolderImageView alloc] initWithFrame:aPageView.bounds];
    }
    
    [aImageView applyAttribute:item.imageAttribute];
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
