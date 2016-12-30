//
//  OTSCircleProgressView.h
//  OTSUIKit
//
//  Created by Jerry on 16/3/22.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTSProgressProtocol <NSObject>

- (void)setProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, OTSCircleProgressStyle){
    OTSCircleProgressStyleDefault,
    OTSCircleProgressStylePie
};

@interface OTSCircleProgressView : UIView<OTSProgressProtocol>

@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) OTSCircleProgressStyle style;

@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) BOOL drawBackground;//default is YES
@property (assign, nonatomic) BOOL clockWise;//default is YES

@property (strong, nonatomic) UIColor *backgroundTintColor;//default is 0xe6e6e6

@end

NS_ASSUME_NONNULL_END
