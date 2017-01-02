//
//  OTSViewPoper.m
//  OneStore
//
//  Created by huangjiming on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSViewPoper.h"
//category
#import <OTSKit/NSArray+safe.h>

#import "AGWindowView.h"


#import <OTSKit/OTSFuncDefine.h>

//横竖屏宽度
#define UI_CURRENT_SCREEN_HEIGHT (IS_LANDSCAPE?(IOS_SDK_LESS_THAN(8.0)?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height)):([[UIScreen mainScreen] bounds].size.height))

#define UI_CURRENT_SCREEN_WIDTH (IS_LANDSCAPE?\
(IOS_SDK_LESS_THAN(8.0)?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width))\
:([[UIScreen mainScreen] bounds].size.width))

@interface OTSViewPoper()
@property (nonatomic, strong) AGWindowView *windowView;
@end

@implementation OTSViewPoper

#pragma mark - Property
- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked:)];
        [_bgView addGestureRecognizer:tapGesture];
    }
    
    return _bgView;
}

- (UIView *)popView
{
    if (_popView == nil) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, 240)];
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, UI_CURRENT_SCREEN_WIDTH-16, 224)];
        subView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        subView.layer.cornerRadius = 5.0;
        [_popView addSubview:subView];
    }
    
    return _popView;
}

#pragma mark - Action
- (void)bgClicked:(UIGestureRecognizer *)aGesture
{
    [self hidePopView];
}

#pragma mark - API
/**
 *  功能:显示pop view
 */
- (void)showPopView
{
    self.windowView = [[AGWindowView alloc] initAndAddToKeyWindow];
    self.windowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
    [self.windowView addGestureRecognizer:tapGesture];
    self.windowView.alpha = 0.1;
    
    [self.windowView addSubview:self.popView];
    self.popView.frame = CGRectMake(self.popView.frame.origin.x, UI_CURRENT_SCREEN_HEIGHT, UI_CURRENT_SCREEN_WIDTH, self.popView.frame.size.height);
    
    [UIView animateWithDuration:.3f animations:^{
        self.popView.frame = CGRectMake(self.popView.frame.origin.x, UI_CURRENT_SCREEN_HEIGHT-self.popView.frame.size.height, UI_CURRENT_SCREEN_WIDTH, self.popView.frame.size.height);
        self.windowView.alpha = 1.0;
    }];
}

/**
 *  功能:隐藏pop view
 */
- (void)hidePopView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:.3f animations:^{
        self.popView.frame = CGRectMake(self.popView.frame.origin.x, rect.size.height, self.popView.frame.size.width, self.popView.frame.size.height);
        self.windowView.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
        self.popView = nil;
        [self.windowView removeFromSuperview];
        self.windowView = nil;
    }];
}
@end
