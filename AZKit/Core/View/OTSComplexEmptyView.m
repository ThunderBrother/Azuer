//
//  OTSComplexEmptyView.m
//  OneStoreLight
//
//  Created by wenjie on 16/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSComplexEmptyView.h"
#import "UIButton+Make.h"
#import "UIColor+Utility.h"
#import <Masonry/Masonry.h>

@interface OTSComplexEmptyView ()


@property (nonatomic,strong)UIButton    *activeBtn;
@property (nonatomic,strong)UIButton    *deActiveBtn;
@property (nonatomic,strong)UILabel     *footerLb;


@end

@implementation OTSComplexEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}



- (void)setTitle:(NSString *)title
        subtitle:(NSString *)subtitle
       imageName:(NSString *)imageName
     activeTitle:(NSString *)activeTitle
   deActiveTitle:(NSString *)deActiveTitle
     footerTitle:(NSString *)footerTitle
      clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock
         offsetY:(CGFloat)offsetY{
    [super setTitle:title imageName:imageName subtitle:subtitle clickBlock:clickBlock offsetY:offsetY];
    [self setBottomActiveTitle:activeTitle deActiveTitle:deActiveTitle footerTitle:footerTitle];
}

- (void)setBottomActiveTitle:(NSString *)activeTitle
               deActiveTitle:(NSString *)deActiveTitle
                 footerTitle:(NSString *)footerTitle{
    if (activeTitle.length && deActiveTitle.length) {
        [self.activeBtn setTitle:activeTitle forState:UIControlStateNormal];
        [self.deActiveBtn setTitle:deActiveTitle forState:UIControlStateNormal];
        [self addSubview:self.activeBtn];
        [self addSubview:self.deActiveBtn];
        [self.deActiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.mas_bottom).offset(-100);
        }];
        [self.activeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.deActiveBtn.mas_top).offset(-15);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@44);
        }];
        if (footerTitle.length) {
            self.footerLb.text = footerTitle;
            [self addSubview:self.footerLb];
            [self.footerLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.deActiveBtn.mas_bottom).offset(15);
                make.centerX.equalTo(self);
            }];
        }
    }
}


- (void)activeClick:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(kOTSExceptionBlockActiveType);
    }
}
- (void)deActiveClick:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(kOTSExceptionBlockDeactiveType);
    }
}


- (UIButton *)activeBtn{
    if (_activeBtn == nil) {
        _activeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_activeBtn makeForBottomActionButton];
        [_activeBtn addTarget:self action:@selector(activeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activeBtn;
}

- (UIButton *)deActiveBtn{
    if (_deActiveBtn == nil) {
        _deActiveBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_deActiveBtn makeForBottomActionButtonWhite];
        [_deActiveBtn addTarget:self action:@selector(deActiveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deActiveBtn;
}

- (UILabel *)footerLb{
    if (_footerLb == nil) {
        _footerLb = [[UILabel alloc]initWithFrame:CGRectZero];
        _footerLb.font = [UIFont systemFontOfSize:12];
        _footerLb.textColor = [UIColor colorWithRGB:0xBDBDBD];
    }
    return _footerLb;
}



@end
