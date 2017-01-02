//
//  OTSSwitchTableViewCell.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/12.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSSwitchTableViewCell.h"
#import "OTSTableViewItem.h"

@interface OTSTableViewCell()

- (UITableView *)__getTableView;

@end

@implementation OTSSwitchTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize switchButton = _switchButton;

#pragma mark - LifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.switchButton];
    }
    return self;
}

#pragma mark - Override
- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    [self.titleLabel applyAttribute:item.titleAttribute alternativeFont:14.0 andColor:0x333333];
    self.switchButton.on = item.selected;
}

#pragma mark - Action
- (void)switchValueDidChange:(UISwitch*)sender {
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:[self __getTableView] didSelectRowAtIndexPath:self.indexPath];
    }
}

#pragma mark - Getter & Setter
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_DEFAULT_PADDING, 0, self.width - UI_DEFAULT_PADDING * 2.0 - 30.0 - UI_DEFAULT_MARGIN, self.height)];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithRGB:0x333333];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _titleLabel;
}

- (UISwitch*)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton sizeToFit];
        _switchButton.centerY = self.height * .5f;
        _switchButton.right = self.width - UI_DEFAULT_PADDING;
        _switchButton.onTintColor = OTSThemeColor;
        _switchButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_switchButton addTarget:self action:@selector(switchValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

@end
