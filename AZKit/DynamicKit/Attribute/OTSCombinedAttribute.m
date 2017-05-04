//
//  OTSCombinedAttribute.m
//  OTSKit
//
//  Created by Jerry on 2017/1/7.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSCombinedAttribute.h"
#import "UIImageView+Network.h"
#import "UIImage+Utility.h"
#import "UIColor+Utility.h"
#import "AZFuncDefine.h"

@implementation OTSCombinedAttribute

@end

@implementation UIButton (OTSCombinedAttribute)

- (void)applyAttribute:(OTSCombinedAttribute*)attribute delegate:(id)delegate {
    [super applyAttribute:attribute delegate:delegate];
    if (attribute.imageAttribute.imageName.length) {
        [self setImage:[UIImage imageNamed:attribute.imageAttribute.imageName] forState:UIControlStateNormal];
    } else if(attribute.imageAttribute.imageURL.length) {
        if (attribute.imageAttribute.preferredWidth && attribute.imageAttribute.preferredHeight) {
            WEAK_SELF;
            [UIImageView downloadImageForURL:attribute.imageAttribute.imageURL compressed:attribute.imageAttribute.compressed width:attribute.preferredWidth height:attribute.preferredHeight completion:^(UIImage *image, NSError *anError) {
                STRONG_SELF;
                [self setImage:image forState:UIControlStateNormal];
                if (attribute.imageAttribute.cornerRadius) {
                    self.imageView.layer.cornerRadius = attribute.cornerRadius;
                    self.imageView.layer.masksToBounds = true;
                } else {
                    self.imageView.layer.cornerRadius = 0;
                    self.imageView.layer.masksToBounds = false;

                }
            }];
        } else {
            //not supported
        }
    } else if(attribute.backgroundImageColor) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:attribute.backgroundImageColor]] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
    
    if (attribute.textAttribute) {
        if (attribute.textAttribute.attributedTitle) {
            self.titleLabel.attributedText = attribute.textAttribute.attributedTitle;
        } else {
            [self setTitle:attribute.textAttribute.title forState:UIControlStateNormal];
        }
        
        [self setTitleColor:[UIColor colorWithRGB:attribute.textAttribute.color ?: 0x333333] forState:UIControlStateNormal];
        
        CGFloat fontSize = attribute.textAttribute.fontSize ?: 14.0;
        self.titleLabel.font = attribute.textAttribute.bold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
        
    } else {
        [self setTitle:nil forState:UIControlStateNormal];
    }
    
    self.contentEdgeInsets = attribute.contentInsets;
}

@end
