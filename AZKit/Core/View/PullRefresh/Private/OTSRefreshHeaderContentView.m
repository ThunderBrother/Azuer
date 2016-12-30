//
//  OTSPullRefreshHeaderContentView.m
//  OTSUIKit
//
//  Created by Jerry on 16/4/9.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSRefreshHeaderContentView.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
//View
#import "OTSSimpleShape.h"
#import "OTSCircleProgressView.h"
#import "OTSCircleLoadingView.h"

@implementation OTSRefreshHeaderContentView {
    OTSSimpleShape *_arrowView;
    OTSSimpleShape *_successView;
    OTSCircleProgressView *_progressView;
    OTSCircleLoadingView *_loadingView;
    UILabel *_errorLabel;
    UILabel *_statusLabel;
}

+ (CGFloat)preferredHeight {
    return 70;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _arrowView = [[OTSSimpleShape alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _arrowView.center = CGPointMake(self.width * .5f, self.height * .5f - 11);
        _arrowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _arrowView.lineWidth = 2.0f;
        _arrowView.type = OTSSimpleShapeTypeArrow;
        _arrowView.subType = OTSSimpleShapeSubTypeArrowBottom;
        _arrowView.hidden = YES;
        
        [self addSubview:_arrowView];
        
        _successView = [[OTSSimpleShape alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _successView.center = CGPointMake(self.width * .5f, self.height * .5f - 11);
        _successView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _successView.lineWidth = 2.0f;
        _successView.type = OTSSimpleShapeTypeYes;
        _successView.hidden = YES;
        
        [self addSubview:_successView];
        
        _progressView = [[OTSCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _progressView.drawBackground = NO;
        _progressView.center = CGPointMake(self.width * .5f, self.height * .5f - 11);
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _progressView.lineWidth = 2.0f;
        
        [self addSubview:_progressView];
        
        _loadingView = [[OTSCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _loadingView.drawBackground = NO;
        _loadingView.center = CGPointMake(self.width * .5f, self.height * .5f - 11);
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _loadingView.style = OTSCircleLoadingStyleCumulative;
        _loadingView.lineWidth = 2.0f;
        [self addSubview:_loadingView];
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
        _errorLabel.textColor = [UIColor colorWithRGB:0x505050];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.font = [UIFont systemFontOfSize:12.0];
        _errorLabel.center = CGPointMake(self.width * .5f, self.height * .5f - 11);
        _errorLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleWidth;
        [self addSubview:_errorLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
        _statusLabel.textColor = [UIColor colorWithRGB:0x505050];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:12.0];
        _statusLabel.center = CGPointMake(self.width * .5f, self.height * .5f + 11);
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_statusLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Action
- (void)didTapContentView:(UITapGestureRecognizer*)sender {
    void (^refreshingBlock)(id refreshView) = [self.superview valueForKey:@"refreshingBlock"];
    
    if (refreshingBlock) {
        refreshingBlock(self.superview);
        [self startLoading];
    }
}

#pragma mark - OTSPullRefreshContentViewProtocol
- (void)setProgress:(CGFloat)progress {
    _loadingView.hidden = YES;
    _successView.hidden = YES;
    _errorLabel.hidden = YES;
    
    _arrowView.hidden = NO;
    _progressView.hidden = NO;
    
    _progressView.progress = progress;
    if (progress >= 1) {
        _arrowView.subType = OTSSimpleShapeSubTypeArrowTop;
        _statusLabel.text = @"Release to Refresh";
    } else {
        _arrowView.subType = OTSSimpleShapeSubTypeArrowBottom;
        _statusLabel.text = @"Pull to Refresh";
    }
}

- (void)startLoading {
    _loadingView.hidden = NO;
    _successView.hidden = YES;
    _errorLabel.hidden = YES;
    
    _arrowView.hidden = YES;
    _progressView.hidden = YES;
    
    [_loadingView startAnimating];
    _statusLabel.text = @"Loading";
    
    self.userInteractionEnabled = NO;
}

- (void)stopLoading {
    _loadingView.hidden = YES;
    _successView.hidden = YES;
    _errorLabel.hidden = YES;
    
    _arrowView.hidden = YES;
    _progressView.hidden = YES;
    
    [_loadingView stopAnimating];
    _statusLabel.text = nil;
    
    self.userInteractionEnabled = NO;
}

- (void)loadedSuccess {
    _successView.hidden = NO;
    _loadingView.hidden = YES;
    _errorLabel.hidden = YES;
    
    _arrowView.hidden = YES;
    _progressView.hidden = NO;
    _progressView.progress = 1.0f;
    _statusLabel.text = @"Success";
    
    [_loadingView stopAnimating];
    [_successView beginSimpleAnimation];
    
    self.userInteractionEnabled = NO;
}

- (void)loadedError:(NSString *)errorMsg {
    _successView.hidden = YES;
    _loadingView.hidden = YES;
    _errorLabel.hidden = NO;
    
    _arrowView.hidden = YES;
    _progressView.hidden = YES;
    
    _errorLabel.text = errorMsg;
    _statusLabel.text = @"Click to Retry";
    
    [_loadingView stopAnimating];
    [_successView beginSimpleAnimation];
    
    self.userInteractionEnabled = YES;
}

@end
