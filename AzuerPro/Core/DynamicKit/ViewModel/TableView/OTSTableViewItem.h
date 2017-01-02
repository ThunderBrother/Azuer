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

typedef NS_OPTIONS(NSUInteger, OTSTableViewAction){
    OTSTableViewActionNone          = 0,
    OTSTableViewActionToggle        = 1 << 0,
    OTSTableViewActionGroupToggle   = 1 << 1,
    OTSTableViewActionAllToggle     = 1 << 2,
    
    OTSTableViewActionReloadSection = 1 << 8
};

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

@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL isDefault;
@property (assign, nonatomic) BOOL disabled;
@property (assign, nonatomic) OTSTableViewSelectionStyle selectionStyle;

@property (strong, nonatomic, nullable) NSString *valueString;

@property (assign, nonatomic) OTSKeyboardTypeType keyboardType;
@property (strong, nonatomic, nullable) NSArray<NSString*> *contentsArray;

@property (assign, nonatomic) OTSTableViewAction appAction;
@property (assign, nonatomic) BOOL blockAutoValueChange;


@property (strong, nonatomic, nullable) NSString *sourceFromName;

@property (assign, nonatomic) NSInteger allItemCount;

@end

@interface OTSTableViewItem (Factory)

//OTSTableViewCell + OTSFlexibleContentView, 44px height, left & right(nullable) title, accessory right arrow
+ (instancetype)simpleItemWithLeftTitle:(NSString*)leftTitle
                             rightTitle:(nullable NSString*)rightTitle;

//OTSTableViewCell + OTSFlexibleContentView, 44px height, left image & title, accessory right arrow
+ (instancetype)simpleItemWithImageNamed:(NSString*)imageName
                                   title:(NSString*)title;

//OTSSimpleButtonTableViewCell, 44px height
+ (instancetype)simpleButtonItemWithTitle:(NSString*)title;

//OTSTableViewHeaderFooterView + OTSFlexibleContentView, 35px height, Light Text Color, Background Color
+ (instancetype)simpleHeaderItemWithTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
