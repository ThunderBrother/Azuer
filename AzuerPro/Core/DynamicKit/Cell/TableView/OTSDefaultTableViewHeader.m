//
//  OTSDefaultTableViewHeader.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDefaultTableViewHeader.h"
#import "OTSTableViewItem.h"

@implementation OTSDefaultTableViewHeader

@synthesize titleLabel = _titleLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - Override
- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = aData;
    [self.titleLabel applyAttribute:item.titleAttribute alternativeFont:14.0 andColor:0x757575];
    [self.contentView applyAttribute:item.contentAttribute];
}

+ (CGFloat)heightForCellData:(id)aData atSectionIndex:(NSUInteger)section {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return 30.0;
    }
    
    OTSTableViewItem *item = aData;
    return [item.titleAttribute.title sizeWithFont:[UIFont systemFontOfSize:item.titleAttribute.font ?: 14.0] lineBreakMode:NSLineBreakByWordWrapping preferredWidth:UI_CURRENT_SCREEN_WIDTH - UI_DEFAULT_PADDING * 2.0].height + UI_DEFAULT_MARGIN * 2.0;
}

#pragma mark - Getter & Setter
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[OTSPaddingLabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _titleLabel.contentInsets = UIEdgeInsetsMake(0, UI_DEFAULT_PADDING, 0, UI_DEFAULT_PADDING);
        _titleLabel.textColor = [UIColor colorWithRGB:0x757575];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
}

@end
