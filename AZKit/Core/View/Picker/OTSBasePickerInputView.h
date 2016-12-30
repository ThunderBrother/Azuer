//
//  OTSBasePickerInputView.h
//  OTSKit
//
//  Created by Jerry on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

//fire event UIControlEventEditingDidEnd

NS_ASSUME_NONNULL_BEGIN

@interface OTSBasePickerInputView : UIControl

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIToolbar *toolbar;

+ (instancetype)pickerWithTextField:(nullable UITextField*)textField;


- (void)showInView:(UIView*)view;
- (void)hideFromSuperView;

@end

NS_ASSUME_NONNULL_END
