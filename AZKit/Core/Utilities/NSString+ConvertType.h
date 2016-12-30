//
//  NSString+ConvertType.h
//  OneStoreFramework
//
//  Created by Aimy on 14/11/5.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ConvertType)

+(NSString *) unicodeToUtf8:(NSString *)string;
+(NSString *) utf8ToUnicode:(NSString *)string;

@end
