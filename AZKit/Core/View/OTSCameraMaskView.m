//
//  OTSCameraMaskView.m
//  OTSKit
//
//  Created by Jerry on 2016/12/20.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCameraMaskView.h"
#import "AZFuncDefine.h"
#import "UIView+Frame.h"

@interface OTSCameraMaskView ()

@property (strong, nonatomic) CAShapeLayer *dimLayer;
@property (strong, nonatomic) CAShapeLayer *decorationLayer;
@property (strong, nonatomic) CAGradientLayer *animationLayer;

@end

@implementation OTSCameraMaskView

OTSViewInit {
    _decorationLineLength = 16.0;
    _decorationLineWidth = 4.0;
    _clipRect = CGRectMake(self.width * .5 - 100.0, self.height * .5 - 100.0, 200.0, 200.0);
    
    [self.layer addSublayer:self.dimLayer];
    [self.layer addSublayer:self.decorationLayer];
    
    [self tintColorDidChange];
    [self __changeLayerPositionAndShape];
}

- (void)tintColorDidChange {
    self.decorationLayer.strokeColor = self.tintColor.CGColor;
    self.animationLayer.shadowColor = self.tintColor.CGColor;
    self.animationLayer.colors = @[(id)[self.tintColor colorWithAlphaComponent:0].CGColor, (id)self.tintColor.CGColor, (id)[self.tintColor colorWithAlphaComponent:0].CGColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self __changeLayerPositionAndShape];
}

#pragma mark - API
- (void)startAnimating {
    if (!self.animationLayer.superlayer) {
        [self.layer addSublayer:self.animationLayer];
    }
    
    [self.animationLayer removeAllAnimations];
    self.animationLayer.frame = CGRectMake(self.clipRect.origin.x, self.clipRect.origin.y, self.clipRect.size.width, 4);
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, self.clipRect.size.height - 4, 0)];
    transformAnimation.repeatCount = INFINITY;
    transformAnimation.duration = 2.5;
    [self.animationLayer addAnimation:transformAnimation forKey:nil];
}

- (void)stopAnimating {
    [self.animationLayer removeFromSuperlayer];
    [self.animationLayer removeAllAnimations];
}

#pragma mark - Getter & Setter
- (CAShapeLayer*)dimLayer {
    if (!_dimLayer) {
        _dimLayer = [CAShapeLayer layer];
        _dimLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    }
    return _dimLayer;
}

- (CAShapeLayer*)decorationLayer {
    if (!_decorationLayer) {
        _decorationLayer = [CAShapeLayer layer];
        _decorationLayer.fillColor = [UIColor clearColor].CGColor;
        _decorationLayer.lineWidth = self.decorationLineWidth;
        _decorationLayer.lineCap = kCALineCapRound;
    }
    return _decorationLayer;
}

- (CAGradientLayer*)animationLayer {
    if (!_animationLayer) {
        _animationLayer = [CAGradientLayer layer];
        _animationLayer.startPoint = CGPointMake(0, .5);
        _animationLayer.endPoint = CGPointMake(1.0, .5);
    }
    return _animationLayer;
}

- (void)setClipRect:(CGRect)clipRect {
    if (!CGRectEqualToRect(_clipRect, clipRect)) {
        _clipRect = clipRect;
        [self __changeLayerPositionAndShape];
    }
}

- (void)setDecorationLineLength:(CGFloat)decorationLineLength {
    if (_decorationLineLength != decorationLineLength) {
        _decorationLineLength = decorationLineLength;
        [self __changeLayerPositionAndShape];
    }
}

- (void)setDecorationLineWidth:(CGFloat)decorationLineWidth {
    if (_decorationLineWidth != decorationLineWidth) {
        _decorationLineWidth = decorationLineWidth;
        self.decorationLayer.lineWidth = _decorationLineWidth;
    }
}

#pragma mark - Private
- (void)__changeLayerPositionAndShape {
    UIBezierPath *dimShapePath = [UIBezierPath bezierPathWithRect:self.bounds];
    [dimShapePath appendPath:[[UIBezierPath bezierPathWithRect:self.clipRect] bezierPathByReversingPath]];
    [dimShapePath addClip];
    self.dimLayer.path = dimShapePath.CGPath;
    
    CGPoint leftTopCorner = CGPointMake(self.clipRect.origin.x, self.clipRect.origin.y);
    CGPoint rightTopCorner = CGPointMake(self.clipRect.origin.x + self.clipRect.size.width, self.clipRect.origin.y);
    CGPoint leftBottomCorner = CGPointMake(self.clipRect.origin.x, self.clipRect.origin.y + self.clipRect.size.height);
    CGPoint rightBottomCorner = CGPointMake(self.clipRect.origin.x + self.clipRect.size.width, self.clipRect.origin.y + self.clipRect.size.height);
    
    UIBezierPath *decorationPath = [UIBezierPath bezierPath];
    
    [decorationPath moveToPoint:CGPointMake(leftTopCorner.x, leftTopCorner.y + self.decorationLineLength)];
    [decorationPath addLineToPoint:leftTopCorner];
    [decorationPath addLineToPoint:CGPointMake(leftTopCorner.x + self.decorationLineLength, leftTopCorner.y)];
    
    [decorationPath moveToPoint:CGPointMake(leftBottomCorner.x, leftBottomCorner.y - self.decorationLineLength)];
    [decorationPath addLineToPoint:leftBottomCorner];
    [decorationPath addLineToPoint:CGPointMake(leftBottomCorner.x + self.decorationLineLength, leftBottomCorner.y)];
    
    [decorationPath moveToPoint:CGPointMake(rightTopCorner.x - self.decorationLineLength, leftTopCorner.y)];
    [decorationPath addLineToPoint:rightTopCorner];
    [decorationPath addLineToPoint:CGPointMake(rightTopCorner.x, rightTopCorner.y + self.decorationLineLength)];
    
    [decorationPath moveToPoint:CGPointMake(rightBottomCorner.x - self.decorationLineLength, rightBottomCorner.y)];
    [decorationPath addLineToPoint:rightBottomCorner];
    [decorationPath addLineToPoint:CGPointMake(rightBottomCorner.x, rightBottomCorner.y - self.decorationLineLength)];
    
    self.decorationLayer.path = decorationPath.CGPath;
}

@end
