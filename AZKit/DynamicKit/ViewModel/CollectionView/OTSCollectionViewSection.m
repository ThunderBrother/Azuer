//
//  OTSHomeSection.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCollectionViewSection.h"

@implementation OTSCollectionViewSection

+ (Class)collectionClassForKey:(NSString *)key {
    if ([key isEqualToString:@"items"]) {
        return [OTSCollectionViewItem class];
    }
    return nil;
}

- (NSUInteger)itemsCount {
    if (self.closed) {
        return .0;
    }
    
    if (self.overlapped) {
        return 1;
    }
    return self.items.count;
}

- (void)setHeader:(OTSCollectionViewItem *)header {
    if (_header != header) {
        _header = header;
        [_header setValue:@(OTSViewModelItemTypeHeader) forKey:@"itemType"];
    }
}

- (void)setFooter:(OTSCollectionViewItem *)footer {
    if (_footer != footer) {
        _footer = footer;
        [_footer setValue:@(OTSViewModelItemTypeFooter) forKey:@"itemType"];
    }
}

@end
