//
//  NSMutableDictionary+safe.h
//  OneStore
//
//  Created by airspuer on 13-5-8.
//  Copyright (c) 2013年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary(safe)

- (void)safeSetObject:(nullable id)aObj forKey:(nullable id<NSCopying>)aKey;

- (void)safeAddEntriesFromDictionary:(nullable NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
