//
//  OTSBasePickerInputView.m
//  OTSKit
//
//  Created by Jerry on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBasePickerInputView.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
#import "AZFuncDefine.h"

@interface OTSBasePickerInputView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UITextField *textField;

@end

@implementation OTSBasePickerInputView

+ (instancetype)pickerWithTextField:(UITextField*)textField {
    
    UIView *oldInputView = textField.inputView;
    if ([oldInputView isKindOfClass:[self class]]) {
        return (id)oldInputView;
    }
    
    OTSBasePickerInputView *inputView = [[self alloc] initWithFrame:CGRectMake(0, 0, UI_CURRENT_SCREEN_WIDTH, [self preferredHeight])];
    inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inputView.textField = textField;
    textField.inputView = inputView;
    return inputView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.toolbar];
        [self addSubview:self.pickerView];
    }
    return self;
}

+ (CGFloat) preferredHeight {
    return 220.0;
}

- (void)showInView:(UIView*)view {
    if ([self isHaveInView:view]) {
        return;
    }
    self.transform = CGAffineTransformIdentity;
    self.frame = CGRectMake(0, view.height - self.height, self.width, self.height);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [view addSubview:self];
    
    self.transform = CGAffineTransformMakeTranslation(0, self.height);
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (BOOL)isHaveInView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)hideFromSuperView {
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)didPressSubmitButton {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    [self didPressCancelButton];
}

- (void)didPressCancelButton {
    if (self.textField) {
        [self.textField resignFirstResponder];
    } else {
        [self hideFromSuperView];
    }
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - Getter & Setter
- (UIPickerView*)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height - 44)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIToolbar*)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44.0)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolbar.tintColor = [UIColor colorWithRGB:0xfa585d];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressCancelButton)];
        
        UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL];
        
        UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didPressSubmitButton)];
        
        _toolbar.items = @[cancelItem, flexbleItem, submitItem];
    }
    return _toolbar;
}

@end
