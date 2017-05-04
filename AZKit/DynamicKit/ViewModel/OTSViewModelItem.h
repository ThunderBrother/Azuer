//
//  OTSViewModelItem.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"
#import "OTSImageAttribute.h"
#import "OTSCombinedAttribute.h"
#import "OTSIntentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OTSViewModelItemType) {
    OTSViewModelItemTypeCell    = 0,
    OTSViewModelItemTypeHeader  = 1,
    OTSViewModelItemTypeFooter  = 2,
};

typedef NS_OPTIONS(NSUInteger, OTSViewAction){
    OTSViewActionNone          = 0,
    OTSViewActionToggle        = 1 << 0,
    OTSViewActionGroupToggle   = 1 << 1,
    OTSViewActionAllToggle     = 1 << 2,
    
    OTSViewActionReloadSection = 1 << 8
};

@interface OTSViewModelItem : OTSCodingObject

@property (strong, nonatomic) NSString *cellIdentifier;

@property (strong, nonatomic, nullable) OTSViewAttribute *contentAttribute;

@property (strong, nonatomic, nullable) OTSImageAttribute *imageAttribute;
@property (strong, nonatomic, nullable) OTSImageAttribute *accessoryImageAttibute;
@property (strong, nonatomic, nullable) OTSCombinedAttribute *buttonAttribute;

@property (strong, nonatomic, nullable) OTSTextAttribute *titleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *subTitleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *thirdTitleAttribute;
@property (strong, nonatomic, nullable) OTSTextAttribute *fourthTitleAttribute;

@property (strong, nonatomic, nullable) OTSIntentModel *intentModel;

@property (strong, nonatomic, nullable) NSArray<NSString*> *imageURLArray;
@property (strong, nonatomic, nullable) NSDictionary *userInfo;

@property (assign, nonatomic, readonly) OTSViewModelItemType itemType;

@property (assign, nonatomic) OTSViewAction appAction;
@property (assign, nonatomic) BOOL selected;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIdentifier:(NSString*)identifier NS_DESIGNATED_INITIALIZER;

- (void)applyCSS:(NSString*)cssString;

@end

NS_ASSUME_NONNULL_END
