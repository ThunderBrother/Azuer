//
//  OTSUniversalViewPoper.h
//  OneStore
//
//  Created by huangjiming on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSViewPoper.h"

@class OTSUniversalViewPoper;
@class OTSPickerView;


@protocol OTSUniversalViewPoperDelegate <NSObject>

@optional
/**
 *  功能:点击取消按钮
 */
- (void)viewPoper:(OTSUniversalViewPoper *)aViewPoper cancelBtnClicked:(id)sender;

/**
 *  功能:点击完成按钮
 */
- (void)viewPoper:(OTSUniversalViewPoper *)aViewPoper finishBtnClicked:(id)sender;

#pragma mark - picker view相关datasource和delegate
/**
 *  功能:picker view的componet数量
 */
- (NSInteger)viewPoper:(OTSUniversalViewPoper *)aViewPoper numberOfComponentsInPickerView:(UIPickerView *)pickerView;

/**
 *  功能:picker view的componet的行数
 */
- (NSInteger)viewPoper:(OTSUniversalViewPoper *)aViewPoper pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

/**
 *  功能:picker view每行的title
 */
- (NSString *)viewPoper:(OTSUniversalViewPoper *)aViewPoper pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

/**
 *  功能:picker view点击某一行
 */
- (void)viewPoper:(OTSUniversalViewPoper *)aViewPoper pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface OTSUniversalViewPoper : OTSViewPoper

@property(nonatomic, weak) id<OTSUniversalViewPoperDelegate> delegate;
@property(nonatomic, readonly, strong) OTSPickerView *pickerView;
@property(nonatomic, strong) UILabel *theCluesLab;//进入客服中心，需要增加提示语（）
@end
