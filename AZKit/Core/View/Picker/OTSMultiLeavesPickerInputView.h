//
//  OTSMultiLeavesPickerInputView.h
//  OTSKit
//
//  Created by Jerry on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBasePickerInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSMultiLeavesPickerData : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic, nullable) NSArray<OTSMultiLeavesPickerData*> *sub;

@end


@interface OTSMultiLeavesPickerInputView : OTSBasePickerInputView

@property (strong, nonatomic) NSArray<NSString*> *levelTitles;
@property (strong, nonatomic) NSArray<OTSMultiLeavesPickerData*> *dataArray;

@property (strong, nonatomic, nullable) NSArray<NSNumber*> *selectedIndexSet;

@end

NS_ASSUME_NONNULL_END
