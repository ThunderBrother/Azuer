//
//  OTSNotificationCenter.h
//  OneStoreLight
//
//  Created by leo on 16/10/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OTSKit/OTSKit.h>

@interface OTSNotificationCenter : NSObject

AS_SINGLETON(OTSNotificationCenter)
- (void)addKeyboardNotification;
- (void)deallocKeyboardNotification;

- (void)offsetConvertRectWithControl:(UIControl *)control;//移动
@end
