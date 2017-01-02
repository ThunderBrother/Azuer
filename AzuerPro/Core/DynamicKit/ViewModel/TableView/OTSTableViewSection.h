//
//  OTSHomeSection.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTableViewItem.h"
#import <UIKit/UIGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSTableViewSection : OTSCodingObject

@property (strong, nonatomic, nullable) OTSTableViewItem *header;
@property (strong, nonatomic, nullable) OTSTableViewItem *footer;

@property (strong, nonatomic, nullable) OTSIntentModel *intentModel;

@property (strong, nonatomic) NSArray<OTSTableViewItem*> *rows;

+ (nullable NSIndexPath*)indexPathForItem:(OTSTableViewItem*)item
                               inSections:(NSArray<OTSTableViewSection*>*)sections;

@end

NS_ASSUME_NONNULL_END
