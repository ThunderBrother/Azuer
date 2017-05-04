//
//  OTSDynamicContentViewProtocol.h
//  OTSKit
//
//  Created by Jerry on 2017/1/2.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OTSIntentModel;

typedef NS_ENUM(NSInteger, OTSDataSourceAction) {
    OTSDataSourceActionReload,
    
    OTSDataSourceActionInsertSection,
    OTSDataSourceActionDeleteSection,
    OTSDataSourceActionReloadSection,
    
    OTSDataSourceActionInsertRow,
    OTSDataSourceActionDeleteRow,
    OTSDataSourceActionReloadRow,
};

@protocol OTSDynamicContentViewProtocol <NSObject>

@property (nonatomic, weak) id delegate;

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol OTSDynamicLogicProtocol <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)didexecuteIntentModel:(OTSIntentModel*) intentModel;

@end

@protocol OTSDynamicVCProtocol <NSObject>

- (Class) logicClass;

- (NSArray<NSString*>* _Nullable)xibCellClassNames;
- (NSArray<NSString*>* _Nullable)codeCellClassNames;

- (void)handleIntentModel:(OTSIntentModel*)intentModel;
- (void)handleDataSourceAction:(OTSDataSourceAction)action
                        params:(nullable id)data;

@end

NS_ASSUME_NONNULL_END


