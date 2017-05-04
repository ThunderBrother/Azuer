//
//  OTSHomeItem.h
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OTSTableViewCellTextFieldDelegate <NSObject>

- (void)textFieldValueDidChanged:(UITextField*)textField;

@end

typedef NS_ENUM(NSInteger, OTSKeyboardTypeType) {
    OTSKeyboardTypeTypeDefault    = 0,
    OTSKeyboardTypeTypeArray,
    
    OTSKeyboardTypeTypePhone,
    OTSKeyboardTypeTypeDecimal,
    OTSKeyboardTypeTypeEmail,
    
    OTSKeyboardTypeTypeRegion
};

typedef NS_ENUM(NSInteger, OTSTableViewSelectionStyle) {
    OTSTableViewSelectionStyleInherited,
    OTSTableViewSelectionStyleNone,
    OTSTableViewSelectionStyleDefault
};

@interface OTSTableViewItem : OTSViewModelItem

@property (assign, nonatomic) BOOL isDefault;
@property (assign, nonatomic) BOOL disabled;
@property (assign, nonatomic) BOOL blockAutoValueChange;

@property (assign, nonatomic) OTSTableViewSelectionStyle selectionStyle;

@property (strong, nonatomic, nullable) NSString *valueString;
@property (strong, nonatomic, nullable) NSString *placeHolder;

@property (assign, nonatomic) OTSKeyboardTypeType keyboardType;
@property (strong, nonatomic, nullable) NSArray<NSString*> *contentsArray;

@property (strong, nonatomic, nullable) NSString *sourceFromName;

@property (assign, nonatomic) NSInteger allItemCount;

@end

@interface OTSTableViewItem (Factory)

//OTSFlexibleContentView, 44px height, left & right(nullable) title, accessory right arrow
+ (instancetype)simpleItemWithLeftTitle:(NSString*)leftTitle
                             rightTitle:(nullable NSString*)rightTitle;

//OTSFlexibleContentView, 44px height, left image & title, accessory right arrow
+ (instancetype)simpleItemWithImageNamed:(NSString*)imageName
                                   title:(NSString*)title;

//UIButton, 44px height
+ (instancetype)simpleButtonItemWithTitle:(NSString*)title;

//OTSFlexibleContentView, 35px height, Light Text Color, Background Color
+ (instancetype)simpleHeaderItemWithTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
