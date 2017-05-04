//
//  OTSHomeSection.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTableViewSection.h"

@implementation OTSTableViewSection

+ (Class)collectionClassForKey:(NSString *)key {
    if ([key isEqualToString:@"rows"]) {
        return [OTSTableViewItem class];
    }
    return nil;
}

+ (nullable NSIndexPath*)indexPathForItem:(OTSTableViewItem*)item
                               inSections:(NSArray<OTSTableViewSection*>*)sections {
    
    int sectionIndex = -1;
    int rowIndex = -1;
    for (int i = 0; i < sections.count ; i++) {
        OTSTableViewSection *aSection = sections[i];
        for (int j = 0; j < aSection.rows.count; j++) {
            OTSTableViewItem *anItem = aSection.rows[j];
            if (anItem == item) {
                sectionIndex = i;
                rowIndex = j;
                break;
                break;
            }
            
        }
    }
    
    if (sectionIndex >= 0 && rowIndex >= 0) {
        return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    }
    return nil;
}

- (void)setHeader:(OTSTableViewItem *)header {
    if (_header != header) {
        _header = header;
        [_header setValue:@(OTSViewModelItemTypeHeader) forKey:@"itemType"];
    }
}

- (void)setFooter:(OTSTableViewItem *)footer {
    if (_footer != footer) {
        _footer = footer;
        [_footer setValue:@(OTSViewModelItemTypeFooter) forKey:@"itemType"];
    }
}

@end
