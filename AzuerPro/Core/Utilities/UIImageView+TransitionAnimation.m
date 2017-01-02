//
//  UIImageView+TransitionAnimation.m
//  OneStoreLight
//
//  Created by HUI on 2016/12/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIImageView+TransitionAnimation.h"
#import <OTSKit/OTSKit.h>

@implementation UIImageView (TransitionAnimation)

- (void)startAnimationWithToRect:(CGRect)toRect {
    if (!self) {
        return;
    }
    
    UIImageView *copyImageView = [[UIImageView alloc] initWithImage:self.image];
    [OTSSharedKeyWindow addSubview:copyImageView];
    [OTSSharedKeyWindow bringSubviewToFront:copyImageView];
    
    CGPoint imageViewCenter = [self convertPoint:self.center toView:OTSSharedKeyWindow];
    copyImageView.width = self.width;
    copyImageView.height = self.height;
    copyImageView.center = imageViewCenter;
    
    [UIView animateWithDuration:0.5 animations:^{
        copyImageView.alpha = .5f;
        copyImageView.frame = toRect;
    } completion:^(BOOL finished) {
        [copyImageView removeFromSuperview];
    }];
}

@end
