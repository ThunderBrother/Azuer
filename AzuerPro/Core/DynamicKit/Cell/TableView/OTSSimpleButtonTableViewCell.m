//
//  OTSSimpleButtonTableViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSSimpleButtonTableViewCell.h"
#import "OTSTableViewItem.h"

@implementation OTSSimpleButtonTableViewCell

@synthesize titleButton = _titleButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleButton];
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self.titleButton) {
        return self.contentView;
    }
    return hitView;
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    [self.titleButton applyAttribute:item.imageAttribute];
    [self.titleButton applyAttribute:item.titleAttribute alternativeFont:14.0 andColor:0x333333];
}

#pragma mark - Getter & Setter
- (UIButton*)titleButton {
    if (!_titleButton) {
        _titleButton = [[UIButton alloc] initWithFrame:CGRectMake(UI_DEFAULT_PADDING, 0, self.width - UI_DEFAULT_PADDING * 2.0, self.height)];
        _titleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleButton;
}

@end
