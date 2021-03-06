//
//  OTSCollectionViewCell.h
//  OneStoreFramework
//
//  Created by Aimy on 9/4/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSCollectionViewCell : UICollectionViewCell

/**
 *  index
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  代理
 */
@property (nonatomic, weak) id delegate;

/**
 *  功能:获取cell的唯一标识符
 */
+ (NSString *)cellReuseIdentifier;

/**
 *  功能:获取cell对应的xib
 */
+ (UINib *)nib;

/**
 *	功能:cell根据数据和位置显示ui
 *
 *	@param aData cell数据
 *	@param indexPath cell位置
 */
- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

/**
 *	功能:获取cell的大小
 *
 *	@param aData cell的数据
 *
 */
+ (CGSize)sizeForCellData:(id)aData;

@end
