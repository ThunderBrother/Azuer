//
//  OTSImageAttribute.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSImageAttribute.h"
#import "AZFuncDefine.h"
#import "UIView+Frame.h"
#import "UIImageView+Network.h"
#import "UIView+Border.h"

@implementation OTSImageAttribute

- (instancetype)init {
    if (self = [super init]) {
        _compressed = true;
    }
    return self;
}

@end

@implementation UIImageView (OTSImageAttributeApply)

- (void)applyAttribute:(OTSImageAttribute*)attribute delegate:(id)delegate{
    
    [super applyAttribute:attribute delegate:delegate];
    
    if (attribute.imageName.length) {
        self.image = [UIImage imageNamed:attribute.imageName];
    } else if(attribute.imageURL.length) {
        if (attribute.preferredWidth && attribute.preferredHeight) {
            self.width = attribute.preferredWidth;
            self.height = attribute.preferredHeight;
            [self loadImageForURL:attribute.imageURL compressed:attribute.compressed width:attribute.preferredWidth height:attribute.preferredHeight];
        } else {
            [self loadImageForURL:attribute.imageURL compressed:attribute.compressed];
        }
    } else {
        self.image = nil;
    }
}

@end
