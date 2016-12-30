//
//  OTSTextPageControl.h
//  OTSUIKit
//
//  Created by Jerry on 16/4/26.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OTSTextPageControlSelectionStyle) {
    OTSTextPageControlSelectionStylePlain,
    OTSTextPageControlSelectionStyleZoom,
    OTSTextPageControlSelectionStyleLine,
    OTSTextPageControlSelectionStyleRoundRect
};

@interface OTSTextPageControl : UIControl

@property (assign, nonatomic) CGFloat textMargin;
@property (strong, nonatomic) NSArray<NSString*> *contents;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;

@property (assign, nonatomic) NSInteger selectedIdx;
@property (assign, nonatomic) OTSTextPageControlSelectionStyle selectionStyle;

@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) BOOL showDivider;

- (void)showBadgedNumber:(NSInteger)badgedNumber idx:(NSInteger)idx;
@end
