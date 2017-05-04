//
//  UIImageView+Network.m
//  OTSKit
//
//  Created by Jerry on 16/9/10.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIImageView+Network.h"
#import "UIImageView+WebCache.h"
#import "AZFuncDefine.h"
#import "OTSConvertImageString.h"
#import "UIView+Frame.h"

@implementation UIImageView (Network)

- (void)loadImageForURL:(NSString*)url
             compressed:(BOOL)compressed {
    if (compressed) {
        [self layoutIfNeeded];
    }
    [self loadImageForURL:url compressed:compressed width:self.width height:self.height];
}

- (void)loadImageForURL:(NSString*)url
             compressed:(BOOL)compressed
                  width:(CGFloat)width
                 height:(CGFloat)height {
    NSString *convertedURL;
    if (compressed && width && height) {
        convertedURL = [OTSConvertImageString convertPicURL:url toSize:CGSizeMake(width, height)];
    } else {
        convertedURL = url;
    }
    
    [self.layer removeAllAnimations];
    
    NSURL *imageURL = [NSURL URLWithString:convertedURL];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:imageURL];
    
    BOOL imageInMemory = ([manager.imageCache imageFromMemoryCacheForKey:key] != nil);
    self.image = nil;
    
    WEAK_SELF;
    [self sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF;
        if (!error && image) {
            if (!imageInMemory) {
                CATransition *animation = [CATransition animation];
                animation.type = kCATransitionFade;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.duration = .2f;
                [self.layer addAnimation:animation forKey:nil];
            }
        } else if(compressed) {
            [self sd_setImageWithURL:[NSURL URLWithString:url]];
        }
    }];
}

+ (void)downloadImageForURL:(NSString*)url
                 compressed:(BOOL)compressed
                      width:(CGFloat)width
                     height:(CGFloat)height
                 completion:(void (^)(UIImage *image, NSError *anError))completion {
    
    NSString *convertedURL;
    if (compressed && width && height) {
        convertedURL = [OTSConvertImageString convertPicURL:url toSize:CGSizeMake(width, height)];
    } else {
        convertedURL = url;
    }
    
    NSURL *imageURL = [NSURL URLWithString:convertedURL];
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (compressed && error) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (completion) {
                    completion(image, error);
                }
            }];
        } else if(completion) {
            if (completion) {
                completion(image, error);
            }
        }
    }];
}

@end
