//
//  OTSEmptyView.h
//  OneStoreLight
//
//  Created by wenjie on 16/11/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OTSExceptionBlockType){
    kOTSExceptionBlockRefreshType   = 1,
    kOTSExceptionBlockActiveType    = 2,
    kOTSExceptionBlockDeactiveType  = 3,
    kOTSExceptionBlockSubTitleType  = 4
};

@interface OTSEmptyView : UIView

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,copy) void(^clickBlock)(OTSExceptionBlockType blockType);

- (void)setTitle:(NSString *)title
       imageName:(NSString *)imageName
        subtitle:(NSString *)subtitle
      clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock
         offsetY:(CGFloat)offsetY;

- (void)setSubTitleColor:(UIColor *)color;

@end
