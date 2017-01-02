//
//  OTSNSTimerSingleton.m
//  WasteProductsMerchant
//
//  Created by Funwear on 16/3/11.
//  Copyright © 2016年 huanglei. All rights reserved.
//计时器单例

#import "OTSNSTimerSingleton.h"
static OTSNSTimerSingleton * sTimer = nil;
@interface OTSNSTimerSingleton ()
/**
*  计时器
*/
@property (nonatomic, strong)  NSTimer *timer;
@property (nonatomic,assign) int index;
@end

@implementation OTSNSTimerSingleton

+(OTSNSTimerSingleton *)sTimer{
    static dispatch_once_t dispatch;
     dispatch_once(&dispatch, ^{
         sTimer = [OTSNSTimerSingleton new];
     });
    return sTimer;
}

/**
 *  开启
 */
-(void)timerOpen:(int)second{
    [self timerClose];
    _index  = second;
    [self timerOpen];
}
-(BOOL)isNil{
    return (BOOL)_timer;
}

-(void)timerOpen{
    if(_index == 0){
        [self timerClose];
        return;
    }
    // 安装timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(handleTimer:)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  关闭
 */
-(void)timerClose{
    [_timer invalidate];
    _timer = nil;
    _index = 0;
}

-(void)handleTimer: (NSTimer *)timer{
    _index--;
    
    if(self.timerSingletonDelegate){
        if ([self.timerSingletonDelegate respondsToSelector:@selector(backSecond:)]) {
            [self.timerSingletonDelegate backSecond:_index];
        }
    }
    
    [self timerOpen];
}
@end
