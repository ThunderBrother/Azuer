//
//  OTSRefreshFooterView.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSRefreshFooterView.h"
#import "OTSRefreshFooterContentView.h"
#import "UIColor+Utility.h"
#import "UIView+Frame.h"

@interface OTSRefreshFooterView()

@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGSize scrollViewContentSize;

@property (assign, nonatomic) OTSPullRefreshState state;
@property (strong, nonatomic) UIView<OTSRefreshContentViewProtocol> *contentView;

@end

@implementation OTSRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.clipsToBounds = true;
        self.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        self.hidden = true;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if (!self.contentView) {
        self.contentViewClass = NSStringFromClass([OTSRefreshFooterContentView class]);
    }
    [self removeKVO];
    if (newSuperview) {
        self.contentView.tintColor = self.tintColor;
        self.scrollView = (id)newSuperview;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollViewContentSize = self.scrollView.contentSize;
        [self registKVO];
    }
}

#pragma mark - Public
- (void)endRefreshing {
    self.state = OTSPullRefreshStateIdle;
}

- (void)pauseRefreshing {
    self.state = OTSPullRefreshStatePause;
}

#pragma mark - KVO
- (void)registKVO {
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO {
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if([keyPath isEqualToString:@"contentSize"]) {
        self.scrollViewContentSize = self.scrollView.contentSize;
    }
}

#pragma mark - Setter & Getter
- (void)setContentView:(UIView<OTSRefreshContentViewProtocol> *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:self.contentView];
        
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width, self.contentView.height);
    }
}

- (void)setContentViewClass:(NSString *)contentViewClass {
    if (![_contentViewClass isEqualToString:contentViewClass]) {
        _contentViewClass = contentViewClass;
        Class contentViewCls = NSClassFromString(contentViewClass);
        if (contentViewCls) {
            self.contentView = [[contentViewCls alloc] initWithFrame:CGRectMake(0, 0, self.width, [contentViewCls preferredHeight])];
        }
    }
}

- (void)setScrollViewContentSize:(CGSize)aSize {
    _scrollViewContentSize = aSize;
    if (self.state != OTSPullRefreshStateRefreshing && self.contentView) {
        self.frame = CGRectMake(0, aSize.height, self.scrollView.width, self.contentView.height);
    }
}

- (void)setState:(OTSPullRefreshState)state {
    if (_state != state) {
        _state = state;
        switch (state) {
            case OTSPullRefreshStateIdle: {
                self.hidden = true;
                [self.contentView stopLoading];
                
                if (self.scrollView.contentInset.bottom >= self.contentView.height) {
                    UIEdgeInsets oldInsets = self.scrollView.contentInset;
                    oldInsets.bottom -= self.contentView.height;
                    if (self.state == OTSPullRefreshStateIdle) {
                        self.scrollView.contentInset = oldInsets;
                    }
                }
            }
                break;
            case OTSPullRefreshStateRefreshing: {
                UIEdgeInsets oldInsets = self.scrollView.contentInset;
                oldInsets.bottom += self.contentView.height;
                self.scrollView.contentInset = oldInsets;
                if (self.refreshingBlock) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.refreshingBlock(self);
                    });
                }
                self.hidden = false;
                [self.contentView startLoading];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Private
- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change {
    if (self.state != OTSPullRefreshStatePause &&
        self.scrollView.contentSize.height &&
        self.scrollView.contentSize.height >= self.scrollView.height &&
        self.scrollView.contentOffset.y + self.scrollView.height - self.scrollView.contentSize.height >= -self.preFetchedDistance ) {
        
        self.state = OTSPullRefreshStateRefreshing;
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width, self.contentView.height);
    }
}

@end
