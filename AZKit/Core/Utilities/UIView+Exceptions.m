//
//  UIView+Exceptions.m
//  OneStoreLight
//
//  Created by wenjie on 16/11/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//
#import <AZKit/AZKit.h>
#import "UIView+Exceptions.h"
#import <objc/runtime.h>
#import "OTSEmptyView.h"
#import "OTSComplexEmptyView.h"

#define OTSExceptionsDefaultOffset 80.0

@implementation UIView (Exceptions)


- (instancetype)showEmptyViewWithTitle:(NSString *)title
                                 image:(NSString *)imageName{
    return  [self showEmptyViewWithTitle:title
                                subTitle:nil
                                   image:imageName
                              clickBlock:nil];
}

- (instancetype)showEmptyViewWithTitle:(NSString *)title
                              subTitle:(NSString *)subTitle
                                 image:(NSString*)imageName
                            clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock{
    [self removeEmptyView];
    CGRect emptyViewFrame = [self changeScrollEnabled:NO];
    OTSEmptyView *emptyView = [[OTSEmptyView alloc]initWithFrame:emptyViewFrame];
    [emptyView setTitle:title imageName:imageName subtitle:subTitle clickBlock:clickBlock offsetY:self.height <= 320 ? 0.0 : -OTSExceptionsDefaultOffset];
    objc_setAssociatedObject(self, @"ots_empty_view", emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:emptyView];
    return self;
}

- (instancetype)showComplexEmptyViewWithTitle:(NSString*)title
                                     subtitle:(NSString *)subtitle
                                        image:(NSString*)imageName
                                  activeTitle:(NSString *)activeTitle
                                deActiveTitle:(NSString *)deActiveTitle
                                  footerTitle:(NSString *)footerTitle
                                   clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock{
    
    [self removeComplexEmptyView];
    CGRect complexEmptyViewFrame = [self changeScrollEnabled:NO];
    OTSComplexEmptyView *complexEmptyView = [[OTSComplexEmptyView alloc]initWithFrame:complexEmptyViewFrame];
    [complexEmptyView setTitle:title subtitle:subtitle imageName:imageName activeTitle:activeTitle deActiveTitle:deActiveTitle footerTitle:footerTitle clickBlock:clickBlock offsetY:-OTSExceptionsDefaultOffset];
    objc_setAssociatedObject(self, @"ots_complex_empty_view", complexEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:complexEmptyView];
    return self;
}
- (CGRect)changeScrollEnabled:(BOOL)enabel{
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = enabel;
        CGFloat top = scrollView.contentInset.top;
        return CGRectMake(0, 0, self.width, self.height - top);
    } else {
        return CGRectMake(0, 64, self.width, self.height - 64);
    }
}
- (void)removeEmptyView{
    OTSEmptyView *emptyView = objc_getAssociatedObject(self, @"ots_empty_view");
    [emptyView removeFromSuperview];
}
- (void)removeComplexEmptyView{
    OTSComplexEmptyView *complexEmptyView = objc_getAssociatedObject(self, @"ots_complex_empty_view");
    [complexEmptyView removeFromSuperview];
}

- (void)setEmptyViewSubTitleColor:(UIColor *)color{
    OTSEmptyView *emptyView = objc_getAssociatedObject(self, @"ots_empty_view");
    [emptyView setSubTitleColor:color];
}

- (void)hideEmptyView{
    [self changeScrollEnabled:YES];
    [self removeEmptyView];
}
- (void)hideComplexEmptyView{
    [self changeScrollEnabled:YES];
    [self removeComplexEmptyView];
}

- (void)hideAllEmptyView{
    [self changeScrollEnabled:YES];
    [self removeEmptyView];
    [self removeComplexEmptyView];
}



@end
