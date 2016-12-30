//
//  CityVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CountyVO.h"

@interface CityVO : OTSModel

@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, strong) NSNumber *nid;//市/区县Id
@property(nonatomic, strong) NSNumber *provinceId;
@property(nonatomic, strong) NSArray<CountyVO*> *countyVoList;

@end
