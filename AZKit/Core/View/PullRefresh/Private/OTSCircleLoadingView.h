//
//  OTSCircleLoadingView.h
//  OTSUIKit
//
//  Created by Jerry on 16/3/29.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OTSLoadingProtocol <NSObject>

- (void)startAnimating;

- (void)stopAnimating;

- (BOOL)isAnimating;

@end

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTSCircleLoadingStyle){
    OTSCircleLoadingStyleDefault      = 0,
    OTSCircleLoadingStyleCumulative   = 1,
    OTSCircleLoadingStyleGradient     = 2
};

@interface OTSCircleLoadingView : UIView<OTSLoadingProtocol>

@property (assign, nonatomic) BOOL isAnimating;

@property (assign, nonatomic) OTSCircleLoadingStyle style;

@property (assign, nonatomic) CGFloat lineWidth;//default is 3.0
@property (assign, nonatomic) BOOL drawBackground;

@end

NS_ASSUME_NONNULL_END
