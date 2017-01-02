//
//  OTSViewPoper.h
//  OneStore
//
//  Created by huangjiming on 8/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface OTSViewPoper : NSObject

@property(nonatomic, strong) UIView *bgView;//背景，默认黑色，alpha为0.1
@property(nonatomic, strong) UIView *popView;

/**
 *  功能:显示pop view
 */
- (void)showPopView;

/**
 *  功能:隐藏pop view
 */
- (void)hidePopView;

@end
