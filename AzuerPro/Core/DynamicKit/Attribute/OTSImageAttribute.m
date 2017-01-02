//
//  OTSImageAttribute.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSImageAttribute.h"
#import <OTSKit/OTSKit.h>

@implementation OTSImageAttribute

- (instancetype)init {
    if (self = [super init]) {
        _compressed = true;
    }
    return self;
}

@end

@implementation UIImageView (OTSImageAttributeApply)

- (void)applyAttribute:(OTSImageAttribute*)attribute {
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
    
    if (attribute.cornerRadius) {
        self.layer.cornerRadius = attribute.cornerRadius;
        self.layer.masksToBounds = true;
    }
}

@end

@implementation UIButton (OTSImageAttributeApply)

- (void)applyAttribute:(OTSImageAttribute*)attribute {
    if (attribute.imageName.length) {
        [self setImage:[UIImage imageNamed:attribute.imageName] forState:UIControlStateNormal];
    } else if(attribute.imageURL.length) {
        if (attribute.preferredWidth && attribute.preferredHeight) {
            WEAK_SELF;
            [UIImageView downloadImageForURL:attribute.imageURL compressed:attribute.compressed width:attribute.preferredWidth height:attribute.preferredHeight completion:^(UIImage *image, NSError *anError) {
                STRONG_SELF;
                [self setImage:image forState:UIControlStateNormal];
                if (attribute.cornerRadius) {
                    self.imageView.layer.cornerRadius = attribute.cornerRadius;
                    self.imageView.layer.masksToBounds = true;
                }
            }];
        } else {
            //not supported
        }
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self applyAttribute:attribute alternativeFont:14.0 andColor:0x333333];
}

@end
