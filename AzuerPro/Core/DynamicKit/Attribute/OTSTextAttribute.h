//
//  OTSLabelItem.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSTextAttribute : OTSViewAttribute

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic, nullable) NSAttributedString *attributedTitle;

@property (assign, nonatomic) CGFloat font;
@property (assign, nonatomic) NSUInteger color;


@end

NS_INLINE OTSTextAttribute* OTSTitleMake(NSString *title) {
    OTSTextAttribute *item = [[OTSTextAttribute alloc] init];
    item.title = title;
    return item;
}

NS_INLINE OTSTextAttribute* OTSTitleMakeF(NSString *title, CGFloat font, NSUInteger color) {
    OTSTextAttribute *item = [[OTSTextAttribute alloc] init];
    item.title = title;
    item.font = font;
    item.color = color;
    return item;
}

@interface UILabel (OTSTextAttributeApply)

- (void)applyAttribute:(nullable OTSTextAttribute*)attribute
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor;

@end

@interface UIButton (OTSTextAttributeApply)

- (void)applyAttribute:(nullable OTSTextAttribute*)attribute
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor;

@end

NS_ASSUME_NONNULL_END
