//
//  OTSErrorView.h
//  OneStoreLight
//
//  Created by wenjie on 16/11/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OTSErrorBlockType){
    kOTSErrorBlockRefreshType   = 1,
    kOTSErrorBlockActiveType    = 2,
    kOTSErrorBlockDeactiveType  = 3,
};

@interface OTSErrorView : UIView

@property (nonatomic,copy) void(^clickBlock)(OTSErrorBlockType blockType);

- (void)setTitle:(NSString *)title
       imageName:(NSString *)imageName
      clickTitle:(NSString *)clickTitle;

- (void)setTitle:(NSString *)title
       imageName:(NSString *)imageName
     activeTitle:(NSString *)activeTitle
   deActiveTitle:(NSString *)deActiveTitle
     footerTitle:(NSString *)footerTitle;

@end
