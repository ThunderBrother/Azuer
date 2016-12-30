//
//  OTSImageCollectionView.m
//  OTSKit
//
//  Created by Jerry on 16/9/14.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSImageCollectionView.h"
#import "OTSPlaceHolderImageView.h"
#import "UIView+Frame.h"
#import "UIView+Border.h"
#import "UIImageView+Network.h"
#import "UIColor+Utility.h"
#import "OTSFuncDefine.h"

static const CGFloat OTSEllipsisWidth = 14.0;

@interface OTSImageCollectionView ()

@property (strong, nonatomic) UILabel *ellipsisLabel;
@property (assign, nonatomic) CGFloat lastWidth;

@property (strong, nonatomic, null_resettable) NSMutableArray<OTSPlaceHolderImageView*> *reusableImageArray;

@end

@implementation OTSImageCollectionView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.width && self.lastWidth != self.width) {
        self.lastWidth = self.width;
        [self __reloadImageViews];
    }
}

#pragma mark - Getter & Setter
- (UILabel*)ellipsisLabel {
    if (!_ellipsisLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, OTSEllipsisWidth, self.height)];
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"...";
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        _ellipsisLabel = label;
    }
    return _ellipsisLabel;
}

- (void)setImageArray:(NSArray<NSString *> *)imageArray {
    if (_imageArray != imageArray) {
        _imageArray = imageArray;
        [self __reloadImageViews];
    }
}

- (NSMutableArray<OTSPlaceHolderImageView*>*)reusableImageArray {
    if (!_reusableImageArray) {
        _reusableImageArray = [NSMutableArray arrayWithCapacity:10.0];
    }
    return _reusableImageArray;
}

#pragma mark - Private
- (void)__reloadImageViews {
    
    for (UIView *subView in self.subviews) {
        [self __enqueueImageView:subView];
    }
    
    CGFloat xOffset = .0;
    CGFloat imageWidth = self.height;
    CGFloat imageHeight = imageWidth;
    
    for (int i = 0; i < self.imageArray.count; i++) {
        OTSPlaceHolderImageView *imgView = [self __dequeueImageView];
        imgView.frame = CGRectMake(xOffset, 0, imageWidth, imageHeight);
        [imgView loadImageForURL:self.imageArray[i] compressed:true];
        [self addSubview:imgView];
        
        xOffset += imageWidth + UI_DEFAULT_MARGIN;
        
        if (i < self.imageArray.count - 1 && self.width - xOffset < imageWidth + UI_DEFAULT_MARGIN + OTSEllipsisWidth) {
            self.ellipsisLabel.frame = CGRectMake(xOffset, 0, OTSEllipsisWidth, imageHeight);
            [self addSubview:self.ellipsisLabel];
            break;
        }
    }
}

- (void)__enqueueImageView:(UIView*)subView {
    if (self.reusableImageArray.count < 10 && [subView isKindOfClass:[OTSPlaceHolderImageView class]]) {
        OTSPlaceHolderImageView *anImgView = (id)subView;
        anImgView.image = nil;
        
        [self.reusableImageArray addObject:anImgView];
    }
    [subView removeFromSuperview];
}

- (OTSPlaceHolderImageView*)__dequeueImageView {
    if (self.reusableImageArray.count) {
        OTSPlaceHolderImageView *imgView = self.reusableImageArray.lastObject;
        [self.reusableImageArray removeLastObject];
        return imgView;
    }
    
    OTSPlaceHolderImageView *imgView = [[OTSPlaceHolderImageView alloc] init];
    imgView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    imgView.layer.borderColor = [UIColor colorWithRGB:0xe6e6e6].CGColor;
    return imgView;
}

@end
