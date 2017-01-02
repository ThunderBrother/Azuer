//
//  OTSDeadtimeTimer.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSDeadtimeTimer.h"
#import <OTSKit/OTSKit.h>
#import "MSWeakTimer.h"

@interface OTSDeadtimeTimer ()

@property (nonatomic, copy) OTSDeadtimeTimerBlock block;

@property (nonatomic, strong) NSTimer *countdownTimer;

@property (nonatomic, copy) NSDate *deadTime;

@end

@implementation OTSDeadtimeTimer

- (void)runCountdownView
{
    NSDate *now = [OTSGlobalValue sharedInstance].serverTime;
    if ([self.deadTime compare:now] == NSOrderedDescending) {
        NSTimeInterval timeInterval = [self.deadTime timeIntervalSinceDate:now];
        NSDate *endingDate = now;
        NSDate *startingDate = [endingDate dateByAddingTimeInterval:-timeInterval];
        
        NSCalendarUnit components = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:components fromDate:startingDate toDate:endingDate options:(NSCalendarOptions)0];
        if (self.block) {
            self.block(dateComponents);
        }
    } else {
        if (self.block) {
            self.block(nil);
        }
        _block = nil;
        [self stop];
    }
}

- (void)runWithDeadtime:(NSDate *)deadtime andBLock:(OTSDeadtimeTimerBlock)aBlock
{
    self.block = aBlock;
    
    self.deadTime = deadtime;
    
    [self stop];
    
    WEAK_SELF;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:weakSelf selector:@selector(runCountdownView) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    [self.countdownTimer fire];
}

- (void)stop
{
    [self.countdownTimer invalidate];
}

- (void)dealloc
{
    OTSLogFuncW;
}

@end
