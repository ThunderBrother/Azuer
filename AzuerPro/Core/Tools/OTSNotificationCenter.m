	//
//  OTSNotificationCenter.m
//  OneStoreLight
//
//  Created by leo on 16/10/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSNotificationCenter.h"

@interface OTSNotificationCenter ()
@property(nonatomic,assign) BOOL iskeyboard;//键盘是否显示
@property(nonatomic,assign) CGFloat keyboardY;//键盘的位置
@property(nonatomic,assign) CGFloat duration;//键盘动画时间
@property(nonatomic,assign) CGFloat winCenterY;//未移动的值
@property(nonatomic,assign) CGFloat mobile_Offset;//移动的值
@property(nonatomic,strong) UIWindow *window;
@end

@implementation OTSNotificationCenter
DEF_SINGLETON(OTSNotificationCenter)



- (void)addKeyboardNotification;
{
    [self deallocKeyboardNotification];
    //注册键盘出现通知；
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失通知；
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)deallocKeyboardNotification{
    //解除键出现盘通知；
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //解除键盘隐藏通知;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - notification
-(void)keyboardDidShow:(NSNotification *)notification
{
    _iskeyboard = YES;

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    _keyboardY = UI_CURRENT_SCREEN_HEIGHT - keyboardHeight - 64;
    _duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    WEAK_SELF;
    [UIView animateWithDuration:_duration animations:^{
        STRONG_SELF;
        self.window.center = CGPointMake(self.window.center.x, self->_winCenterY);
    }];
    
    _mobile_Offset = 0.0f;
    _iskeyboard = NO;
}
- (void)offsetConvertRectWithControl:(UIControl *)control{
    //解决键盘遮挡输入框问题
    if(!self.iskeyboard || self.mobile_Offset || control.hidden )return;
    
    self.iskeyboard = NO;
    CGRect rect = [control convertRect:control.bounds toView:self.window];
    CGFloat textField_Y = rect.origin.y + rect.size.height - 64;

    if(self.keyboardY >= textField_Y)return;
    self.mobile_Offset = textField_Y - self.keyboardY;
    
    WEAK_SELF;
    [UIView animateWithDuration:_duration animations:^{
        STRONG_SELF;
        self.window.center = CGPointMake(self.window.center.x, self.window.center.y - self.mobile_Offset);
    }];
    
    
}
#pragma get
-(UIWindow *)window{
    if(!_window){
        _window = [[[UIApplication sharedApplication] delegate] window];
        _winCenterY = _window.center.y;
    }
    return _window;
}


@end
