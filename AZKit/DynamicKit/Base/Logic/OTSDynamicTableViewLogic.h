//
//  OTSDynamicTableViewLogic.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicLogic.h"
#import "OTSDynamicKitProtocol.h"

@class OTSTableViewSection;
@class OTSTableViewItem;

NS_ASSUME_NONNULL_BEGIN

@interface OTSDynamicTableViewLogic : OTSDynamicLogic {
    NSIndexPath *_actionIndexPath;
    NSArray<NSIndexPath*> *_autoReloadIndexPathes;
    NSArray<OTSTableViewSection*> *_sections;
}

@property (strong, nonatomic, nullable) NSArray<OTSTableViewSection*> *sections;
@property (strong, nonatomic, nullable) NSIndexPath *actionIndexPath;

- (nullable OTSTableViewItem*)itemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface OTSDynamicTableViewLogic (TableViewDelegate)<UITableViewDelegate, OTSDynamicLogicProtocol>

@end

@interface OTSDynamicTableViewLogic (TableViewDataSource)<UITableViewDataSource>

@end

@interface OTSDynamicTableViewLogic (TextFieldDelegate)<UITextFieldDelegate>

@end

NS_ASSUME_NONNULL_END
