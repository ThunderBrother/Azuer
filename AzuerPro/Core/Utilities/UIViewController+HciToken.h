//
//  UIViewController+HciToken.h
//  OneStoreLight
//
//  Created by Jerry on 16/10/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HciToken)

@property (strong, nonatomic, readonly) NSMutableDictionary *hciInfo;

- (void)observeHciForStartTimeInterval;
- (void)observeHciForEditCountInTextFields:(NSArray<UITextField*>*)textFields;
- (void)observeHciForTouchInView:(UIView*)aView;

- (NSString*)flushHciToken;


@end
