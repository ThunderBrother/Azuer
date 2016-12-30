//
//  NSObject+Safe.m
//  OTSKit
//
//  Created by Jerry on 16/9/5.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject (Safe)

- (NSNumber*)numberValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *myNumber = [f numberFromString:(NSString *)self];
        return myNumber;
    }
    
    return nil;
}

@end
