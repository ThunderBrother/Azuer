//
//  OTSPropertyListView.h
//  OTSKit
//
//  Created by Jerry on 16/9/23.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSPropertyListView : UIView

@property (assign, nonatomic) CGFloat preferredTitleWidth;//default is 100

@property (strong, nonatomic) UIColor *titleColor;//default is 0x333333
@property (strong, nonatomic) UIColor *valueColor;//default is 0x666666

@property (assign, nonatomic) CGFloat hSpacing;//default is 10
@property (assign, nonatomic) CGFloat vSpacing;//default is 10

@property (strong, nonatomic) UIFont *titleFont;//default is 14
@property (strong, nonatomic) UIFont *valueFont;//default is 14

@property (assign, nonatomic) NSTextAlignment titleAlignment;//default is left
@property (assign, nonatomic) NSTextAlignment valueAlignment;//default is left

- (void)reloadDataWithPropertyTitles:(NSArray<NSString*>*)titles
                              values:(NSArray<NSString*>*)values;

- (void)reloadDataWithAttributedPropertyTitles:(NSArray<NSAttributedString*>*)titles
                                        values:(NSArray<NSAttributedString*>*)values;

@end
