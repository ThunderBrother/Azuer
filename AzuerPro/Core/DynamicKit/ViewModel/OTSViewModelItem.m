//
//  OTSViewModelItem.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSViewModelItem.h"

@implementation OTSViewModelItem

- (instancetype)initWithIdentifier:(NSString*)identifier {
    if (self = [super init]) {
        _cellIdentifier = identifier;
    }
    return self;
}

@end
