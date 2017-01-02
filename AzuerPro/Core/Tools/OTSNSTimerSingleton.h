//
//  OTSNSTimerSingleton.h
//  WasteProductsMerchant
//
//  Created by Funwear on 16/3/11.
//  Copyright © 2016年 huanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OTSNSTimerSingletonDelegate <NSObject>
- (void)backSecond:(int)index;
@end


@interface OTSNSTimerSingleton : NSObject

@property (nonatomic, assign) id<OTSNSTimerSingletonDelegate> timerSingletonDelegate;

+(OTSNSTimerSingleton *)sTimer;


//计时器是否存在
-(BOOL)isNil;
/**
 *  开启
 */
-(void)timerOpen:(int)second;
/**
 *  关闭
 */
-(void)timerClose;

@end
