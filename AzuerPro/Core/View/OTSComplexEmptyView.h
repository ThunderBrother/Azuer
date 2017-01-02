//
//  OTSComplexEmptyView.h
//  OneStoreLight
//
//  Created by wenjie on 16/12/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSEmptyView.h"

@interface OTSComplexEmptyView : OTSEmptyView

- (void)setTitle:(NSString *)title
        subtitle:(NSString *)subtitle
       imageName:(NSString *)imageName
     activeTitle:(NSString *)activeTitle
   deActiveTitle:(NSString *)deActiveTitle
     footerTitle:(NSString *)footerTitle
      clickBlock:(void(^)(OTSExceptionBlockType blockType))clickBlock
         offsetY:(CGFloat)offsetY;

@end
