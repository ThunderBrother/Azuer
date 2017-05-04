//
//  OTSViewAttribute.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSCodingObject.h"
#import "UIView+Border.h"

@class OTSIntentModel;

NS_ASSUME_NONNULL_BEGIN

@interface OTSViewAttribute : OTSCodingObject

@property (strong, nonatomic, nullable) OTSIntentModel *tapIntentModel;

@property (assign, nonatomic) CGFloat preferredWidth;
@property (assign, nonatomic) CGFloat preferredHeight;
@property (assign, nonatomic) CGFloat preferredRatio;//width / height, default is 0. when (preferredWidth > 0 && preferredHeight == 0 && preferredRatio > 0) or (preferredWidth == 0 && preferredHeight > 0 && preferredRatio > 0)

@property (assign, nonatomic) CGFloat minWidth;
@property (assign, nonatomic) CGFloat minHeight;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat maxHeight;

@property (assign, nonatomic) BOOL disabled;

@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) OTSBorderOption borderOption;

@property (assign, nonatomic) UIEdgeInsets contentInsets;
@property (assign, nonatomic) UIOffset contentOffset;


@property (assign, nonatomic) NSUInteger tintColor;
@property (assign, nonatomic) NSUInteger backgroundColor;

- (CGSize)preferredSize;

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

- (void)applyAttribute:(nullable OTSViewAttribute*)attribute delegate:(id)delegate;
- (void)resizeWithAttribute:(nullable OTSViewAttribute*)attribute;

@end

NS_ASSUME_NONNULL_END
