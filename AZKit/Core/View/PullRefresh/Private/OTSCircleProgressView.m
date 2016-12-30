//
//  OTSCircleProgressView.m
//  OTSUIKit
//
//  Created by Jerry on 16/3/22.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSCircleProgressView.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
#import "OTSFuncDefine.h"

@implementation OTSCircleProgressView {
    CAShapeLayer *_layer;
    CAShapeLayer *_backgroundLayer;
}

OTSViewInit {
    self.backgroundColor = [UIColor clearColor];
    _clockWise = YES;
    _style = -1;
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
    _layer = [CAShapeLayer layer];
    
    self.drawBackground = YES;
    
    [self.layer addSublayer:_layer];
    
    self.style = OTSCircleProgressStyleDefault;
    self.backgroundTintColor = [UIColor colorWithRGB:0xe6e6e6];
    [self setupLayerColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupShape];
    if (self.drawBackground) {
        [self setupBackgroundShape];
    }
}

- (void)tintColorDidChange {
    [self setupLayerColor];
}

#pragma mark - Setter & Getter
- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = OTSValueConformTo(progress, 0, 1);
        if (self.style == OTSCircleProgressStyleDefault) {
            if (self.clockWise) {
                _layer.strokeEnd = _progress;
            } else {
                _layer.strokeStart = _progress;
                _layer.strokeEnd = 1.0;
            }
        } else {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.fromValue = (__bridge id)(_layer.path);
            [self setupShape];
            pathAnimation.toValue = (__bridge id)(_layer.path);
            [_layer addAnimation:pathAnimation forKey:nil];
        }
    }
}

- (void)setStyle:(OTSCircleProgressStyle)style {
    if (_style != style) {
        _style = style;
        if (style == OTSCircleProgressStyleDefault) {
            _layer.lineCap = kCALineCapRound;
            _layer.strokeStart = .0;
            if (self.clockWise) {
                _layer.strokeEnd = .0;
            } else {
                _layer.strokeEnd = 1.0;
            }
            self.lineWidth = 4.0f;
        } else if(style == OTSCircleProgressStylePie) {
            self.lineWidth = 1.0f;
        }
        [self setupLayerColor];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        _layer.lineWidth = lineWidth;
        _backgroundLayer.lineWidth = lineWidth;
    }
}

- (void)setDrawBackground:(BOOL)drawBackground {
    if (_drawBackground != drawBackground) {
        _drawBackground = drawBackground;
        if (drawBackground) {
            [self setupBackgroundShape];
            [self.layer insertSublayer:_backgroundLayer below:_layer];
        } else {
            [_backgroundLayer removeFromSuperlayer];
        }
    }
}

- (void)setBackgroundTintColor:(UIColor *)backgroundTintColor {
    if (_backgroundTintColor != backgroundTintColor) {
        _backgroundTintColor = backgroundTintColor;
        _backgroundLayer.strokeColor = backgroundTintColor.CGColor;
    }
}

#pragma mark - Private
- (void)setupLayerColor {
    if (self.style == OTSCircleProgressStyleDefault) {
        _layer.fillColor = [UIColor clearColor].CGColor;
        _layer.strokeColor = self.tintColor.CGColor;
        
    } else if(self.style == OTSCircleProgressStylePie) {
        _layer.fillColor = self.tintColor.CGColor;
        _layer.strokeColor = [UIColor clearColor].CGColor;
    }
}

- (void)setupShape {
    _layer.frame = self.bounds;
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (self.style == OTSCircleProgressStylePie) {
        CGPathMoveToPoint(path, NULL, self.width * .5f, self.height * .5f);
    }
    CGFloat circleProgress = (self.style == OTSCircleProgressStylePie ? self.progress : 1.0);
    CGFloat radius = (MIN(self.width, self.height) - _layer.lineWidth) * .5f;
    if (self.style == OTSCircleProgressStylePie) {
        radius -= 2;
    }
    CGPathAddArc(path, NULL, self.width * .5f, self.height * .5f, radius, -M_PI_2, -M_PI_2 + M_PI * 2 * circleProgress, 0);
    _layer.path = path;
    CGPathRelease(path);
}

- (void)setupBackgroundShape {
    _backgroundLayer.frame = self.bounds;
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (self.style == OTSCircleProgressStylePie) {
        CGPathMoveToPoint(path, NULL, self.width * .5f, self.height * .5f);
    }
    
    CGFloat radius = (MIN(self.width, self.height) - _layer.lineWidth) * .5f;
    if (self.style == OTSCircleProgressStylePie) {
        radius -= 2;
    }
    CGPathAddArc(path, NULL, self.width * .5f, self.height * .5f, radius, -M_PI_2, -M_PI_2 + M_PI * 2, 0);
    _backgroundLayer.path = path;
    CGPathRelease(path);
}

float OTSValueConformTo(float input, float min, float max) {
    return MAX(min, MIN(input, max));
}


@end
