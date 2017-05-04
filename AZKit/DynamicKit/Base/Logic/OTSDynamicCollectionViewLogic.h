//
//  OTSDynamicCollectionViewLogic.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicLogic.h"
#import "OTSDynamicKitProtocol.h"
#import "OTSCollectionViewSection.h"

@interface OTSDynamicCollectionViewLogic : OTSDynamicLogic {
    NSArray<OTSCollectionViewSection*> *_sections;
}

@property (strong, nonatomic) NSArray<OTSCollectionViewSection*> *sections;

- (OTSCollectionViewItem*)itemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface OTSDynamicCollectionViewLogic (CollectionViewDelegate)<UICollectionViewDelegateFlowLayout, OTSDynamicLogicProtocol>

@end

@interface OTSDynamicCollectionViewLogic (CollectionViewDataSource)<UICollectionViewDataSource>

@end
