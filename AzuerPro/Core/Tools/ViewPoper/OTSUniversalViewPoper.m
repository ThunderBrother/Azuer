//
//  OTSUniversalViewPoper.m
//  OneStore
//
//  Created by huangjiming on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//
#import <PureLayout/ALView+PureLayout.h>
#import <OTSKit/OTSCurrentAddress.h>
#import "OTSUniversalViewPoper.h"
#import "OTSPickerView.h"
//category
//#import "UIView+create.h"
//define
//#import "OTSSizeDefine.h"

@interface OTSUniversalViewPoper()<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIView *popView;
@property(nonatomic, strong) UIImageView *titleBg;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *finishBtn;
@property(nonatomic, strong) UIView *subBgView;
@property(nonatomic, strong) OTSPickerView *pickerView;

@end

@implementation OTSUniversalViewPoper

@synthesize popView = _popView;

- (void)dealloc
{
    [_cancelBtn removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    
    [_finishBtn removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    
    _pickerView.dataSource = nil;
    _pickerView.delegate = nil;
}

#pragma mark - Property
- (UIImageView *)titleBg
{
    if (_titleBg == nil) {
        _titleBg =  [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleBg.translatesAutoresizingMaskIntoConstraints = NO;
        _titleBg.backgroundColor = [UIColor clearColor];
        _titleBg.image = [UIImage imageNamed:@"actionsheet_bg"];
    }
    
    return _titleBg;
}

- (UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"actionsheet_cancel"] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"actionsheet_cancel_sel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelBtn;
}

-(UILabel *)theCluesLab{
    if (_theCluesLab == nil) {
        _theCluesLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _theCluesLab.translatesAutoresizingMaskIntoConstraints = NO;
        _theCluesLab.backgroundColor = [UIColor clearColor];
        
        
        _theCluesLab.font=[UIFont systemFontOfSize:11];
        _theCluesLab.textColor = [UIColor whiteColor];
        _theCluesLab.text = @"请选择您的收货区域\n我们帮你挑选最合适的客服";
        _theCluesLab.numberOfLines=2;
        _theCluesLab.textAlignment=NSTextAlignmentCenter;
        _theCluesLab.hidden = YES;
    }
    return _theCluesLab;
}

- (UIButton *)finishBtn
{
    if (_finishBtn == nil) {
        _finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_CURRENT_SCREEN_WIDTH-56, 6, 48, 33)];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"actionsheet_confirm"] forState:UIControlStateNormal];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"actionsheet_confirm_sel"] forState:UIControlStateHighlighted];
        [_finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _finishBtn;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[OTSPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        _pickerView.backgroundColor = [UIColor clearColor];
        
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    
    return _pickerView;
}

- (UIView *)popView
{
    if (_popView == nil) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, 240)];
        
        [_popView addSubview:self.subBgView];
        
        [_popView addSubview:self.titleBg];
        [_popView addSubview:self.cancelBtn];
        [_popView addSubview:self.theCluesLab];
        [_popView addSubview:self.finishBtn];
        [_popView addSubview:self.pickerView];
        
        [self setupConstraints];
    }
    
    return _popView;
}

- (UIView *)subBgView
{
    if (_subBgView == nil) {
        _subBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _subBgView.translatesAutoresizingMaskIntoConstraints = NO;
        _subBgView.backgroundColor = [UIColor clearColor];
        
        _subBgView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _subBgView.layer.cornerRadius = 5.0;
    }
    
    return _subBgView;
}

- (void)setupConstraints
{
    [self.subBgView autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    
    [self.titleBg autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.titleBg autoSetDimension:ALDimensionHeight toSize:44.0];

    [self.cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0];
    [self.cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.0];
    [self.cancelBtn autoSetDimensionsToSize:CGSizeMake(48.0, 33.0)];
    
    [self.finishBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8.0];
    [self.finishBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.0];
    [self.finishBtn autoSetDimensionsToSize:CGSizeMake(48.0, 33.0)];
    
    [self.pickerView autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(44.0, 10.0, 0.0, 10.0) excludingEdge:ALEdgeBottom];
    [self.pickerView autoSetDimension:ALDimensionHeight toSize:196.0];

    [self.theCluesLab autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(6.0, 56.0, 0.0, 56.0) excludingEdge:ALEdgeBottom];
    [self.theCluesLab autoSetDimension:ALDimensionHeight toSize:40.0];
}

#pragma mark - Action
- (void)finishBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:finishBtnClicked:)]) {
        [self.delegate viewPoper:self finishBtnClicked:sender];
    }
    
    [self hidePopView];
    self.theCluesLab.hidden=YES;
}

- (void)cancelBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:cancelBtnClicked:)]) {
        [self.delegate viewPoper:self cancelBtnClicked:sender];
    }
    
    [self hidePopView];
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:numberOfComponentsInPickerView:)]) {
        return [self.delegate viewPoper:self numberOfComponentsInPickerView:pickerView];
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:pickerView:numberOfRowsInComponent:)]) {
        return [self.delegate viewPoper:self pickerView:pickerView numberOfRowsInComponent:component];
    }
    
    return 99;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:pickerView:titleForRow:forComponent:)]) {
        return [self.delegate viewPoper:self pickerView:pickerView titleForRow:row forComponent:component];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(viewPoper:pickerView:didSelectRow:inComponent:)]) {
        [self.delegate viewPoper:self pickerView:pickerView didSelectRow:row inComponent:component];
    }
}

@end
