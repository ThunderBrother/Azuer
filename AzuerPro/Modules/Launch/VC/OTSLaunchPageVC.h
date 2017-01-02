//
//  OTSLaunchPageVC.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSIntentModel;

@interface OTSLaunchPageVC : UIViewController

@property (copy, nonatomic) NSArray *items;

@property (copy, nonatomic) void (^imageClickedBlock)(OTSIntentModel *intentModel) ;
@property (copy, nonatomic) void (^dismissBlock)(void) ;

@end
