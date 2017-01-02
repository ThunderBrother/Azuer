//
//  OTSTextPageControl.m
//  OTSKit
//
//  Created by Jerry on 16/4/26.
//  Copyright © 2016年 Jerry Wong. All rights reserved.
//

#import "OTSTextPageControl.h"
#import "AZFuncDefine.h"
#import "UIView+Frame.h"
#import "UIView+Border.h"
#import "UIColor+Utility.h"
#import "UIView+BadgedNumber.h"


@implementation OTSTextPageControl {
    NSArray<UIButton*> *_buttonsArray;
    UIScrollView *_scrollView;
    UIView *_selectionView;
}

OTSViewInit {
    self.duration = 0.5f;
    self.font = [UIFont systemFontOfSize:14.0];
    self.textMargin = .0f;
    self.textColor = [UIColor colorWithRGB:0x757575];
    self.duration = .25;
    self.backgroundColor = [UIColor whiteColor];
    
    _selectedIdx = -1;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_scrollView];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGFloat width, height = 0;
    for (UIButton *button in _buttonsArray) {
        [button layoutIfNeeded];
        if (height == 0) {
            height = button.height;
        }
        width += button.width;
    }
    return CGSizeMake(width, height);
}

- (void)layoutSubviews {
    if (_buttonsArray.count == 0) {
        return;
    }
    
    CGFloat totalWidth = 0;
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        [button sizeToFit];
        button.height = self.height;
        totalWidth += button.width;
    }
    
    if (totalWidth > self.width) {
        CGFloat pointX = 0;
        for (int i = 0; i < _buttonsArray.count; i++) {
            UIButton *button = _buttonsArray[i];
            button.left = pointX;
            button.top = 0;
            pointX = CGRectGetMaxX(button.frame);
        }
        _scrollView.contentSize = CGSizeMake(pointX, 0);
    } else {
        CGFloat itemWidth = self.width / _buttonsArray.count;
        for (int i = 0; i < _buttonsArray.count; i++) {
            UIButton *button = _buttonsArray[i];
            button.width = itemWidth;
            button.left = itemWidth * i;
            button.top = 0;
        }
        _scrollView.contentSize = CGSizeMake(self.width, 0);
    }
    [self layoutSelectedView];
}

- (void)tintColorDidChange {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        [button setTitleColor:self.tintColor forState:UIControlStateSelected];
    }
    
    if (self.selectionStyle == OTSTextPageControlSelectionStyleLine) {
        _selectionView.backgroundColor = self.tintColor;
    }
}

#pragma mark - Setter & Getter
- (void)setSelectionStyle:(OTSTextPageControlSelectionStyle)selectionStyle {
    if (_selectionStyle != selectionStyle) {
        _selectionStyle = selectionStyle;
        
        [_selectionView removeFromSuperview];
        _selectionView = nil;
        
        if (selectionStyle == OTSTextPageControlSelectionStyleLine) {
            _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 2.0, 0, 2.0)];
            _selectionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            _selectionView.backgroundColor = self.tintColor;
            [_scrollView addSubview:_selectionView];
        } else if(selectionStyle == OTSTextPageControlSelectionStyleRoundRect) {
            _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 6.0, 0, self.height - 12.0f)];
            _selectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _selectionView.backgroundColor = [UIColor colorWithWhite:.8f alpha:1.0];
            _selectionView.layer.cornerRadius = _selectionView.height * .5f - 2;
            _selectionView.layer.masksToBounds = YES;
            [_scrollView insertSubview:_selectionView atIndex:0];
        }
    }
}

- (void)setSelectedIdx:(NSInteger)selectedIdx {
    if (_selectedIdx != selectedIdx && selectedIdx >= 0 && selectedIdx <= _buttonsArray.count - 1) {
        _selectedIdx = selectedIdx;
        for (int i = 0; i < _buttonsArray.count; i++) {
            UIButton *button = _buttonsArray[i];
            BOOL oldSelected = button.selected;
            button.selected = (i ==selectedIdx);
            BOOL newSelected = button.selected;
            
            if (oldSelected != newSelected) {
                if (self.selectionStyle == OTSTextPageControlSelectionStyleZoom) {
                    [UIView animateWithDuration:self.duration animations:^{
                        button.transform = newSelected ? CGAffineTransformMakeScale(1.1, 1.1) : CGAffineTransformIdentity;
                    }];
                }
            }
        }
        
        [self layoutSelectedView];
        [self fixScrollViewContentOffset];
    }
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        [self refreshButtonsByFontChange];
        [self setNeedsLayout];
    }
}
- (void)setTextMargin:(CGFloat)textMargin {
    if (_textMargin != textMargin) {
        _textMargin = textMargin;
        [self refreshButtonsInsetsByPaddingChanged];
        [self setNeedsLayout];
    }
}


