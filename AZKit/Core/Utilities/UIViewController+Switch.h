//
//  UIViewController+Switch.h
//  OTSKit
//
//  Created by Jerry on 16/10/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Switch)

- (BOOL)switchToDestinationVCClass:(Class)aClass;
- (BOOL)switchToVCAtIndex:(NSInteger)index;

@end
