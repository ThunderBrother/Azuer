//
//  OTSAbstractContentView.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSAbstractContentView.h"
#import "OTSViewModelItem.h"

@interface OTSAbstractContentView()

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation OTSAbstractContentView

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return;
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    if (item.itemType == OTSViewModelItemTypeCell) {
        if (_tapGesture) {
            [self removeGestureRecognizer:_tapGesture];
        }
    } else {
        [self addGestureRecognizer:self.tapGesture];
    }
    
    [self applyAttribute:item.contentAttribute delegate:self.delegate];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

- (void)__ots_private_actionHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:self.indexPath];
    }
}

#pragma mark - Getter & Setter
- (UITapGestureRecognizer*)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        [_tapGesture addTarget:self action:@selector(__ots_private_actionHandler:)];
    }
    return _tapGesture;
}
@end
