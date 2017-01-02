//
//  OTSEmptyView.m
//  OneStoreLight
//
//  Created by wenjie on 16/11/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSEmptyView.h"


@interface OTSEmptyView ()


@property (nonatomic,strong)UILabel     *titleLb;
@property (nonatomic,strong)UILabel     *subtitleLb;

@end

@implementation OTSEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        [self __setupUI];
    }
    return self;
}

- (void)__setupUI {
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLb];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-17.5);
        make.centerX.equalTo(self);
        make.height.width.equalTo(@80);
    }];

    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.width.equalTo(@(self.frame.size.width-30));
        make.height.equalTo(@20);
    }];
}

- (void)setTitle:(NSString *)title
       imageName:(NSString *)imageName
        subtitle:(NSString *)subtitle
      clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock
         offsetY:(CGFloat)offsetY{
    self.titleLb.text = title;
    CGFloat updateOffset = offsetY;
    self.imageView.image = [UIImage imageNamed:imageName];
    if (subtitle.length) {
        self.subtitleLb.text = subtitle;
        [self addSubview:self.subtitleLb];
        [self.subtitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(15);
            make.centerX.equalTo(self);
            make.height.equalTo(@20);
        }];
        updateOffset = offsetY - 35;
    }
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(updateOffset);
    }];
    if (clickBlock) {
        self.clickBlock = clickBlock;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)clickTap:(UITapGestureRecognizer *)tap{
    if (self.clickBlock) {
        self.clickBlock(kOTSExceptionBlockRefreshType);
    }
}

#pragma mark - Getter & Setter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor colorWithRGB:0x606060];
    }
    return _titleLb;
}
- (UILabel *)subtitleLb{
    if (_subtitleLb == nil) {
        _subtitleLb = [[UILabel alloc]initWithFrame:CGRectZero];
        _subtitleLb.font = [UIFont systemFontOfSize:14];
        _subtitleLb.textAlignment = NSTextAlignmentCenter;
        _subtitleLb.textColor = [UIColor colorWithRGB:0x606060];
    }
    return _subtitleLb;
}

@end