- (void)setShowDivider:(BOOL)showDivider {
    if (_showDivider != showDivider) {
        _showDivider = showDivider;
        [self refreshButtonsDivider];
    }
}

- (void)setContents:(NSArray<NSString *> *)contents {
    if (_contents != contents) {
        _contents = contents;
        [_buttonsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *buttonsNewArray = @[].mutableCopy;
        
        for (int i = 0; i < contents.count; i++) {
            NSString *title = contents[i];
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsNewArray addObject:button];
            [_scrollView addSubview:button];
        }

        _buttonsArray = buttonsNewArray;
        
        [self refreshButtonsColorByTextColor];
        [self refreshButtonsByFontChange];
        [self refreshButtonsInsetsByPaddingChanged];
        [self setNeedsLayout];
        [self refreshButtonsDivider];
        
        self.selectedIdx = 0;
    }
}

#pragma mark - Private
- (void)layoutSelectedView {
    if(self.selectionStyle == OTSTextPageControlSelectionStyleLine || self.selectionStyle == OTSTextPageControlSelectionStyleRoundRect) {
        UIButton *selectedButton = _buttonsArray[self.selectedIdx];
        [UIView animateWithDuration:self.duration animations:^{
            _selectionView.left = selectedButton.left + (self.selectedIdx == 0 ? self.textMargin * .5 : 0);
            _selectionView.width = selectedButton.width - ((self.selectedIdx == 0 || self.selectedIdx == _buttonsArray.count - 1) ? self.textMargin * .5f : 0);
        }];
    }
}

- (void)buttonDidClicked:(UIButton*)sender {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        if (sender == button) {
            self.selectedIdx = i;
            break;
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)refreshButtonsByFontChange {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        button.titleLabel.font = self.font;
    }
}

- (void)refreshButtonsColorByTextColor {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.tintColor forState:UIControlStateSelected];
    }
}

- (void)refreshButtonsInsetsByPaddingChanged {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        CGFloat left = i == 0 ? self.textMargin : self.textMargin * .5f;
        CGFloat right = i == _buttonsArray.count - 1 ? self.textMargin : self.textMargin * .5f;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, left, 0, right);
    }
    [self invalidateIntrinsicContentSize];
}


- (void)refreshButtonsDivider {
    for (int i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        if (self.showDivider && i != _buttonsArray.count - 1) {
            button.borderInsets = UIEdgeInsetsMake(10, 0, 10, 0);
            button.borderOption = OTSBorderOptionRight;
        } else {
            button.borderOption = OTSBorderOptionNone;
        }
    }
}

- (void)fixScrollViewContentOffset {
    if (_scrollView.contentSize.width > self.width) {
        UIButton *currentView = _buttonsArray[self.selectedIdx];
        if (currentView.left - _scrollView.contentOffset.x + currentView.width > self.width) {
            UIButton *nextView = (self.selectedIdx == _buttonsArray.count - 1 ? currentView : _buttonsArray[self.selectedIdx + 1]);
            [_scrollView setContentOffset:CGPointMake(nextView.right - self.width, 0) animated:YES];
        } else if(currentView.left < _scrollView.contentOffset.x) {
            UIButton *preView = (self.selectedIdx == 0 ? currentView : _buttonsArray[self.selectedIdx - 1]);
            [_scrollView setContentOffset:CGPointMake(preView.left, 0) animated:YES];
        }
    }
}

- (void)showBadgedNumber:(NSInteger)badgedNumber idx:(NSInteger)idx{
    if (_buttonsArray.count > idx && badgedNumber >= 0) {
        UIButton *button = _buttonsArray[idx];
        button.badgeString = [NSString stringWithFormat:@"%zd", badgedNumber];
    }
}


@end
