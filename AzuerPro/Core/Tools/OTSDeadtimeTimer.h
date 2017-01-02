//
//  OTSDeadtimeTimer.h
//  OneStoreMain
//
//  Created by Aimy on 14/12/24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  为nil则表示已经倒计时完成了
 *
 *  @param dateComponents 
 */
typedef void(^OTSDeadtimeTimerBlock)(NSDateComponents *dateComponents);

@interface OTSDeadtimeTimer : NSObject

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(OTSDeadtimeTimerBlock)aBlock;
- (void)stop;

@end
