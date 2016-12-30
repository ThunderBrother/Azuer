//
//  OTSConvertImageString.m
//  OneStoreFramework
//
//  Created by zhangbin on 14-9-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSConvertImageString.h"

//支持phone pad
#define kMaxImageWidth  1024
#define kMaxImageHeight 1024

@implementation OTSConvertImageString

+ (NSString *)convertPicURL:(NSString *)picURL toSize:(CGSize)size
{
    return [self convertPicURL:picURL viewWidth:size.width viewHeight:size.height];
}

+ (NSString *)convertPicURL:(NSString *)picURL
                  viewWidth:(NSInteger)aWidth
                 viewHeight:(NSInteger)aHeight
{
    return [self convertPicURL:picURL viewWidth:aWidth viewHeight:aHeight withImageSizeLinkType:0];
}

+ (NSString *)convertPicURL:(NSString *)picURL
                  viewWidth:(NSInteger)aWidth
                 viewHeight:(NSInteger)aHeight
      withImageSizeLinkType:(OTSImageSizeLinkType)imageSizeLinkType
{
    if (aWidth > kMaxImageWidth) {
        aWidth = kMaxImageWidth;
    }
    if (aHeight > kMaxImageHeight) {
        aHeight = kMaxImageHeight;
    }
    NSString *sizeString = nil;
    if (imageSizeLinkType == OTSImageSizeLinkType_y) {
        //y表示填充,不会有白边
       sizeString = [NSString stringWithFormat:@"%ldy%ld", (long)(aWidth * [[UIScreen mainScreen] scale]), (long)(aHeight * [[UIScreen mainScreen] scale])];
        return [self convertPicURL:picURL toSizeFormat:sizeString withImageSizeLinkType:OTSImageSizeLinkType_y];
    } else {
        //x 表等比缩放
       sizeString = [NSString stringWithFormat:@"%ldx%ld", (long)(aWidth * [[UIScreen mainScreen] scale]), (long)(aHeight * [[UIScreen mainScreen] scale])];
        return [self convertPicURL:picURL toSizeFormat:sizeString withImageSizeLinkType:OTSImageSizeLinkType_x];
    }
}

+ (NSString *)resizeCropPicURL:(NSString *)picURL
                     viewWidth:(NSInteger)aWidth
                    viewHeight:(NSInteger)aHeight {
    if (aWidth > kMaxImageWidth) {
        aWidth = kMaxImageWidth;
    }
    if (aHeight > kMaxImageHeight) {
        aHeight = kMaxImageHeight;
    }
    //大写的 X 表示剪切缩放
    NSString *sizeString = [NSString stringWithFormat:@"%ldX%ld", (long)(aWidth * [[UIScreen mainScreen] scale]), (long)(aHeight * [[UIScreen mainScreen] scale])];
    
    return [self convertPicURL:picURL toSizeFormat:sizeString];
}

+ (NSString *)fullSizePicURL:(NSString *)picURL
                  viewWidth:(NSInteger)aWidth
                 viewHeight:(NSInteger)aHeight
{
    if (aWidth > kMaxImageWidth) {
        aWidth = kMaxImageWidth;
    }
    if (aHeight > kMaxImageHeight) {
        aHeight = kMaxImageHeight;
    }
    //小写的 x 表示等比缩放
    NSString *sizeString = [NSString stringWithFormat:@"%ldy%ld", (long)(aWidth * [[UIScreen mainScreen] scale]), (long)(aHeight * [[UIScreen mainScreen] scale])];
    
    return [self convertPicURL:picURL toSizeFormat:sizeString withImageSizeLinkType:OTSImageSizeLinkType_y];
}

+ (NSString *)convertPicURL:(NSString *)picURL toSizeFormat:(NSString *)sizeStr {
    
    return [self convertPicURL:picURL toSizeFormat:sizeStr withImageSizeLinkType:OTSImageSizeLinkType_x];
    
}

+ (NSString *)convertPicURL:(NSString *)picURL toSizeFormat:(NSString *)sizeStr withImageSizeLinkType:(OTSImageSizeLinkType)imageSizeLinkType
{
    if (!picURL) {
        return nil;
    }

    if (!sizeStr) {
        return picURL;
    }

    static NSRegularExpression *sizeRE_x = nil, *sizeRE_y = nil, *serviceRE = nil, *sizeSubRE_x = nil, *sizeSubRE_y = nil, *extSubRE = nil;
    
    NSRegularExpression *sizeRE = nil, *sizeSubRE = nil;
    if (imageSizeLinkType == OTSImageSizeLinkType_y) {
        if (!sizeRE_y) {
            sizeRE_y = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,4}y\\d{1,4}.(jpg|webp|png)$" options:0 error:nil];
        }
        if (!sizeSubRE_y) {
             sizeSubRE_y = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,4}y\\d{1,4}" options:0 error:nil];
        }
        sizeRE = sizeRE_y;
        sizeSubRE = sizeSubRE_y;
    } else  {
        if (!sizeRE_x) {
            sizeRE_x = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,4}x\\d{1,4}.(jpg|webp|png)$" options:0 error:nil];
        }
        if (!sizeSubRE_x) {
             sizeSubRE_x = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,4}x\\d{1,4}" options:0 error:nil];
        }
        sizeRE = sizeRE_x;
        sizeSubRE = sizeSubRE_x;
    }

    if (!extSubRE) {
        //后缀
        extSubRE = [NSRegularExpression regularExpressionWithPattern:@".(jpg|webp|png)$" options:0 error:nil];
    }

    if (!serviceRE) {
        //设置服务器url正则表达式
        serviceRE = [NSRegularExpression regularExpressionWithPattern:@"^http://d\\d+.yihaodian(img)?.com/" options:0 error:nil];
    }

    //获取尺寸range
    NSRange sizeRange = [[sizeRE firstMatchInString:picURL options:0 range:NSMakeRange(0, [picURL length])] rangeAtIndex:0];
    
    //获取服务器range
    NSRange serviceRange = [[serviceRE firstMatchInString:picURL options:0 range:NSMakeRange(0, [picURL length])] rangeAtIndex:0];

    //处理
    if (sizeRange.length > 0 && serviceRange.length > 0) {
        // 给的图片url，已经限制了图片大小，所以替换大小字段
        NSString *sizeString = [picURL substringWithRange:sizeRange];
        NSString *subSizeString = [sizeSubRE stringByReplacingMatchesInString:sizeString
                                                                      options:0
                                                                        range:NSMakeRange(0, sizeString.length)
                                                                 withTemplate:sizeStr];
        NSString *str = [sizeRE stringByReplacingMatchesInString:picURL
                                                         options:0
                                                           range:NSMakeRange(0, picURL.length)
                                                    withTemplate:subSizeString];
        return str;
    }
    else if(serviceRange.length > 0) {
        // 给的图片url，没有限制了图片大小，加上大小字段
        NSString *extString = [picURL substringWithRange:[[extSubRE firstMatchInString:picURL options:0 range:NSMakeRange(0, picURL.length)] rangeAtIndex:0]];
        NSString *str = [extSubRE stringByReplacingMatchesInString:picURL
                                                           options:0
                                                             range:NSMakeRange(0, picURL.length)
                                                      withTemplate:[NSString stringWithFormat:@"_%@%@", sizeStr, extString]];
        return str;
    }
    else {
        // 不由可变的图片服务器提供
        return picURL;
    }
}

@end
