//
//  UIView+Border.h
//  OTSKit
//
//  Created by Jerry on 16/8/31.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, OTSBorderOption) {
    OTSBorderOptionNone           = 0,
    OTSBorderOptionTop            = 1 << 0,
    OTSBorderOptionLeft           = 1 << 1,
    OTSBorderOptionBottom         = 1 << 2,
    OTSBorderOptionRight          = 1 << 3,
    OTSBorderOptionAll            = OTSBorderOptionTop | OTSBorderOptionLeft | OTSBorderOptionBottom | OTSBorderOptionRight
};

@interface UIView (Border)

@property (assign, nonatomic) CGFloat borderWidth;//default is 1.0
@property (assign, nonatomic) UIEdgeInsets borderInsets;//default is UIEdgeInsetsZero
@property (assign, nonatomic) OTSBorderOption borderOption;

@property (strong, nonatomic) UIColor *borderColor;//default is #e6e6e6

@end
