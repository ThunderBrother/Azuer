//
//  OTSLaunchPageVC.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSLaunchPageVC.h"
#import <OTSKit/OTSKit.h>

@interface OTSLaunchPageVC()<OTSCyclePageViewDelegate, OTSCyclePageViewDataSource>

@property (strong, nonatomic) OTSCyclePageView *pageView;
@property (strong, nonatomic) OTSCircleProgressView *progressView;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) CADisplayLink *timer;
@property (assign, nonatomic) CGFloat secondsPassedBy;

@end

@implementation OTSLaunchPageVC

const CGFloat launchTotalDuration = 3.0;

+ (void)load {
    [[OTSIntentContext defaultContext] registerRouterClass:[self class] forKey:@"launchPage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.progressView];
    [self.pageView reloadData];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)didPressCloseButton:(id)sender {
    if (self.dismissBlock) {
        if (_timer) {
            [_timer invalidate];
        }
        
        [UIView animateWithDuration:.5 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            self.view.alpha = .0;
        } completion:^(BOOL finished) {
           self.dismissBlock();
        }];
    }
}

- (void)didReceiveTimerAction:(NSTimer*)timer {
    self.secondsPassedBy += 1.0 / 60.0;
    
    self.progressView.progress = self.secondsPassedBy / launchTotalDuration;
    if (self.secondsPassedBy >= launchTotalDuration) {
        [self didPressCloseButton:nil];
    }
}

#pragma mark - OTSCyclePageViewDelegate & OTSCyclePageViewDataSource
- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex {
    NSDictionary *item = [self.items safeObjectAtIndex:aIndex];
    OTSIntentModel *intentModel = item[@"intentModel"];
    if (intentModel && self.imageClickedBlock) {
        [self didPressCloseButton:nil];
        self.imageClickedBlock(intentModel);
    }
}

- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView {
    return self.items.count;
}

- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex reuseView: (UIView*)oldView {
    NSDictionary *item = [self.items safeObjectAtIndex:aIndex];
    if (![item isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    UIImageView *aImageView = nil;
    if ([oldView isKindOfClass:[UIImageView class]]) {
        aImageView = (id)oldView;
    } else {
        aImageView = [[UIImageView alloc] initWithFrame:aPageView.bounds];
    }
    [aImageView loadImageForURL:item[@"imageURL"] compressed:false];
    
    return aImageView;
}

#pragma mark - Getter & Setter
- (CADisplayLink*)timer {
    if (!_timer) {
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(didReceiveTimerAction:)];
    }
    return _timer;
}

- (OTSCyclePageView*)pageView {
    if (!_pageView) {
        _pageView = [[OTSCyclePageView alloc] initWithFrame:self.view.bounds];
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageView.autoRunPage = true;
        _pageView.disableCycle = true;
        _pageView.disableClickEffect = true;
        _pageView.delegate = self;
        _pageView.dataSource = self;
    }
    return _pageView;
}

- (OTSCircleProgressView*)progressView {
    if (!_progressView) {
        _progressView = [[OTSCircleProgressView alloc] initWithFrame:CGRectMake(self.view.width - 70, 20, 50, 50)];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _progressView.drawBackground = false;
        _progressView.clockWise = false;
        _progressView.lineWidth = 2.0;
        
        [_progressView insertSubview:self.closeButton atIndex:0];
    }
    return _progressView;
}

- (UIButton*)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 46.0, 46.0)];
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _closeButton.titleLabel.font = OTSSmallFont;
        
        _closeButton.layer.masksToBounds = true;
        _closeButton.layer.cornerRadius = 23.0;
        
        [_closeButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didPressCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    }
    return _closeButton;
}

@end
