//
//  OTSMultiLineContentView.h
//  OTSKit
//
//  Created by Jerry on 2017/1/11.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSFlexibleContentView.h"

@class OTSTextAttribute;

@interface OTSMultiLineContentView : OTSFlexibleContentView

//Protected Funcs
- (void)__layoutCenterLinesWithYOffset:(CGFloat)yOffset
                              leftEdge:(CGFloat)leftEdge
                             rightEdge:(CGFloat)rightEdge;

- (void)__layoutLabel:(UILabel*)label
                withX:(CGFloat)x
                    Y:(CGFloat*)y
                width:(CGFloat)width
            attribute:(OTSTextAttribute*)textAttribute;

@end
