//
//  OTSScoreGroupView.m
//  OTSKit
//
//  Created by HUI on 16/9/18.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSScoreGroupView.h"
#import "UIColor+Utility.h"

@interface OTSScoreGroupView ()

@property (nonatomic, strong) NSArray<UIButton*> *buttonsArray;

@end

@implementation OTSScoreGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageName = @"icon_bigstart_gray";
        _highlightedImageName = @"icon_bigstart";
        _innerMargin = 2.0;
        
        self.maxScore = 5.0;
        self.score = self.maxScore;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat xOffset = .0;
    for (UIButton *aButton in self.buttonsArray) {
        aButton.frame = CGRectMake(xOffset, 0, height, height);
        xOffset = CGRectGetMaxX(aButton.frame) + self.innerMargin;
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(20.0 * self.maxScore + (self.maxScore - 1) * self.innerMargin, 20.0);
}

- (void)__updateButtonsForImageChange {
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *aBtn = self.buttonsArray[i];
        [aBtn setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
        [aBtn setImage:[UIImage imageNamed:self.highlightedImageName] forState:UIControlStateSelected];
    }
}

- (void)__didPressScoreButton:(UIButton*)sender {
    NSInteger idx = [self.buttonsArray indexOfObject:sender];
    if (idx != NSNotFound && _score != (idx + 1)) {
        self.score = idx + 1;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Getter & Setter
- (void)setImageName:(NSString *)imageName {
    if (imageName.length && ![_imageName isEqualToString:imageName]) {
        _imageName = imageName;
        [self __updateButtonsForImageChange];
    }
}

- (void)setHighlightedImageName:(NSString *)highlightedImageName {
    if (highlightedImageName.length && ![_highlightedImageName isEqualToString:highlightedImageName]) {
        _highlightedImageName = highlightedImageName;
        [self __updateButtonsForImageChange];
    }
}

- (void)setMaxScore:(NSUInteger)maxScore {
    if (maxScore && _maxScore != maxScore) {
        _maxScore = maxScore;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:maxScore];
        for (int i = 0; i < maxScore; i++) {
            UIButton *aButton = [[UIButton alloc] init];
            [aButton addTarget:self action:@selector(__didPressScoreButton:) forControlEvents:UIControlEventTouchUpInside];
            [btnArray addObject:aButton];
            [self addSubview:aButton];
        }
        self.buttonsArray = [btnArray copy];
        [self __updateButtonsForImageChange];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setScore:(NSUInteger)score {
    if (_score != score && score <= self.maxScore) {
        _score = score;
        for (int i = 0; i < self.buttonsArray.count; i++) {
            UIButton *aButton = self.buttonsArray[i];
            aButton.selected = (i < score);
        }
    }
}

- (void)setInnerMargin:(CGFloat)innerMargin {
    if (_innerMargin != innerMargin) {
        _innerMargin = innerMargin;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}

@end
