//
//  OTSSubmitTableViewFooter.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/29.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSSubmitContentView.h"
#import "AZFuncDefine.h"
#import "UIView+Frame.h"
#import "OTSViewModelItem.h"

@implementation OTSSubmitContentView

@synthesize submitButton = _submitButton;


OTSViewInit {
    [self addSubview:self.submitButton];
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath*)indexPath {
    [super updateWithCellData:aData atIndexPath:indexPath];
    if (![aData isKindOfClass:[OTSViewModelItem class]]) {
        return;
    }
    
    OTSViewModelItem *item = (OTSViewModelItem*)aData;
    [self.submitButton applyAttribute:item.buttonAttribute delegate:self.delegate];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _submitButton.frame = CGRectMake(UI_DEFAULT_PADDING, (self.height - 44.0) * .5, self.width - UI_DEFAULT_PADDING * 2, 44.0);
}

#pragma mark - Action
- (void)didClickSubmitButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:self.indexPath];
    }
}

#pragma mark - Getter & Setter
- (UIButton*)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(UI_DEFAULT_PADDING, (self.height - 44.0) * .5, self.width - UI_DEFAULT_PADDING * 2, 44.0)];
        _submitButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_submitButton addTarget:self action:@selector(didClickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
