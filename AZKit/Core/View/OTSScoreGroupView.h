//
//  OTSScoreGroupView.h
//  OTSKit
//
//  Created by HUI on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

// file event UIControlEventValueChanged

@interface OTSScoreGroupView : UIControl

@property (copy, nonatomic) NSString *highlightedImageName;//default is "icon_bigstart"
@property (copy, nonatomic) NSString *imageName;//default is "icon_bigstart_gray"

@property (assign, nonatomic) NSUInteger maxScore;//default is 5
@property (assign, nonatomic) NSUInteger score;//default is 5

@property (assign, nonatomic) CGFloat innerMargin;//default is 2.0

@end
