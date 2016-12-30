//
//  OTSBadgedBarButtonItem.m
//  OTSKit
//
//  Created by Jerry on 2016/12/21.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSBadgedBarButtonItem.h"
#import "UIView+BadgedNumber.h"

@implementation OTSBadgedBarButtonItem

- (instancetype)init {
    if (self = [self init]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    if (self = [super init]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 25, 25);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:image forState:UIControlStateNormal];
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
        wrapperView.badgePosition = OTSBadgePositionOutside;
        [wrapperView addSubview:button];
        
        self.customView = wrapperView;
    }
    return self;
}

- (void)setBadgeString:(NSString *)badgeString {
    if (![_badgeString isEqualToString:badgeString]) {
        _badgeString = badgeString;
        self.customView.badgeString = badgeString;
        
    }
}

@end
