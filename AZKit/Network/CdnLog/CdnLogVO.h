//
//  CdnLogVO.h
//  OneStoreNetwork
//
//  Created by huangjiming on 5/3/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "OTSModel.h"

@interface CdnLogVO : OTSModel

@property(nonatomic, copy) NSString *time;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, copy) NSString *netType;
@property(nonatomic, copy) NSString *provinceId;
@property(nonatomic, copy) NSString *cityId;
@property(nonatomic, copy) NSString *deviceCode;
@property(nonatomic, copy) NSString *clientSystem;
@property(nonatomic, copy) NSString *clientSystemVersion;
@property(nonatomic, copy) NSString *appVersion;

@end
