//
//  UIButton+OTSDynamicAdapter.m
//  OTSKit
//
//  Created by Jerry on 2017/1/4.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "UIButton+OTSDynamicAdapter.h"
#import "NSObject+Runtime.h"
#import "OTSViewModelItem.h"
#import "AZFuncDefine.h"

@implementation UIButton (OTSDynamicAdapter)

NSString *const OTSDynamicDelegateKey = @"ots_dynamic_delegate";
NSString *const OTSDynamicIndexPathKey = @"ots_dynamic_indexpath";

- (void)setDelegate:(id)delegate {
    [self objc_setAssociatedObject:OTSDynamicDelegateKey value:delegate policy:OBJC_ASSOCIATION_ASSIGN];
}

- (id)delegate {
    return [self objc_getAssociatedObject:OTSDynamicDelegateKey];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return;
    }
    
    [self objc_setAssociatedObject:OTSDynamicIndexPathKey value:indexPath policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    [self applyAttribute:item.buttonAttribute delegate:self.delegate];
    [self addTarget:self action:@selector(__ots_private_action_for_action:) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return CGSizeZero;
    }
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    return CGSizeMake(item.contentAttribute.preferredWidth, item.contentAttribute.preferredHeight);
}

- (void)__ots_private_action_for_action:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [[self delegate] didSelectItemAtIndexPath:[self objc_getAssociatedObject:OTSDynamicIndexPathKey]];
    }
}

@end
