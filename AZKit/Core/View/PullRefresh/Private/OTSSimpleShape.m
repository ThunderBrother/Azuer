//
//  OTSSimpleShape.m
//  OTSUIKit
//
//  Created by Jerry on 16/4/12.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSSimpleShape.h"
#import "UIView+Frame.h"
#import "OTSFuncDefine.h"

NSString *const OTSSimpleShapeTypeYes = @"yes";
NSString *const OTSSimpleShapeTypeArrow = @"arrow";
NSString *const OTSSimpleShapeTypeHeart = @"heart";
NSString *const OTSSimpleShapeTypePentastar = @"pentastar";
NSString *const OTSSimpleShapeTypeAdd = @"add";
NSString *const OTSSimpleShapeTypeClose = @"close";

NSString *const OTSSimpleShapeSubTypeArrowTop = @"top";
NSString *const OTSSimpleShapeSubTypeArrowBottom = @"bottom";
NSString *const OTSSimpleShapeSubTypeArrowLeft = @"left";
NSString *const OTSSimpleShapeSubTypeArrowRight = @"right";

NSString *const OTSSimpleShapeSubTypePentastarFilledHalf = @"half";

#define kConvertByRatio(value, dest) JWConvertValue([value floatValue], 100.0f, dest)

typedef NS_ENUM(NSInteger, OTSSimpleShapeMethod) {
    OTSSimpleShapeMethodLine = 0,
    OTSSimpleShapeMethodMove = 1,
    OTSSimpleShapeMethodCurve = 2,
    OTSSimpleShapeMethodQuadCurve = 3,
    OTSSimpleShapeMethodArc  = 4
};

@implementation OTSSimpleShape {
    CAShapeLayer *_shapeLayer;
    NSArray *_data;
}

OTSViewInit {
    self.backgroundColor = [UIColor clearColor];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:_shapeLayer];
    
    self.lineWidth = 2.0;
    self.filled = NO;
    
    [self setLayerColor];
}

- (void)layoutSubviews {
    [self layoutLayers];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(35, 35);
}

- (void)tintColorDidChange {
    [self setLayerColor];
    self.subType = _subType;
}

- (void)beginSimpleAnimation {
    if ([self.type isEqualToString:OTSSimpleShapeTypeYes]) {
        [_shapeLayer removeAllAnimations];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0f);
        animation.toValue = @(1.0f);
        animation.duration = 0.25f;
        [_shapeLayer addAnimation:animation forKey:nil];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if([self.type isEqualToString:OTSSimpleShapeTypePentastar] && [self.subType isEqualToString:OTSSimpleShapeSubTypePentastarFilledHalf]) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, _shapeLayer.path);
        CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
        
        CGRect range = CGRectMake(0, 0, self.width * .5f, self.height);
        
        CGContextClip(context);
        CGContextFillRect(context, range);
    }
}

#pragma mark - Setter & Getter
- (void)setType:(NSString *)type {
    _type = type;
    [self setupData];
    [self setNeedsLayout];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        _shapeLayer.lineWidth = lineWidth;
    }
}

- (void)setFilled:(BOOL)filled {
    _filled = filled;
    UIColor *filledColor = [UIColor clearColor];
    if(filled &&
       ([self.type isEqualToString:OTSSimpleShapeTypeHeart] ||
       [self.type isEqualToString:OTSSimpleShapeTypePentastar])) {
        filledColor = self.tintColor;
    }
    _shapeLayer.fillColor = filledColor.CGColor;
}

- (void)setSubType:(NSString *)subType {
    _subType = subType;
    if ([self.type isEqualToString:OTSSimpleShapeTypeArrow]) {
        CGFloat angle = 0;
        if ([subType isEqualToString:OTSSimpleShapeSubTypeArrowLeft]) {
            angle = -M_PI_2;
        } else if([subType isEqualToString:OTSSimpleShapeSubTypeArrowBottom]) {
            angle = -M_PI;
        } else if([subType isEqualToString:OTSSimpleShapeSubTypeArrowRight]) {
            angle = M_PI_2;
        }
        [UIView animateWithDuration:.25 animations:^{
            _shapeLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
        }];
    }
}

