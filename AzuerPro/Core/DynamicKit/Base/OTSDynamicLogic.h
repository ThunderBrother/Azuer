//
//  OTSDynamicLogic.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSDynamicLogic : OTSLogic

@property (strong, nonatomic, nullable) NSIndexSet *insertedSectionIndexSet;
@property (strong, nonatomic, nullable) NSIndexSet *deletedSectionIndexSet;
@property (strong, nonatomic, nullable) NSIndexSet *reloadedSectionIndexSet;

@property (strong, nonatomic, nullable) NSArray<NSIndexPath*> *insertedRowsIndexPathes;
@property (strong, nonatomic, nullable) NSArray<NSIndexPath*> *deletedRowsIndexPathes;
@property (strong, nonatomic, nullable) NSArray<NSIndexPath*> *reloadedRowsIndexPathes;

@end

typedef NS_ENUM(NSInteger, OTSDataSourceAction) {
    OTSDataSourceActionReload,
    
    OTSDataSourceActionInsertSection,
    OTSDataSourceActionDeleteSection,
    OTSDataSourceActionReloadSection,
    
    OTSDataSourceActionInsertRow,
    OTSDataSourceActionDeleteRow,
    OTSDataSourceActionReloadRow,
};

@protocol OTSDynamicLogicProtocol <NSObject>

- (Class) logicClass;

- (NSArray<NSString*>* _Nullable)xibCellClassNames;
- (NSArray<NSString*>* _Nullable)codeCellClassNames;

- (void)handleIntentModel:(OTSIntentModel*)intentModel;
- (void)handleDataSourceAction:(OTSDataSourceAction)action
                        params:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
