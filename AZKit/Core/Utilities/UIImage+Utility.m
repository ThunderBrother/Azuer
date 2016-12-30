//
//  UIImage+Utility.m
//  OTSKit
//
//  Created by Jerry on 16/9/1.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIImage+Utility.h"
#import "OTSFileManager.h"

@implementation UIImage (Utility)

+ (UIImage *)imageWithColor:(UIColor *)aColor {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)aColor cornerRadius:(float)cornerRadius {
    CGFloat minSize = cornerRadius * 2 + 1;;
    CGRect rect = CGRectMake(0, 0, minSize, minSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [aColor setFill];
    [roundedRect fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage *)imageWithView:(UIView *)view {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width,
                                                      view.frame.size.height),
                                           NO,
                                           scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    CGContextRestoreGState(context);
    
    //开始生成图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)image:(UIImage *)image WithTintColor:(UIColor *)tintColor {
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size {
    //不用CGImageGetHeight(self.CGImage)，图片拍摄后会旋转90度，exif属性会记录，CGImageGetHeight实际会获得宽度而不是高度
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height - height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *	按照尺寸缩放图片
 *
 *	@param aSize
 *
 *	@return
 */
- (UIImage *)shrinkImageForSize:(CGSize)aSize {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 aSize.width ,
                                                 aSize.height ,
                                                 8,
                                                 0,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, aSize.width , aSize.height ),
                       self.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    CGColorSpaceRelease(colorSpace);
    return final;
}

- (NSString *)saveImageWithName:(NSString *)imageName
          forCompressionQuality:(CGFloat )aQuality {
    if (aQuality < 0) {
        aQuality = 0;
    }
    if (aQuality > 1.0f) {
        aQuality = 1.0f;
    }
    
    NSData* imageData=UIImageJPEGRepresentation(self, aQuality);
    
    NSString* fullPathToFile = [[OTSFileManager appDocPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:fullPathToFile error:nil];
    }
    
    NSLog(@"save image%@ At path %@",self,fullPathToFile);
    
    if (![imageData writeToFile:fullPathToFile atomically:NO]) {
        return nil;
    }
    return fullPathToFile;
}


@end
