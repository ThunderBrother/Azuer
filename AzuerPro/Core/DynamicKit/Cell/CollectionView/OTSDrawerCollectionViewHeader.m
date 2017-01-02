//
//  OTSDrawerCollectionViewHeader.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/9.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDrawerCollectionViewHeader.h"
#import "OTSCollectionViewSection.h"

@interface OTSDrawerCollectionViewHeader()

@property (assign, nonatomic) NSInteger currentSection;

@end

@implementation OTSDrawerCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHeader:)];
        [self addGestureRecognizer:tapGesture];
        
        [self addSubview:self.decorationView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.arrowImgView];
        
        self.borderColor = [UIColor colorWithRGB:0xe6e6e6];
        self.borderOption = OTSBorderOptionTop;
    }
    return self;
}

- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    self.currentSection = section;
    if (![aData isKindOfClass:[OTSCollectionViewItem class]]) {
        return;
    }
    
    OTSCollectionViewItem *item = aData;
    self.titleLabel.text = item.titleAttribute.title;
    
    BOOL isPlain = [item.userInfo[@"plain"] boolValue];
    
    if (isPlain) {
        self.titleLabel.left = 15.0;
    } else {
        self.titleLabel.left = 20.0;
    }
    
    self.decorationView.hidden = item.parent.closed || isPlain;
    self.arrowImgView.transform = CGAffineTransformMakeRotation(item.parent.closed ? -M_PI_2 : M_PI_2);
    
    self.backgroundColor = item.parent.closed ? [UIColor colorWithRGB:0xfafafa] : [UIColor whiteColor];
    self.titleLabel.backgroundColor = self.backgroundColor;
    
    if (item.parent.closed && [item.userInfo[@"isLast"] boolValue]) {
        self.borderOption = OTSBorderOptionTop | OTSBorderOptionBottom;
    } else {
        self.borderOption = OTSBorderOptionTop;
    }
}

#pragma mark - Action
- (void)didTapHeader:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didToggleDrawerStateForSection:)]) {
        [self.delegate didToggleDrawerStateForSection:self.currentSection];
    }
}

#pragma mark - Getter & Setter
- (UIView*)decorationView {
    if (!_decorationView) {
        _decorationView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 5, 20)];
        _decorationView.centerY = self.height * .5f;
        _decorationView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _decorationView.backgroundColor = OTSThemeColor;
    }
    return _decorationView;
}

- (UIImageView*)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_right_arrow"]];
        [_arrowImgView sizeToFit];
        _arrowImgView.centerX = self.width - _arrowImgView.width * .5f - 15.0;
        _arrowImgView.centerY = self.height * .5f;
        _arrowImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _arrowImgView;
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.width - 50, self.height)];
        _titleLabel.textColor = [UIColor colorWithRGB:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
    
}

@end
