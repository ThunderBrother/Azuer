//
//  OTSCyclePageView.m
//  OneStoreFramework
//
//  Created by Aimy on 8/25/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSCyclePageView.h"
#import "OTSCollectionViewCell.h"

@interface OTSCyclePageView () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *contentView;
@property (nonatomic) NSUInteger totalPageCount;
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation OTSCyclePageView

#pragma mark - Property
- (void)setDisableCycle:(BOOL)disableCycle
{
    _disableCycle = disableCycle;
    //非循环页面可以bounce
    if (disableCycle) {
        self.contentView.bounces = YES;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _OTSPageView_setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _OTSPageView_setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.contentView.collectionViewLayout;
    if (CGSizeEqualToSize(flowLayout.itemSize, CGSizeZero)) {
        flowLayout.itemSize = self.bounds.size;
    }
}

- (UICollectionViewScrollDirection)collectionViewScrollDirection {
    return self.scrollDirection == OTSCyclePageViewScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
}

- (UICollectionViewScrollPosition)collectionViewScrollPosition {
    return self.scrollDirection == OTSCyclePageViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft : UICollectionViewScrollPositionTop;
}

- (void)_OTSPageView_setup
{
    self.interval = 5.f;
    self.scrollDirection = OTSCyclePageViewScrollDirectionHorizontal;
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = [self collectionViewScrollDirection];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = self.bounds.size;
        self.contentView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor = self.backgroundColor;
        self.contentView.dataSource = self;
        self.contentView.delegate = self;
        self.contentView.pagingEnabled = YES;
        self.contentView.scrollsToTop = NO;
        self.contentView.bounces = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self.contentView registerClass:[OTSCollectionViewCell class] forCellWithReuseIdentifier:[OTSCollectionViewCell cellReuseIdentifier]];
        
        [self addSubview:self.contentView];
    }
    
    [self sendSubviewToBack:self.contentView];
}

- (void)setScrollDirection:(OTSCyclePageViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.contentView.collectionViewLayout;
    flowLayout.scrollDirection = [self collectionViewScrollDirection];
}

- (void)reloadData
{
    [self.timer invalidate];
    self.totalPageCount = 0;
    self.pageCount = 0;
    
    NSUInteger count = [self.dataSource numberOfPagesInPageView:self];
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = self.startPageIndex;
    
    if (!count) {
        return ;
    }
    
    self.pageCount = count;
    if (!self.disableCycle) {//循环页面额外增加两页
        self.totalPageCount = count + 2;
    }
    else {
        self.totalPageCount = count;
    }
    
    [self reloadViews];
    
    [self runAutoPage];
}

- (void)reloadViews
{
    [self.contentView reloadData];
    [self showPageAtIndex:self.startPageIndex];
}

- (void)showPageAtIndex:(NSUInteger)aIndex
{
    if (!self.disableCycle && aIndex == 0) {
        [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageCount inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:NO];
    }
    else {
        [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:aIndex inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:NO];
    }
}

#pragma mark - Collection view data souce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OTSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[OTSCollectionViewCell cellReuseIdentifier] forIndexPath:indexPath];
    
    UIView *oldView = [cell.contentView.subviews firstObject];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    UIView *view = [self.dataSource pageView:self pageAtIndex:indexPath.item % self.pageCount reuseView:oldView];
    if (view) {
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [cell.contentView addSubview:view];
    }
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (!self.disableClickEffect) {
        self.layer.opacity = .5f;
        [UIView animateWithDuration:.5f animations:^{
            self.layer.opacity = 1.f;
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectedPageAtIndex:)]) {
        if (self.pageControl) {
            [self.delegate pageView:self didSelectedPageAtIndex:self.pageControl.currentPage];
        }
        else {
            
            if (self.pageCount != 0) {
                NSUInteger index = indexPath.item % self.pageCount;
                
                [self.delegate pageView:self didSelectedPageAtIndex:index];
            }
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.contentView indexPathForItemAtPoint:scrollView.contentOffset];
    
    NSInteger lastPage = self.currentPage;
    self.currentPage = indexPath.item % self.pageCount;
    
    if (lastPage != self.currentPage) {
        self.pageControl.currentPage = self.currentPage;
        
        if ([self.delegate respondsToSelector:@selector(pageView:didChangeToIndex:)]) {
            [self.delegate pageView:self didChangeToIndex:indexPath.item % self.pageCount];
        }
    }
    
    BOOL horiztonScroll = (self.scrollDirection == OTSCyclePageViewScrollDirectionHorizontal);
    CGFloat scrollDirectionOffset = (horiztonScroll ? scrollView.contentOffset.x : scrollView.contentOffset.y);
    CGFloat scrollDirectionLength = horiztonScroll ? CGRectGetWidth(scrollView.bounds) : CGRectGetHeight(scrollView.bounds);
    
    if ((NSInteger)scrollDirectionOffset % (NSInteger)scrollDirectionLength != 0) {
        return;
    }
    
    if (!self.disableCycle) {
        if (scrollDirectionOffset == 0 || scrollDirectionOffset == (self.pageCount + 1) * scrollDirectionLength) {
            if (indexPath.item == 0) {
                [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pageCount inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:NO];
            }
            else if (indexPath.item == self.totalPageCount - 1){
                [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:NO];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self runAutoPage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self runAutoPage];
}

#pragma mark - Auto run related
- (void)runAutoPage {
    [self.timer invalidate];
    if (self.totalPageCount && self.autoRunPage) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(runCyclePageView) userInfo:nil repeats:YES];
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)setAutoRunPage:(BOOL)autoRunPage
{
    _autoRunPage = autoRunPage;
    
    [self runAutoPage];
}

- (void)runCyclePageView
{
    if (self.totalPageCount > 0) {
        NSIndexPath *currentIndexPath = [self.contentView indexPathForItemAtPoint:self.contentView.contentOffset];
        if (!currentIndexPath) {
            return;
        }
        
        NSInteger index = currentIndexPath.item;
        if (self.disableCycle) {
            if (index == self.pageCount - 1) {
                [self didScrollToEnd];
            }
            else {
                [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:YES];
            }
        }
        else {
            if (index + 1 < self.totalPageCount) {
                [self.contentView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1 inSection:0] atScrollPosition:[self collectionViewScrollPosition] animated:YES];
            }
        }
    }
}


- (void)didScrollToEnd {
    if ([self.delegate respondsToSelector:@selector(pageViewScrollEndOfPage:)]) {
        [self.delegate pageViewScrollEndOfPage:self];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
    }
}

@end
