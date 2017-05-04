//
//  OTSHomeSection.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCollectionViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSCollectionViewSection : OTSCodingObject

@property (strong, nonatomic, nullable) OTSCollectionViewItem *header;
@property (strong, nonatomic, nullable) OTSCollectionViewItem *footer;

@property (strong, nonatomic) NSArray<OTSCollectionViewItem*> *items;

@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat hSpace;
@property (assign, nonatomic) CGFloat vSpace;
@property (assign, nonatomic) BOOL overlapped;

@property (assign, nonatomic, readonly) NSUInteger itemsCount;

@property (assign, nonatomic) BOOL closed;

@end

NS_ASSUME_NONNULL_END
