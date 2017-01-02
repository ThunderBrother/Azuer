//
//  OTSSubmitTableViewFooter.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSSubmitTableViewFooter.h"
#import "OTSTableViewItem.h"
#import "UIButton+Make.h"

@interface OTSSubmitTableViewFooter ()

@property (assign, nonatomic) NSInteger section;

@end

@implementation OTSSubmitTableViewFooter

@synthesize submitButton = _submitButton;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.submitButton];
    }
    return self;
}

- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    self.section = section;
    if (![aData isKindOfClass:[OTSTableViewItem class]]) {
        return;
    }
    
    OTSTableViewItem *item = (OTSTableViewItem*)aData;
    [self.submitButton applyAttribute:item.imageAttribute];
    [self.submitButton applyAttribute:item.titleAttribute alternativeFont:14.0 andColor:0xffffff];
    
    self.submitButton.enabled = !item.disabled;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _submitButton.frame = CGRectMake(UI_DEFAULT_PADDING, (self.height - 44.0) * .5, self.width - UI_DEFAULT_PADDING * 2, 44.0);
}

#pragma mark - Action
- (void)didClickSubmitButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectFooterAtSection:)]) {
        [self.delegate didSelectFooterAtSection:self.section];
    }
}

#pragma mark - Getter & Setter
- (UIButton*)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(UI_DEFAULT_PADDING, (self.height - 44.0) * .5, self.width - UI_DEFAULT_PADDING * 2, 44.0)];
        [_submitButton makeForBottomActionButton];
        _submitButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_submitButton addTarget:self action:@selector(didClickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
