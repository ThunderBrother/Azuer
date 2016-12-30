//
//  UIImageView+Network.h
//  OTSKit
//
//  Created by Jerry on 16/9/10.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void)loadImageForURL:(NSString*)url
             compressed:(BOOL)compressed;

- (void)loadImageForURL:(NSString*)url
             compressed:(BOOL)compressed
                  width:(CGFloat)width
                 height:(CGFloat)height;

+ (void)downloadImageForURL:(NSString*)url
                 compressed:(BOOL)compressed
                      width:(CGFloat)width
                     height:(CGFloat)height
                 completion:(void (^)(UIImage *image, NSError *anError))completion;

@end
