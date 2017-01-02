//
//  OTSDrawerCollectionViewHeader.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

@protocol OTSDrawerHeaderDelegate <NSObject>

- (void)didToggleDrawerStateForSection:(NSInteger)section;

@end

@interface OTSDrawerCollectionViewHeader : OTSCollectionReusableView

@property (strong, nonatomic) UIView *decorationView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImgView;

@end
