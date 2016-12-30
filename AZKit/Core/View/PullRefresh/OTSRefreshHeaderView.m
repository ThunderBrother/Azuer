//
//  OTSRefreshHeaderView.m
//  OTSUIKit
//
//  Created by Jerry on 16/4/8.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSRefreshHeaderView.h"
#import "OTSRefreshHeaderContentView.h"
#import "UIColor+Utility.h"
#import "UIView+Frame.h"

@interface OTSRefreshHeaderView()

@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;
@property (weak, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (assign, nonatomic) OTSPullRefreshState state;
@property (strong, nonatomic) UIView<OTSRefreshContentViewProtocol> *contentView;


@end

@implementation OTSRefreshHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    if (!self.contentView) {
        self.contentViewClass = NSStringFromClass([OTSRefreshHeaderContentView class]);
    }
    [self removeKVO];
    if (newSuperview) {
        self.contentView.tintColor = self.tintColor;
        self.scrollView = (id)newSuperview;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollViewOriginalInset = self.scrollView.contentInset;
        self.panGestureRecognizer = self.scrollView.panGestureRecognizer;
        [self registKVO];
    }
}

#pragma mark - Public
- (void)startRefreshing {
    _state = OTSPullRefreshStateIdle;
    self.state = OTSPullRefreshStateRefreshing;
}

- (void)endRefreshing {
    [self endRefreshingWithDelay:0];
}

- (void)pauseRefreshing {
    self.state = OTSPullRefreshStatePause;
}

- (void)endRefreshingWithDelay:(NSTimeInterval)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(didEndRefreshing) withObject:nil afterDelay:delay];
}

#pragma mark - KVO
- (void)registKVO {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if([keyPath isEqualToString:@"state"]) {
        [self scrollViewPanGestureStateDidChange:change];
    }
}

- (void)removeKVO {
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    self.panGestureRecognizer = nil;
}

#pragma mark - Setter & Getter
- (void)setContentView:(UIView<OTSRefreshContentViewProtocol> *)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:self.contentView];
        [self setupContentViewByStyleChange];
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

- (void)setStyle:(OTSPullRefreshStyle)style {
    _style = style;
    [self setupContentViewByStyleChange];
}

- (void)setState:(OTSPullRefreshState)state {
    if (_state != state) {
        _state = state;
        switch (state) {
            case OTSPullRefreshStateIdle: {
                [self.contentView stopLoading];
                [UIView animateWithDuration:0.25f animations:^{
                    self.scrollView.contentInset = self.scrollViewOriginalInset;
                    
                } completion:nil];
            }
                break;
            case OTSPullRefreshStateRefreshing: {
                [self.contentView startLoading];
                [UIView animateWithDuration:0.25f animations:^{
                    
                    UIEdgeInsets newInset = UIEdgeInsetsMake(_scrollViewOriginalInset.top + self.contentView.height, _scrollViewOriginalInset.left, _scrollViewOriginalInset.bottom, _scrollViewOriginalInset.right);
                    self.scrollView.contentInset = newInset;
                    
                } completion:^(BOOL finished) {
                    if (finished) {
                        if (self.refreshingBlock) {
                            self.refreshingBlock(self);
                        }
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Private
- (void)setupContentViewByStyleChange {
    CGFloat viewHeight = [self.contentView.class preferredHeight];
    if (self.style == OTSPullRefreshStyleStill) {
        self.contentView.frame = CGRectMake(0, 0, self.width, viewHeight);
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    } else if(self.style == OTSPullRefreshStyleFollow) {
        self.contentView.frame = CGRectMake(0, self.height - viewHeight, self.width, viewHeight);
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
}

- (void)didEndRefreshing {
    self.state = OTSPullRefreshStateIdle;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary*)change {
    UIEdgeInsets insets = self.scrollView.contentInset;
    if (self.state != OTSPullRefreshStateIdle) {
        insets.top -= self.contentView.height;
    }
    self.scrollViewOriginalInset = insets;
    
    CGFloat offsetY = - self.scrollView.contentOffset.y - self.scrollViewOriginalInset.top;
    if (offsetY < 0) {
        return;
    }
    self.frame = CGRectMake(0, -offsetY, self.scrollView.width,  offsetY);
    
    if (self.state == OTSPullRefreshStateIdle) {
        [self.contentView setProgress:self.height / self.contentView.height];
    }
}

- (void)scrollViewPanGestureStateDidChange:(NSDictionary*)change {
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.state != OTSPullRefreshStateIdle) {
            return;
        }
         CGFloat offsetY = - (self.scrollView.contentInset.top + self.scrollView.contentOffset.y);
        if (offsetY >= self.contentView.height) {
            self.state = OTSPullRefreshStateRefreshing;
        } else {
            self.state = OTSPullRefreshStateIdle;
        }
    }
}

@end
