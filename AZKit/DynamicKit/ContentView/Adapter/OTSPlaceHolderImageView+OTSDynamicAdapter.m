//
//  OTSPlaceHolderImageView+OTSDynamicAdapter.m
//  OTSKit
//
//  Created by Jerry on 2017/1/4.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSPlaceHolderImageView+OTSDynamicAdapter.h"
#import "NSObject+Runtime.h"
#import "OTSViewModelItem.h"

@implementation OTSPlaceHolderImageView (OTSDynamicAdapter)

static NSString *OTSDynamicDelegateKey = @"ots_dynamic_delegate";

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
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    [self applyAttribute:item.imageAttribute delegate:self.delegate];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return CGSizeZero;
    }
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    return CGSizeMake(item.contentAttribute.preferredWidth, item.contentAttribute.preferredHeight);
}

@end
