//
//  OTSConvertImageString.h
//  OneStoreFramework
//
//  Created by zhangbin on 14-9-28.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, OTSImageSizeLinkType) {
    OTSImageSizeLinkType_x          = 1,        //尺寸为: ***x**** 等比缩放
    OTSImageSizeLinkType_y          = 2         //尺寸为: ***y**** 填充
};

@interface OTSConvertImageString : NSObject

/**
 *	功能:图片的url转换成任意格式大小的图片url
 *
 *	@param picURL  :源图片url
 *	@param size :要转换成的格式大小
 *
 *	@return 转换后的图片url
 */
+ (NSString *)convertPicURL:(NSString *)picURL
                     toSize:(CGSize)size;

/**
 *	功能:图片的url,根据控件的宽、高来获取适配的url
 *
 *	@param picURL  :源图片url
 *	@param aWidth  :控件的宽
 *	@param aHeight :控件的高
 *
 */
+ (NSString *)convertPicURL:(NSString *)picURL
                  viewWidth:(NSInteger)aWidth
                 viewHeight:(NSInteger)aHeight;

/**
 *	功能:图片的url,根据控件的宽、高获取撑满该尺寸的图片 URL(不要白边)
 *
 *	@param picURL  :源图片url
 *	@param aWidth  :控件的宽
 *	@param aHeight :控件的高
 *
 */
+ (NSString *)convertPicURL:(NSString *)picURL
                   viewWidth:(NSInteger)aWidth
                  viewHeight:(NSInteger)aHeight
       withImageSizeLinkType:(OTSImageSizeLinkType)imageSizeLinkType;

/**
 *	功能:图片的url,根据控件的宽、高,经过缩放裁剪,获取适配的url
 *
 *	@param picURL  :源图片url
 *	@param aWidth  :控件的宽
 *	@param aHeight :控件的高
 *
 */
+ (NSString *)resizeCropPicURL:(NSString *)picURL
                     viewWidth:(NSInteger)aWidth
                    viewHeight:(NSInteger)aHeight;

/**

 *	功能:图片的url转换成任意格式大小的图片url
 *
 *	@param picURL  :源图片url
 *	@param sizeStr :要转换成的格式大小
 *
 *	@return 转换后的图片url
 */
+ (NSString *)convertPicURL:(NSString *)picURL
               toSizeFormat:(NSString *)sizeStr;

@end
