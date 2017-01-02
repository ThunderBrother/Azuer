//
//  OTSHomeItem.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTableViewItem.h"

@implementation OTSTableViewItem

- (OTSImageAttribute*)subImageAttribute {
    if (self.appAction & (OTSTableViewActionToggle | OTSTableViewActionGroupToggle | OTSTableViewActionAllToggle)) {
        return OTSImageMake(self.selected ? @"radio_checkbox_yes" : @"radio_checkbox_no");
    }
    return _subImageAttribute;
}

@end

@implementation OTSTableViewItem (Factory)

+ (instancetype)simpleItemWithLeftTitle:(NSString*)leftTitle
                             rightTitle:(NSString*)rightTitle {
    OTSTableViewItem *anItem = [[OTSTableViewItem alloc] initWithIdentifier:@"OTSFlexibleContentView"];
    anItem.contentAttribute = OTSViewAttributeMakeF(0, 44.0);
    anItem.accessoryImageAttibute = OTSImageMake(@"cell_right_arrow");
    anItem.titleAttribute = OTSTitleMake(leftTitle);
    
    if (rightTitle) {
        anItem.thirdTitleAttribute = OTSTitleMake(rightTitle);
    }
    
    return anItem;
}

+ (instancetype)simpleItemWithImageNamed:(NSString*)imageName
                                  title:(NSString*)title {
    OTSTableViewItem *anItem = [[OTSTableViewItem alloc] initWithIdentifier:@"OTSFlexibleContentView"];
    anItem.contentAttribute = OTSViewAttributeMakeF(0, 44.0);
    anItem.imageAttribute = OTSImageMake(imageName);
    anItem.accessoryImageAttibute = OTSImageMake(@"cell_right_arrow");
    anItem.titleAttribute = OTSTitleMake(title);
    
    return anItem;
}

+ (instancetype)simpleButtonItemWithTitle:(NSString*)title {
    OTSTableViewItem *anItem = [[OTSTableViewItem alloc] initWithIdentifier:@"OTSSimpleButtonTableViewCell"];
    anItem.contentAttribute = OTSViewAttributeMakeF(0, 44.0);
    anItem.titleAttribute = OTSTitleMake(title);
    return anItem;
}

+ (instancetype)simpleHeaderItemWithTitle:(NSString*)title {
    OTSTableViewItem *anItem = [[OTSTableViewItem alloc] initWithIdentifier:@"OTSFlexibleContentView"];
    anItem.contentAttribute = OTSViewAttributeMakeF(0, 35.0);
    anItem.titleAttribute = OTSTitleMakeF(title, 14.0, 0x757575);
    anItem.titleAttribute.backgroundColor = OTSBackgroundColorV;
    anItem.contentAttribute.backgroundColor = OTSBackgroundColorV;
    return anItem;
}

@end
