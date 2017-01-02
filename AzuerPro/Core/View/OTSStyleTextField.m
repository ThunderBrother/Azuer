//
//  OTSStyleTextField.m
//  OneStoreLight
//
//  Created by leo on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSStyleTextField.h"
#import <Masonry/Masonry.h>
#import <OTSKit/OTSKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "OTSNotificationCenter.h"
#import <objc/runtime.h>

#define IS_Retina ([[UIScreen mainScreen] scale] > 1)
#define ISRetina_Min_Line (IS_Retina? 0.5: 1)

@interface OTSStyleTextField (){
    CGFloat _mobile_Offset;//移动的位置
}
@property (nonatomic,strong) UIView *leftContainerView;
@end

@implementation OTSStyleTextField
#pragma mark - init
- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __setupInitViews];
        [self __setupLayout];
        [self racKVO];//监听一些属性
        self.styleTextFieldType = OTSStyleTextFieldTypeDefault;
    }
    return self;
}
- (instancetype)initWithType:(OTSStyleTextFieldType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self __setupInitViews];
        [self __setupLayout];
        [self racKVO];
        self.styleTextFieldType = type;
    }
    return self;
}


#pragma mark - get & set

-(UIView *)leftContainerView{
    if(!_leftContainerView){
        _leftContainerView = [UIView new];
        [self addSubview:_leftContainerView];
    }
    return _leftContainerView;
}

-(UIImageView *)rightImageView{
    if(!_rightImageView){
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeCenter;
        _rightImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] init];
        
        WEAK_SELF;
        [[rightTap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF;
            if([self->_styleTextFieldDelegate respondsToSelector:@selector(clickAtRightImageView:)]){
                [self->_styleTextFieldDelegate clickAtRightImageView:self->_rightImageView];
            }
        }];
        
        [_rightImageView addGestureRecognizer:rightTap];

        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}

-(UIImageView *)lineImageView{
    if(!_lineImageView){
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = [UIColor colorWithRGB:0xe5e5e5];
        [self addSubview:_lineImageView];
    }
    return _lineImageView;
}

-(UIImageView *)topLineImageView{
    if(!_topLineImageView){
        _topLineImageView = [UIImageView new];
        _topLineImageView.backgroundColor = [UIColor colorWithRGB:0xe5e5e5];
        [self addSubview:_topLineImageView];
    }
    return _topLineImageView;
}

-(UIImageView *)leftImageView{
    if(!_leftImageView){
        _leftImageView = [UIImageView new];
        //[self.leftContainerView addSubview:_leftImageView];
    }
    return _leftImageView;
}
-(UILabel *)leftTextLabel{
    if(!_leftTextLabel){
        _leftTextLabel = [UILabel new];
        _leftTextLabel.textColor = [UIColor blackColor];
        _leftTextLabel.font = [UIFont systemFontOfSize:14.0];
        //[self.leftContainerView addSubview:_leftTextLabel];
    }
    return _leftTextLabel;
}

-(void)setStyleTextFieldType:(OTSStyleTextFieldType)styleTextFieldType{
    _styleTextFieldType = styleTextFieldType;
    
    [_leftContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_rightImageView removeFromSuperview];
    _rightImageView = nil;
    
    switch (_styleTextFieldType) {
        case OTSStyleTextFieldEnumLeftImage:
            [self setupInitLeftImage];
            break;
        case OTSStyleTextFieldEnumLeftText:
            [self setupInitLeftText];
            self.leftTextLabel.font = self.font;
            break;
        case OTSStyleTextFieldEnumLeftImageAndText:
            [self setupInitLeftImageAndText];
            break;
        case OTSStyleTextFieldEnumLeftImageAndTextAndRight:
            [self setupInitLeftImageAndText];
            [self setupInitRightImage];
            break;
        case OTSStyleTextFieldEnumLeftTextAndRight:
            [self setupInitLeftText];
            [self setupInitRightImage];
            self.leftTextLabel.font = self.font;
            break;
        case OTSStyleTextFieldEnumRightImage:
            self.leftView = [self layoutView:self.leftView inFrame:CGRectMake(0, 0, 7, 0) isLeft:YES];
            [self setupInitRightImage];
            return;
        case OTSStyleTextFieldEnumLeftImageAndTextAndArrow:
            [self setupInitLeftText];
            [self setupInitRightImage];
            self.leftTextLabel.font = self.font;
            break;
        default:{
           self.leftView = [self layoutView:self.leftView inFrame:CGRectMake(0, 0, 7, 0) isLeft:YES];
        }
            return;
    }
}

