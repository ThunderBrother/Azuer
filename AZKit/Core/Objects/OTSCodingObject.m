//
//  OTSCodingObject.m
//  OTSKit
//
//  Created by Jerry on 2016/11/22.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCodingObject.h"
#import "NSObject+Runtime.h"

@implementation OTSCodingObject

#pragma mark - Equal
- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    __block BOOL result = YES;
    [self.properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSObject *mValue = [self valueForKey:key];
        NSObject *nValue = [object valueForKey:key];
        
        if ((!mValue && nValue) || (mValue && !nValue)) {
            result = NO;
        } else if(!mValue && !nValue) {
            result = YES;
        } else {
            result = [mValue isEqual:nValue];
        }
        
        if (!result) {
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSUInteger)hash {
    __block NSUInteger result = 0;
    [self.properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSObject *mValue = [self valueForKey:key];
        NSUInteger aHash = [mValue hash];
        result = result * 37 + aHash + [key hash];
    }];
    return result;
}

#pragma mark - Debug
- (NSString*)debugDescription {
    NSMutableString *string = [NSMutableString stringWithFormat:@"\n{%@} =======> \n", [self class]];
    [self.properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        id valueObj = [self valueForKey:key];
        [string appendFormat:@"%@: %@ \n", key, [valueObj debugDescription] ?: @"NULL"];
    }];
    
    [string appendFormat:@"<======= {%@} \n", [self class]];
    return [string copy];
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self.properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            NSObject *value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self.properties enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        id valueObj = [self valueForKey:key];
        [aCoder encodeObject:valueObj forKey:key];
    }];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //do nothing
}

@end
