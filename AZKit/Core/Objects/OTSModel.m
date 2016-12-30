//
//  OTSModel.m
//  OneStoreFramework
//
//  Created by Aimy on 9/15/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSModel.h"

@implementation OTSModel

+ (instancetype)modelWithDict:(NSDictionary *)aDict {
    if (![aDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[self alloc] initWithDictionary:aDict error:nil];
}

#pragma mark - Override
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"nid": @"id"}];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end
