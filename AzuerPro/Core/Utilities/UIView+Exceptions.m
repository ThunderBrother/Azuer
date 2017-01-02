//
//  UIView+Exceptions.m
//  OneStoreLight
//
//  Created by wenjie on 16/11/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//
#import <OTSKit/OTSKit.h>
#import "UIView+Exceptions.h"
#import <objc/runtime.h>

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
    [self setScrollEnabled:NO];
    OTSEmptyView *emptyView = [[OTSEmptyView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
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
    [self setScrollEnabled:NO];
    OTSComplexEmptyView *complexEmptyView = [[OTSComplexEmptyView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [complexEmptyView setTitle:title subtitle:subtitle imageName:imageName activeTitle:activeTitle deActiveTitle:deActiveTitle footerTitle:footerTitle clickBlock:clickBlock offsetY:-OTSExceptionsDefaultOffset];
    objc_setAssociatedObject(self, @"ots_complex_empty_view", complexEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:complexEmptyView];
    return self;
}
- (void)setScrollEnabled:(BOOL)enabel{
    if ([self isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView*)self).scrollEnabled = enabel;
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

- (void)hideEmptyView{
    [self setScrollEnabled:YES];
    [self removeEmptyView];
}
- (void)hideComplexEmptyView{
    [self setScrollEnabled:YES];
    [self removeComplexEmptyView];
}

- (void)hideAllEmptyView{
    [self setScrollEnabled:YES];
    [self removeEmptyView];
    [self removeComplexEmptyView];
}



@end
