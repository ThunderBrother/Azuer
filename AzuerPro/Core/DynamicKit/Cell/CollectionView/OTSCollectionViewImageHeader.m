//
//  OTSCollectionViewImageHeader.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCollectionViewImageHeader.h"
#import "OTSCollectionViewItem.h"

@implementation OTSCollectionViewImageHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    if (![aData isKindOfClass:[OTSCollectionViewItem class]]) {
        return;
    }
    
    OTSCollectionViewItem *item = aData;
    [self.imageView applyAttribute:item.imageAttribute];
}

#pragma mark - Getter & Setter
- (OTSPlaceHolderImageView*)imageView {
    if (!_imageView) {
        _imageView = [[OTSPlaceHolderImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageView;
}

@end
