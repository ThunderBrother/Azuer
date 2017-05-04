//
//  OTSFlexibleContentView.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSAbstractContentView.h"

@class OTSViewModelItem;
@class OTSPlaceHolderImageView;

NS_ASSUME_NONNULL_BEGIN

@interface OTSFlexibleContentView : OTSAbstractContentView {
    UILabel *_leftTitleLabel;
    UILabel *_leftSubTitleLabel;
    UILabel *_rightTitleLabel;
    UILabel *_rightSubTitleLabel;
    
    OTSPlaceHolderImageView *_leftImageView;
    UIButton *_rightButton;
    UIImageView *_accessoryImageView;
    
    OTSViewModelItem *_attribute;
}

@property (strong, nonatomic, readonly) UILabel *leftTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *leftSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) UILabel *rightTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *rightSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) OTSPlaceHolderImageView *leftImageView;
@property (strong, nonatomic, nullable, readonly) UIImageView *accessoryImageView;

@property (strong, nonatomic, nullable, readonly) UIButton *rightButton;

//Protected Funcs
- (UILabel*)__createLabel;

//Layout LeftImageView, accessoryImageView, and right Button
- (void)__layoutLeftRightViewsWithLeftEdge:(out CGFloat*)edgeLeft
                                 rightEdge:(out CGFloat*)edgeRight;

//Layout Center ContentView
- (void)__layoutContentViewWithLeftEdge:(CGFloat)edgeLeft
                              rightEdge:(CGFloat)edgeRight;

+ (CGFloat)__defaultFontForLabelAtIndex:(NSUInteger)index;
+ (NSUInteger)__defaultColorForLabelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
