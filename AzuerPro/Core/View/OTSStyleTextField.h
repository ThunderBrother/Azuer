//
//  OTSStyleTextField.h
//  OneStoreLight
//
//  Created by leo on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

//TextField样式枚举
typedef NS_ENUM(NSInteger,OTSStyleTextFieldType) {
    /**
     *默认上下划线
     */
    OTSStyleTextFieldTypeDefault = 0,
    /**
     * 左图
     */
    OTSStyleTextFieldEnumLeftImage = 1,
    /**
     * 文字
     */
    OTSStyleTextFieldEnumLeftText = 2,
    /**
     * 左图 + 文字
     */
    OTSStyleTextFieldEnumLeftImageAndText = 3,
    /**
     * 左图 + 文字 + 右图（含点击事件）
     */
    OTSStyleTextFieldEnumLeftImageAndTextAndRight = 4,
    /**
     * 文字 + 右图（含点击事件）
     */
    OTSStyleTextFieldEnumLeftTextAndRight = 5,
    /**
     * 右图（含点击事件）
     */
    OTSStyleTextFieldEnumRightImage = 6,
    OTSStyleTextFieldEnumLeftImageAndTextAndArrow = 7,
};

@protocol OTSStyleTextFieldDelegate <NSObject>
- (void)clickAtRightImageView:(UIImageView *)rightImageView;
@end

@interface OTSStyleTextField : UITextField

//枚举
@property (nonatomic,assign) OTSStyleTextFieldType styleTextFieldType;

//委托
@property (nonatomic,weak) id<OTSStyleTextFieldDelegate> styleTextFieldDelegate;

//下划线
@property (nonatomic,strong) UIImageView *lineImageView;
//上划线
@property (nonatomic,strong) UIImageView *topLineImageView;
//左图
@property (nonatomic,strong) UIImageView *leftImageView;
//右图
@property (nonatomic,strong) UIImageView *rightImageView;
//文字
@property (nonatomic,strong) UILabel *leftTextLabel;

@property (nonatomic,assign) CGFloat leftWidth;
//风格选择
- (instancetype)initWithType:(OTSStyleTextFieldType)type;
@end


@interface OTSStyleTextField (EnlargeArea)

/**
 *  设置需要右边扩大的范围
 *
 */
- (void) setEnlargeRightEdge:(CGFloat) edge;


@end
