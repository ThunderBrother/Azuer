//
//  OTSCdnLog.h
//  OneStoreNetwork
//
//  Created by huangjiming on 5/3/16.
//  Copyright © 2016 OneStoreNetwork. All rights reserved.
//

#import "AZFuncDefine.h"

@interface OTSCdnLog : NSObject

AS_SINGLETON(OTSCdnLog)

/**
 *  功能:保存cdn日志
 */
- (void)saveCdnLog:(NSString *)cdnLog;

/**
 *  功能:发送cdn日志
 */
- (void)sendLog;

@end
