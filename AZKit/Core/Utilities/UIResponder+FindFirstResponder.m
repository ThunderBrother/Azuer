//
//  UIResponder+FindFirstResponder.m
//  OTSKit
//
//  Created by Jerry on 2017/1/12.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "UIResponder+FindFirstResponder.h"

@implementation UIResponder (FindFirstResponder)

static __weak id _currentFirstResponder;

- (id)currentFirstResponder {
    _currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(ots_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return _currentFirstResponder;
}

- (void)ots_findFirstResponder:(id)sender {
    _currentFirstResponder = self;
}

@end
