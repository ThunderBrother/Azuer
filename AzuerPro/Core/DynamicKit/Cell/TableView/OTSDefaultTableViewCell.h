//
//  OTSDefaultTableViewCell.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/15.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OTSImageAttribute;

typedef struct OTSDefaultTableViewCellTitleWidth {
    CGFloat leftWidth;
    CGFloat leftSubWidth;
    CGFloat rightWidth;
    CGFloat rightSubWidth;
} OTSDefaultTableViewCellTitleWidth;

/*
 
 |---------------------------------------------------------------------------------------------------------------|
 |                            |                                                                                  |
 |                            15                                                                                 |
 |                            |                                                                                  |
 |                      |------------|      |-------------|                                                      |
 |                      |  titleAttr |      |  thirdAttr  |                                                      |
 |     |---------|      |------------|      |-------------|      |--------------|      |-------------------|     |
 |-15- |imageAttr| -10-                -10-                 -10- | subImageAttr | -10- | accessoryImageAttr| -15-|
 |     |---------|      |------------|      |-------------|      |______________|      |-------------------|     |
 |                      |subTitleAttr|      |  fourthAttr |                                                      |
 |                      |------------|      |-------------|                                                      |
 |                            |                                                                                  |
 |                            15                                                                                 |
 |                            |                                                                                  |
 |---------------------------------------------------------------------------------------------------------------|
 
 */

@protocol OTSDefaultTableViewCellDelegate <NSObject>

- (void)didPressRightButton:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface OTSDefaultTableViewCell : OTSTableViewCell {
    OTSImageAttribute *_imageAttribute;
    OTSImageAttribute *_rightImageAttribute;
    OTSImageAttribute *_accessoryImageAttribute;
    
    OTSDefaultTableViewCellTitleWidth _preferredWidth;
    
    UILabel *_leftTitleLabel;
    UILabel *_leftSubTitleLabel;
    UILabel *_rightTitleLabel;
    UILabel *_rightSubTitleLabel;
    
    UIImageView *_leftImageView;
    UIButton *_rightButton;
    UIImageView *_accessoryImageView;
}

@property (strong, nonatomic, readonly) UILabel *leftTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *leftSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) UILabel *rightTitleLabel;
@property (strong, nonatomic, nullable, readonly) UILabel *rightSubTitleLabel;

@property (strong, nonatomic, nullable, readonly) UIImageView *leftImageView;
@property (strong, nonatomic, nullable, readonly) UIButton *rightButton;
@property (strong, nonatomic, nullable, readonly) UIImageView *accessoryImageView;

//Protected Funcs
- (UILabel*)__createLabel;
- (void)__layoutCellSubViews;

+ (CGFloat)__defaultFontForLabelAtIndex:(NSUInteger)index;
+ (NSUInteger)__defaultColorForLabelAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
