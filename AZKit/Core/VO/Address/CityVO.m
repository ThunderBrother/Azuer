//
//  CityVO.m
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CityVO.h"

@implementation CityVO

+ (Class)classForCollectionProperty:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"countyVoList"]) {
        return [CountyVO class];
    }
    return nil;
}

@end
