//
//  CdnLog.h
//  OneStoreNetwork
//
//  Created by huangjiming on 5/3/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "OTSManagedObject.h"

@interface CdnLog : OTSManagedObject

@property(nonatomic, copy) NSString *cdnLog;
@property(nonatomic, copy) NSString *netType;
@property(nonatomic, copy) NSDate *saveTime;

@end
