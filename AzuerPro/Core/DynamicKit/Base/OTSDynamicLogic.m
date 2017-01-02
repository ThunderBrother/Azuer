//
//  OTSDynamicLogic.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicLogic.h"

@implementation OTSDynamicLogic

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self->_owner respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self->_owner respondsToSelector:aSelector]) {
        return self->_owner;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
