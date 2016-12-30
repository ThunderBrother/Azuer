//
//  OTSPickerView.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBasePickerInputView.h"

//fire event UIControlEventEditingDidEnd

NS_ASSUME_NONNULL_BEGIN

@interface OTSArrayPickerInputView : OTSBasePickerInputView

@property (strong, nonatomic) NSArray<NSString*> *dataArray;
@property (strong, nonatomic, nullable) NSString *selectedString;


@end

NS_ASSUME_NONNULL_END
