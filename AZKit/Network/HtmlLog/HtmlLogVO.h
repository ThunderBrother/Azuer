//
//  HtmlLogVO.h
//  OneStoreNetwork
//
//  Created by huangjiming on 5/11/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "OTSModel.h"

@interface HtmlLogVO : OTSModel

@property(nonatomic, copy) NSString *userip;//如果是非WIFI下产生的日志，必须添加该字段。如果是WIFI状态下产生的日志，服务端会自己到request里面捞IP
@property(nonatomic, copy) NSNumber *requesttime;//App端发出业务请求的时间，可以理解为被DNS劫持的请求App端发出的时间， 并非日志上报时间
@property(nonatomic, copy) NSString *nettype;//用于表示日志产生的网路类型，分为wifi，3g,4g,other
@property(nonatomic, copy) NSString *xpath;//返回H5的内容
@property(nonatomic, copy) NSString *devicecode;//设备号
@property(nonatomic, copy) NSString *cmsurl;

@end
