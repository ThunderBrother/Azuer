//
//  OTSBadgedBarButtonItem.h
//  OTSKit
//
//  Created by Jerry on 2016/12/21.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSBadgedBarButtonItem : UIBarButtonItem

@property (nonatomic, copy) NSString *badgeString;

- (instancetype)initWithImage:(nullable UIImage *)image
                       target:(nullable id)target
                       action:(nullable SEL)action NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
