//
//  OTSCameraMaskView.h
//  OTSKit
//
//  Created by Jerry on 2016/12/20.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSCameraMaskView : UIView

@property (assign, nonatomic) CGFloat decorationLineLength;//default is 16.0
@property (assign, nonatomic) CGFloat decorationLineWidth;//default is 4.0

@property (assign, nonatomic) CGRect clipRect;

- (void)startAnimating;
- (void)stopAnimating;

@end
