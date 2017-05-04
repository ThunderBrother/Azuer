//
//  OTSImageBrowserVC.h
//  OneStoreLight
//
//  Created by HUI on 16/9/28.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSImageBrowserVC : UIViewController

@property (nonatomic, strong) NSArray<NSString*> *scanImageArray;
@property (nonatomic, assign) NSInteger scrollIndex;

@end
