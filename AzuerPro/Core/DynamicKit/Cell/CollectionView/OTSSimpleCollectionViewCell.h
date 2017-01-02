//
//  OTSSimpleCollectionViewCell.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/14.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OTSImageAttribute;

struct OTSDefaultCollectionViewCellTitleWidth {
    CGFloat leftWidth;
    CGFloat leftSubWidth;
    CGFloat rightWidth;
    CGFloat rightSubWidth;
};

typedef struct OTSDefaultCollectionViewCellTitleWidth OTSDefaultCollectionViewCellTitleWidth;

@protocol OTSDefaultCollectionTableViewCellDelegate <NSObject>

- (void)didPressRightButton:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface OTSSimpleCollectionViewCell : OTSCollectionViewCell {
    OTSImageAttribute *_imageAttribute;
    OTSImageAttribute *_rightImageAttribute;
    OTSImageAttribute *_accessoryImageAttribute;
    
    OTSDefaultCollectionViewCellTitleWidth _preferredWidth;
    
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

@end

NS_ASSUME_NONNULL_END
