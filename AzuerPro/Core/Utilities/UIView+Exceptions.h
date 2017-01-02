//
//  UIView+Exceptions.h
//  OneStoreLight
//
//  Created by wenjie on 16/11/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSEmptyView.h"
#import "OTSComplexEmptyView.h"

@interface UIView (Exceptions)


/** empty view  */
- (instancetype)showEmptyViewWithTitle:(NSString *)title
                         image:(NSString*)imageName;

/** empty view with subtitle or action */
- (instancetype)showEmptyViewWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
                         image:(NSString*)imageName
                    clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock;


/** complex empty view  */
- (instancetype)showComplexEmptyViewWithTitle:(NSString*)title
                                     subtitle:(NSString *)subtitle
                                        image:(NSString*)imageName
                                  activeTitle:(NSString *)activeTitle
                                deActiveTitle:(NSString *)deActiveTitle
                                  footerTitle:(NSString *)footerTitle
                                   clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock;

/** hide empty view */
- (void)hideEmptyView;

/** hide complex empty view */
- (void)hideComplexEmptyView;

/** hide all empty views */
- (void)hideAllEmptyView;

@end
