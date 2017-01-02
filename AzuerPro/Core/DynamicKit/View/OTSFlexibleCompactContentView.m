//
//  OTSFlexibleCompactContentView.m
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSFlexibleCompactContentView.h"
#import <OTSKit/OTSKit.h>

@implementation OTSFlexibleCompactContentView

- (void)__layoutCellSubViews {
    [super __layoutCellSubViews];
    
    CGFloat height = self.height;
    
    if (_leftSubTitleLabel.text) {
        CGFloat leftTitleTotalHeight = _leftSubTitleLabel.bottom - _leftTitleLabel.top;
        CGFloat topMargin = (height - leftTitleTotalHeight) * .5;
        
        _leftTitleLabel.top = topMargin;
        _leftSubTitleLabel.bottom = height - topMargin;
        
    }
    
    if (_rightSubTitleLabel.text) {
        CGFloat rightTitleTotalHeight = _rightSubTitleLabel.bottom - _rightTitleLabel.top;
        CGFloat topMargin = (height - rightTitleTotalHeight) * .5;
        
        _rightTitleLabel.top = topMargin;
        _rightSubTitleLabel.bottom = height - topMargin;
    }
}

@end
