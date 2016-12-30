//
//  ProvinceVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-1-27.
//  Copyright 2011 vsc. All rights reserved.
//

#import "ProvinceVO.h"

@implementation ProvinceVO

+ (Class)classForCollectionProperty:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"cityVoList"]) {
        return [CityVO class];
    }
    return nil;
}

@end
