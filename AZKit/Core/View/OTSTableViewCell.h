//
//  OTSTableViewCell.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-1.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSTableViewCell : UITableViewCell

/**
 *  index
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  代理
 */
@property (nonatomic, weak) id delegate;

/**
 *  缩进边界
 */
@property (nonatomic) UIEdgeInsets cellEdgeInsets;


+ (NSString *)cellReuseIdentifier;


- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;


+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

@end