#pragma mark - Private
- (void)setupData {
    if ([self.type isEqualToString:OTSSimpleShapeTypeYes]) {
        _data =  @[@"4,53|1", @"40,90", @"96,10"];
    } else if([self.type isEqualToString:OTSSimpleShapeTypeArrow]) {
        _data =  @[@"50,98|1", @"50,2", @"20,36", @"50,2|1", @"80,36"];
    } else if([self.type isEqualToString:OTSSimpleShapeTypeHeart]) {
        _data = @[@"50,30|1", @"8,26,28,3,10,18|2", @"11,51,5,36,6,45|2", @"50,90,20,65|3", @"89,51,80,65|3",@"92,26,94,45,95,36|2", @"50,30,90,18,72,3|2"];
    } else if([self.type isEqualToString:OTSSimpleShapeTypePentastar]) {
        _data = @[@"50,5|1", @"60,39", @"95,39", @"67,60", @"77,93", @"50,73", @"23,93", @"33, 60", @"5,39", @"40,39", @"50,5"];
    } else if([self.type isEqualToString:OTSSimpleShapeTypeAdd]) {
        _data = @[@"4,50|1", @"96,50", @"50,4|1", @"50,96"];
    } else if([self.type isEqualToString:OTSSimpleShapeTypeClose]) {
        _data = @[@"16,16|1", @"82,82", @"84,16|1", @"18,82"];
    }
}

- (void)setLayerColor {
    _shapeLayer.strokeColor = self.tintColor.CGColor;
}

- (void)layoutLayers {
    _shapeLayer.frame = self.bounds;
    
    CGFloat layerSize = MIN(self.width, self.height);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (_data) {
        for (NSString *line in _data) {
            NSArray *lineGroup = [line componentsSeparatedByString:@"|"];
            OTSSimpleShapeMethod method = OTSSimpleShapeMethodLine;
            if (lineGroup.count == 2) {
                method = [lineGroup[1] integerValue];
            }
            NSArray *points = [lineGroup[0] componentsSeparatedByString:@","];
            if (method == OTSSimpleShapeMethodMove && points.count == 2) {
                [bezierPath moveToPoint:CGPointMake(kConvertByRatio(points[0], layerSize), kConvertByRatio(points[1], layerSize))];
            } else if(method == OTSSimpleShapeMethodLine && points.count == 2) {
                [bezierPath addLineToPoint:CGPointMake(kConvertByRatio(points[0], layerSize), kConvertByRatio(points[1], layerSize))];
            } else if(method == OTSSimpleShapeMethodCurve && points.count == 6) {
                [bezierPath addCurveToPoint:CGPointMake(kConvertByRatio(points[0], layerSize), kConvertByRatio(points[1], layerSize))
                                       controlPoint1:CGPointMake(kConvertByRatio(points[2], layerSize), kConvertByRatio(points[3], layerSize))
                                       controlPoint2:CGPointMake(kConvertByRatio(points[4], layerSize), kConvertByRatio(points[5], layerSize))];
            } else if(method == OTSSimpleShapeMethodQuadCurve && points.count == 4) {
                [bezierPath addQuadCurveToPoint:CGPointMake(kConvertByRatio(points[0], layerSize), kConvertByRatio(points[1], layerSize))
                                   controlPoint:CGPointMake(kConvertByRatio(points[2], layerSize), kConvertByRatio(points[3], layerSize))];
            } else if(method == OTSSimpleShapeMethodArc) {
                
            }
        }
    }
    _shapeLayer.path = bezierPath.CGPath;
}

float JWConvertValue(float input, float sourceReference, float destinationRefrence) {
    return input * destinationRefrence / sourceReference;
}

@end
