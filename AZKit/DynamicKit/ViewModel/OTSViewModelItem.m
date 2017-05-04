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

- (OTSImageAttribute*)accessoryImageAttibute {
    if (self.appAction & (OTSViewActionToggle | OTSViewActionGroupToggle | OTSViewActionAllToggle)) {
        return OTSImageMake(self.selected ? @"radio_checkbox_yes" : @"radio_checkbox_no");
    }
    return _accessoryImageAttibute;
}

/*
 
 content {background-color: yellow}
 h1 {background-color: #00ff00}
 h2 {background-color: transparent}
 p {background-color: rgb(250,0,255)}
 
 */

- (void)applyCSS:(NSString*)cssString {
    
}

@end
