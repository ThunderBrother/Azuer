//
//  OTSPullRefreshHeaderContentView.m
//  OTSUIKit
//
//  Created by Jerry on 16/4/9.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSRefreshFooterContentView.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"

@implementation OTSRefreshFooterContentView {
    UILabel *_centerLabel;
    UILabel *_errorLabel;
    UILabel *_statusLabel;
}

+ (CGFloat)preferredHeight {
    return 50;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _centerLabel.textColor = [UIColor colorWithRGB:0x505050];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:12.0];
        _centerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_centerLabel];
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, self.width, 17)];
        _errorLabel.textColor = [UIColor colorWithRGB:0x505050];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.font = [UIFont systemFontOfSize:12.0];
        _errorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_errorLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.width, 17)];
        _statusLabel.textColor = [UIColor colorWithRGB:0x505050];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:12.0];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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

- (void)startLoading {
    _centerLabel.hidden = NO;
    _errorLabel.hidden = YES;
    _statusLabel.hidden = YES;
    
    _centerLabel.text = @"Loading";
    self.userInteractionEnabled = NO;
}

- (void)stopLoading {
    _centerLabel.hidden = YES;
    _errorLabel.hidden = YES;
    _statusLabel.hidden = YES;
    
    _statusLabel.text = nil;
    
    self.userInteractionEnabled = NO;
}

- (void)loadedError:(NSString *)errorMsg {
    _centerLabel.hidden = YES;
    _errorLabel.hidden = NO;
    _statusLabel.hidden = NO;
    
    _errorLabel.text = errorMsg;
    _statusLabel.text = @"Click to Retry";
    
    self.userInteractionEnabled = YES;
}

- (void)loadedPause:(NSString *)pauseMsg {
    _centerLabel.hidden = NO;
    _errorLabel.hidden = YES;
    _statusLabel.hidden = YES;
    
    _centerLabel.text = pauseMsg;
    
    self.userInteractionEnabled = NO;
}

@end
