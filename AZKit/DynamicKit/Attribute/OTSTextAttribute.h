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

@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) NSUInteger color;
@property (assign, nonatomic) BOOL bold;

@property (assign, nonatomic) NSTextAlignment textAlignment; //default is NSTextAlignmentLeft
@property (assign, nonatomic) NSLineBreakMode lineBreakMode; //default is NSLineBreakByWordWrapping

- (CGFloat)referencedHeightForWidth:(CGFloat)preferredWidth
                    alternativeFont:(CGFloat)alternativeFontSize;

@end

NS_INLINE OTSTextAttribute* OTSTitleMake(NSString *title) {
    OTSTextAttribute *item = [[OTSTextAttribute alloc] init];
    item.title = title;
    return item;
}

NS_INLINE OTSTextAttribute* OTSTitleMakeF(NSString *title, CGFloat font, NSUInteger color) {
    OTSTextAttribute *item = [[OTSTextAttribute alloc] init];
    item.title = title;
    item.fontSize = font;
    item.color = color;
    return item;
}

@interface UILabel (OTSTextAttributeApply)

- (void)applyAttribute:(nullable OTSTextAttribute*)attribute
       alternativeFont:(CGFloat) alternativeFont
              andColor:(NSUInteger) alternativeColor
              delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
