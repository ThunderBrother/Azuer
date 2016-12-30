//
//  UIButton+badgedNumber.h
//  OneStoreLight
//
//  Created by wenjie on 16/9/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OTSBadgePosition) {
    OTSBadgePositionInside,
    OTSBadgePositionOutside
};

@interface UIView (BadgedNumber)

@property (nonatomic, copy) NSString *badgeString;
@property (nonatomic, assign) OTSBadgePosition badgePosition;

@end
