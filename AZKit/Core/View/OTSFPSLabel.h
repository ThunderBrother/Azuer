//
//  OTSFPSLabel.h
//  OneStore
//
//  Created by Eason Qian on 15/11/22.
//  Copyright © 2015年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSFuncDefine.h"

/**
 Show Screen FPS...
 
 The maximum fps in OSX/iOS Simulator is 60.00.
 The maximum fps on iPhone is 59.97.
 The maxmium fps on iPad is 60.0.
 */

@interface OTSFPSLabel : UILabel

AS_SINGLETON(OTSFPSLabel);

- (void)showBuoyCartWithView:(UIView *)aView;

@end
