//
//  UIButton+Position.h
//  OTSKit
//
//  Created by Jerry on 2016/11/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTSButtonPosition) {
    OTSButtonPositionDefault = 0,//image left and text right
    OTSButtonPositionImageTop = 1,//image top and text bottom
    OTSButtonPositionImageRight = 2//text left and image right
};

@interface UIButton (Position)

@property (assign, nonatomic) OTSButtonPosition position;//default is OTSButtonPositionDefault. It will change titleEdgeInsets and imageEdgeInsets

@property (assign, nonatomic) IBInspectable CGFloat offset;//default is 0. Must be greater than 0. The margin between text and image. It will change titleEdgeInsets and imageEdgeInsets

@property (assign, nonatomic) IBInspectable CGFloat padding;//default is 0. It will change contentEdgeInsets.

- (void)updateButtonInsets;

@end

NS_ASSUME_NONNULL_END
