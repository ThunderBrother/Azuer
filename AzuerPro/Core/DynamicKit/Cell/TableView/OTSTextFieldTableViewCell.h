//
//  OTSTextFieldCell.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/13.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSTextFieldTableViewCell : OTSTableViewCell

@property (strong, nonatomic, readonly) UITextField *textField;
@property (strong, nonatomic, nullable,readonly) UILabel *titleLabel;

@property (strong, nonatomic, nullable, readonly) UIImageView *leftImageView;
@property (strong, nonatomic, nullable, readonly) UIImageView *rightImageView;
@property (strong, nonatomic, nullable, readonly) UIImageView *textFieldRightImageView;

@end

NS_ASSUME_NONNULL_END
