//
//  JWSimpleShape.h
//  JWUIKit
//
//  Created by Jerry on 16/4/12.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface OTSSimpleShape : UIView

@property (assign, nonatomic) IBInspectable CGFloat lineWidth;
@property (assign, nonatomic) IBInspectable BOOL filled;

@property (strong, nonatomic) IBInspectable NSString *type;
@property (strong, nonatomic, nullable) IBInspectable NSString *subType;

- (void)beginSimpleAnimation;

@end

UIKIT_EXTERN NSString *const OTSSimpleShapeTypeYes;
UIKIT_EXTERN NSString *const OTSSimpleShapeTypeArrow;
UIKIT_EXTERN NSString *const OTSSimpleShapeTypeHeart;
UIKIT_EXTERN NSString *const OTSSimpleShapeTypePentastar;
UIKIT_EXTERN NSString *const OTSSimpleShapeTypeAdd;
UIKIT_EXTERN NSString *const OTSSimpleShapeTypeClose;


UIKIT_EXTERN NSString *const OTSSimpleShapeSubTypeArrowTop;
UIKIT_EXTERN NSString *const OTSSimpleShapeSubTypeArrowBottom;
UIKIT_EXTERN NSString *const OTSSimpleShapeSubTypeArrowLeft;
UIKIT_EXTERN NSString *const OTSSimpleShapeSubTypeArrowRight;

UIKIT_EXTERN NSString *const OTSSimpleShapeSubTypePentastarHalf;

NS_ASSUME_NONNULL_END
