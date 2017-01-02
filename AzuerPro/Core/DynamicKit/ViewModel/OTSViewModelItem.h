//
//  OTSViewModelItem.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"
#import "OTSImageAttribute.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTSViewModelItemType) {
    OTSViewModelItemTypeCell    = 0,
    OTSViewModelItemTypeHeader  = 1,
    OTSViewModelItemTypeFooter  = 2,
};

@interface OTSViewModelItem : OTSCodingObject {
    OTSImageAttribute *_subImageAttribute;
}

@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic, nullable) OTSViewAttribute *contentAttribute;

@property (strong, nonatomic, nullable) OTSImageAttribute *imageAttribute;
@property (strong, nonatomic, nullable) OTSImageAttribute *subImageAttribute;
@property (strong, nonatomic, nullable) OTSImageAttribute *accessoryImageAttibute;

@property (strong, nonatomic, nullable) OTSTextAttribute *titleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *subTitleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *thirdTitleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *fourthTitleAttribute;

@property (strong, nonatomic, nullable) OTSIntentModel *intentModel;

@property (strong, nonatomic, nullable) NSArray<NSString*> *imageURLArray;
@property (strong, nonatomic, nonnull) NSDictionary *userInfo;

@property (assign, nonatomic, readonly) OTSViewModelItemType itemType;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSString*)identifier NS_DESIGNATED_INITIALIZER;

@end

@protocol OTSViewModelItemHeaderFooterDelegate <NSObject>

- (void)didSelectHeaderAtSection:(NSInteger)section;
- (void)didSelectFooterAtSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
