//
//  OTSFlexibleContentView.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSAbstractContentView.h"

@class OTSViewModelItem;

NS_ASSUME_NONNULL_BEGIN

@protocol OTSFlexibleContentViewDelegate <NSObject>

- (void)didPressRightButton:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface OTSFlexibleContentView : OTSAbstractContentView {
    UILabel *_leftTitleLabel;
    UILabel *_leftSubTitleLabel;
    UILabel *_rightTitleLabel;
    UILabel *_rightSubTitleLabel;
    
    UIImageView *_leftImageView;
    UIButton *_rightButton;
    UIImageView *_accessoryImageView;
    
    OTSViewModelItem *_attribute;
}

@property (strong, nonatomic, readonly) UILabel *leftTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *leftSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) UILabel *rightTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *rightSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) UIImageView *leftImageView;
@property (strong, nonatomic, nullable, readonly) UIImageView *accessoryImageView;

@property (strong, nonatomic, nullable, readonly) UIButton *rightButton;

//Protected Funcs
- (UILabel*)__createLabel;
- (void)__layoutCellSubViews;

+ (CGFloat)__defaultFontForLabelAtIndex:(NSUInteger)index;
+ (NSUInteger)__defaultColorForLabelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
