//
//  OTSAction.h
//  OTSKit
//
//  Created by Jerry on 16/9/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSIntent.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSAction : OTSIntent

#pragma warning - Source cannot hold OTSAction
- (instancetype)initWithSource:(nullable UIViewController*)source;

@end

NS_ASSUME_NONNULL_END
