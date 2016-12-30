//
//  NSString+Frame.h
//  OTSKit
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Frame)

- (CGSize)sizeWithFont:(UIFont *)font
         lineBreakMode:(NSLineBreakMode)lineBreakMode
        preferredWidth:(CGFloat)width;

@end
