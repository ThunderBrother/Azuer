//
//  UIButton+badgedNumber.m
//  OneStoreLight
//
//  Created by wenjie on 16/9/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIView+BadgedNumber.h"
#import "UIView+Frame.h"
#import "NSObject+Runtime.h"
#import "NSString+Frame.h"

@implementation UIView (BadgedNumber)

static NSString *OTSBadgeLabelLayerKey = @"OTSBadgedTextLayerKey";
static NSString *OTSBadgePositionKey = @"OTSBadgedPositionKey";
static NSString *OTSBadgeValueKey = @"OTSBadgedValueKey";

#pragma mark - Getter & Setter
- (void)setBadgeString:(NSString *)badgeString {
    CATextLayer *badgedLabelLayer = [self objc_getAssociatedObject:OTSBadgeLabelLayerKey];
    if (badgeString.length == 0 || badgeString.integerValue == 0) {
        [badgedLabelLayer removeFromSuperlayer];
        [self objc_removeAssociatedObjectForPropertyName:OTSBadgeLabelLayerKey];
        [self objc_removeAssociatedObjectForPropertyName:OTSBadgeValueKey];
        return;
    }
    
    if (!badgedLabelLayer) {
        badgedLabelLayer = [self __createLabelLayer];
        [self objc_setAssociatedObject:OTSBadgeLabelLayerKey value:badgedLabelLayer policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    
    badgedLabelLayer.string = badgeString;
    [self.layer addSublayer:badgedLabelLayer];
    
    CGSize badgeSize = [badgeString sizeWithFont:[UIFont systemFontOfSize:badgedLabelLayer.fontSize] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:CGFLOAT_MAX];
    
    CGFloat badgeLabelWidth = ceil(badgeSize.width + 7.0);
    CGFloat badgeLabelHeight = 12.0;
    
    if (self.badgePosition == OTSBadgePositionInside) {
        badgedLabelLayer.frame = CGRectMake(self.width - badgeLabelHeight - 4.0, 4.0, badgeLabelWidth, badgeLabelHeight);
    } else if (self.badgePosition == OTSBadgePositionOutside) {
        badgedLabelLayer.frame = CGRectMake(self.width - badgeLabelWidth * .5, -4.0, badgeLabelWidth, badgeLabelHeight);
    }
    
    [self objc_setAssociatedObject:OTSBadgeValueKey value:badgeString policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)setBadgePosition:(OTSBadgePosition)badgePosition {
     [self objc_setAssociatedObject:OTSBadgePositionKey value:@(badgePosition) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (OTSBadgePosition)badgePosition {
    return (OTSBadgePosition)[[self objc_getAssociatedObject:OTSBadgePositionKey] integerValue];
}

- (NSString *)badgeString {
    return [self objc_getAssociatedObject:OTSBadgeValueKey];
}

- (CATextLayer*)__createLabelLayer {
    CATextLayer *labelLayer = [CATextLayer layer];
    labelLayer.contentsScale = [UIScreen mainScreen].scale;
    labelLayer.foregroundColor = [UIColor whiteColor].CGColor;
    labelLayer.backgroundColor = [UIColor redColor].CGColor;
    labelLayer.fontSize = 9.0;
    labelLayer.cornerRadius = 6.0;
    labelLayer.alignmentMode = kCAAlignmentCenter;
    labelLayer.masksToBounds = true;
    return labelLayer;
}

@end
