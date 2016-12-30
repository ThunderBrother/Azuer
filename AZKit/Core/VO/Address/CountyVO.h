//
//  CountyVO.h
//  ProtocolDemo
//
//  Created by vsc on 11-2-10.
//  Copyright 2011 vsc. All rights reserved.
//

#import "OTSModel.h"

@interface CountyVO : OTSModel

@property(nonatomic, strong) NSString *countyName;
@property(nonatomic, strong) NSNumber *nid;
@property(nonatomic, strong) NSString *postcode;
@property(nonatomic, strong) NSNumber *cityId;//所属城市的id
@property(nonatomic, strong) NSArray *communityVoList;

@end
