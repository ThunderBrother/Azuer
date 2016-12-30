//
//  NSMutableDictionary+safe.m
//  OneStore
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import "NSMutableDictionary+safe.h"
#import "NSObject+Runtime.h"

@implementation NSMutableDictionary(safe)

+ (void)load {
    [self overrideMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(safeSetObject:forKeyedSubscript:)];
}

- (void)safeSetObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key) {
        return ;
    }

    if (!obj) {
        [self removeObjectForKey:key];
    }
    else {
        [self setObject:obj forKey:key];
    }
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && aKey) {
        [self setObject:aObj forKey:aKey];
    } else {
        return;
    }
}

- (void)safeAddEntriesFromDictionary:(NSDictionary*)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [self addEntriesFromDictionary:dict];
    }
}

@end
