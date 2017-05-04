//
//  OTSHomeItem.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@class OTSCollectionViewSection;

@interface OTSCollectionViewItem : OTSViewModelItem

@property (weak, nonatomic, nullable) OTSCollectionViewSection *parent;

@end

NS_ASSUME_NONNULL_END