#pragma mark - Initialize the layout

-(void)__setupInitViews{
    self.textColor = [UIColor colorWithRGB:0x333333];
    self.font = [UIFont systemFontOfSize:14.0f];
    self.backgroundColor = [UIColor whiteColor];
    self.clearButtonMode = UITextFieldViewModeAlways;
}
-(void)__setupLayout{
    
    [self.lineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.lineImageView.borderWidth));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.topLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.lineImageView.borderWidth));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
    }];
}
-(void)setupInitLeftImage{
    [self autoAddTargetView:self.leftImageView];
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@22);
        make.centerY.equalTo(self.leftContainerView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [_leftContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_left);
        make.right.equalTo(self.leftImageView.mas_right);
        make.top.bottom.equalTo(self);
    }];
}

- (void)autoAddTargetView:(UIView *)targetView{
    BOOL have = NO;
    for (UIView *subView in self.leftContainerView.subviews) {
        if ([subView isKindOfClass:[self.leftTextLabel class]]) {
            have = YES;
            break;
        }
    }
    if (have == NO) {
        [self.leftContainerView addSubview:targetView];
    }
}

-(void)setupInitLeftText{
    [self autoAddTargetView:self.leftTextLabel];
    [self.leftTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [_leftContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTextLabel.mas_left);
        make.right.equalTo(self.leftTextLabel.mas_right);
        make.top.bottom.equalTo(self);
    }];
}

-(void)setupInitLeftImageAndText{
    
    [self setupInitLeftImage];
    
    [self.leftTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.leftContainerView);
        make.left.equalTo(self.leftImageView.mas_right).offset(9);
    }];
    
    [self.leftContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_left);
        make.right.equalTo(_leftTextLabel.mas_right);
        make.top.bottom.equalTo(self);
    }];
}

-(void)setupInitRightImage{
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
    }];
    [self bringSubviewToFront:_rightImageView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(_leftImageView||_leftTextLabel)
        self.leftView = [self layoutView:self.leftView inFrame:_leftContainerView.frame isLeft:YES];
    
    if(_rightImageView)
        self.rightView = [self layoutView:self.rightView inFrame:_rightImageView.frame isLeft:NO];
    self.rightView.backgroundColor = [UIColor redColor];
    
    
    [[OTSNotificationCenter sharedInstance] offsetConvertRectWithControl:self];
    [self bringSubviewToFront:_rightImageView];
}
//重新计算输入框左右显示文本的宽度
-(UIView *)layoutView:(UIView *)view inFrame:(CGRect)frame isLeft:(BOOL)isLeft{
    if(!view)
        view = [UIView new];
    
    CGFloat width;
    if(isLeft){
        if(_leftWidth){
            width = _leftWidth;
        }else{
            width = frame.size.width + frame.origin.x + 8;
        }
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
        width =  self.width - frame.origin.x;
    }
    view.width = width;
    return view;
}

// 调整自带清空按钮的位置
- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    if(self.rightView){
        CGFloat x = -self.rightView.width+rect.size.width/2 - 8;
        return CGRectOffset(rect, x, 0);
    }
    return CGRectOffset(rect, -8, 0);
}

#pragma mark - KVO
-(void)racKVO{
    WEAK_SELF;
    [RACObserve(self, font) subscribeNext:^(id x) {
        STRONG_SELF;
        if(self->_leftTextLabel)
            self->_leftTextLabel.font = x;
    }];
    
}
@end

@implementation OTSStyleTextField (EnlargeArea)

- (void)setEnlargeRightEdge:(CGFloat)edge{
    objc_setAssociatedObject(self, @"OTSEnlargeRightEdgeKey", [NSNumber numberWithFloat:edge], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSNumber* rightEdge = objc_getAssociatedObject(self, @"OTSEnlargeRightEdgeKey");
    CGRect rect = self.bounds;
    if (rightEdge) {
        rect = CGRectMake(self.bounds.origin.x,
                          self.bounds.origin.y,
                          self.bounds.size.width + rightEdge.floatValue,self.bounds.size.height);
    }
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end

