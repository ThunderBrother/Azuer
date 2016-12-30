//
//  ProvinceVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-1-27.
//  Copyright 2011 vsc. All rights reserved.
//

#import "CityVO.h"

@interface ProvinceVO : OTSModel

@property(nonatomic, strong) NSNumber *nid;
@property(nonatomic, strong) NSString *provinceName;
@property(nonatomic, strong) NSArray<CityVO*> *cityVoList;

@end
