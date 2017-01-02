//
//  OTSPlaceHolderImageView.m
//  OTSKit
//
//  Created by Jerry on 16/9/6.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSPlaceHolderImageView.h"
#import "AZFuncDefine.h"

@implementation OTSPlaceHolderImageView

OTSViewInit {
    self.image = nil;
}

- (void)setImage:(UIImage *)image {
    if (image) {
        self.contentMode = UIViewContentModeScaleToFill;
    } else {
        image = [UIImage imageNamed:@"loadingimg"];
        self.contentMode = UIViewContentModeCenter;
    }
    
    [super setImage:image];
}

@end
