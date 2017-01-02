//
//  OTSViewAttribute.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSViewAttribute : OTSCodingObject

@property (assign, nonatomic) CGFloat cornerRadius;

@property (assign, nonatomic) CGFloat preferredWidth;
@property (assign, nonatomic) CGFloat preferredHeight;

@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGFloat minHeight;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat maxHeight;

@property (assign, nonatomic) UIEdgeInsets insets;

@property (assign, nonatomic) NSUInteger backgroundColor;
@property (strong, nonatomic, nullable) NSString *backgroundImageName;

@end

NS_INLINE OTSViewAttribute* OTSViewAttributeMake(NSUInteger backgroundColor) {
    OTSViewAttribute *item = [[OTSViewAttribute alloc] init];
    item.backgroundColor = backgroundColor;
    return item;
}

NS_INLINE OTSViewAttribute* OTSViewAttributeMakeF(CGFloat width, CGFloat height) {
    OTSViewAttribute *item = [[OTSViewAttribute alloc] init];
    item.preferredWidth = width;
    item.preferredHeight = height;
    return item;
}

@interface UIView (OTSViewAttributeApply)

- (void)applyAttribute:(nullable OTSViewAttribute*)attribute;
- (void)layoutAttribute:(nullable OTSViewAttribute*)attribute;

@end

NS_ASSUME_NONNULL_END
