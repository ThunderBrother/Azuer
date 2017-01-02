//
//  UIViewController+HciToken.m
//  OneStoreLight
//
//  Created by Jerry on 16/10/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UIViewController+HciToken.h"
#import <OTSKit/OTSKit.h>
#import <Aspects/Aspects.h>
#import <CommonCrypto/CommonCryptor.h>

NSString *const OTSHciAssociatedKeyInfo = @"ots_stored_hciInfo";
NSString *const OTSHciAssociatedKeyDate = @"ots_stored_hciDate";
NSString *const OTSHciAssociatedKeyTouch = @"ots_stored_hciTouch";

NSString *const OTSHciAssociatedKeyEditCount = @"ots_stored_hciEditCount";
NSString *const OTSHciAssociatedKeyEditCountKeys = @"ots_stored_hciEditCountKeys";

@implementation UIViewController (HciToken)

- (NSString*)flushHciToken {
    NSMutableDictionary *info = self.hciInfo;
    
    NSDate *startDate = [self objc_getAssociatedObject:OTSHciAssociatedKeyDate];
    if (startDate) {
        NSDate *endDate = [NSDate date];
        long long timeDistance = [endDate timeIntervalSinceDate:startDate] * 1000;
        [info setValue:[NSString stringWithFormat:@"%lld",timeDistance] forKey:@"sd"];
    }
    
    NSMutableArray *editTFKeys = [self objc_getAssociatedObject:OTSHciAssociatedKeyEditCountKeys];
    NSMutableDictionary *editCountInfo = [self objc_getAssociatedObject:OTSHciAssociatedKeyEditCount];
    if (editTFKeys.count) {
        NSMutableString *editCountString = [NSMutableString string];
        for (NSNumber *aKey in editCountInfo) {
            [editCountString appendFormat:@"%zd;", [editCountInfo[aKey] integerValue]];
        }
        [info setValue:editCountString.copy forKey:@"tcc"];
    }
    
    NSString *touchedString = [self objc_getAssociatedObject:OTSHciAssociatedKeyTouch];
    if (touchedString.length) {
        [info setValue:touchedString forKey:@"tdp"];
    }
    return [self __getHciTokenTripleDESStringWithDictionary:info];
}

- (void)observeHciForStartTimeInterval {
    NSDate *currentDate = [NSDate date];
    [self objc_setAssociatedObject:OTSHciAssociatedKeyDate value:currentDate policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)observeHciForEditCountInTextFields:(NSArray<UITextField*>*)textFields {
    NSMutableDictionary *editCountInfo = [NSMutableDictionary dictionary];
    NSMutableArray *editTFKeysArray = [NSMutableArray arrayWithCapacity:textFields.count];
    
    long long objAddress = 0;
    for (UITextField *tf in textFields) {
        objAddress = (long long)tf;
        [editTFKeysArray addObject:@(objAddress)];
        [editCountInfo setObject:@0 forKey:@(objAddress)];
        [tf addTarget:self action:@selector(__hciHandleTextFieldEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    }
    [self objc_setAssociatedObject:OTSHciAssociatedKeyEditCountKeys value:editTFKeysArray policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    [self objc_setAssociatedObject:OTSHciAssociatedKeyEditCount value:editCountInfo policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)observeHciForTouchInView:(UIView*)aView {
    WEAK_SELF;
    NSError *anError;
    [aView aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSSet<UITouch *> *touches, UIEvent *event) {
        STRONG_SELF;
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:aspectInfo.instance];
        
        NSString *touchedString = [NSString stringWithFormat:@"%zdX%zd",(NSInteger)touchPoint.x, (NSInteger)touchPoint.y];
        [self objc_setAssociatedObject:OTSHciAssociatedKeyTouch value:touchedString policy:(OBJC_ASSOCIATION_RETAIN_NONATOMIC)];
        
    } error:&anError];
}

#pragma mark - Private
- (void)__hciHandleTextFieldEditEnd:(UITextField*)sender {
    long long objAddress = (long long)sender;
    NSMutableDictionary *editCountInfo = [self objc_getAssociatedObject:OTSHciAssociatedKeyEditCount];
    NSInteger count = [editCountInfo[@(objAddress)] integerValue];
    editCountInfo[@(objAddress)] = @(count + 1);
}

- (void)__addBaseInfoToHciInfo:(NSMutableDictionary*)info {
    //系统aon
    [info setValue:[OTSClientInfo sharedInstance].traderName forKey:@"aon"];
    //系统版本号aov
    [info setObject:[OTSClientInfo sharedInstance].clientVersion forKey:@"aov"];
    //获取UUID
    [info setValue:[OTSClientInfo sharedInstance].deviceCode  forKey:@"dc"];
    //版本号 av
    [info setValue:[OTSClientInfo sharedInstance].clientAppVersion forKey:@"av"];
    //网络类型nt
    [info setValue:[OTSClientInfo sharedInstance].nettype forKey:@"nt"];
    //定位位置g
    [info setValue:[NSString stringWithFormat:@"%@,%@",[OTSClientInfo sharedInstance].latitude,[OTSClientInfo sharedInstance].longitude] forKey:@"g"];
    if ([OTSClientInfo sharedInstance].latitude.integerValue == 0 || [OTSClientInfo sharedInstance].longitude.integerValue == 0) {
        [info setValue:@"" forKey:@"g"];
    }
    //真机/模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        [info setValue:@"1" forKey:@"e"];
    } else {
        [info setValue:@"0" forKey:@"e"];
    }
}

- (NSString *)__getHciTokenTripleDESStringWithDictionary:(NSMutableDictionary*)hciTekonDictionary {
    //转成json格式
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:hciTekonDictionary options:0 error:nil];
    NSString * hciTokenString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // NSLog(@"hciTokenString== %@",hciTokenString);
    
    //base64
    NSString *hciString = [NSString stringWithFormat:@"%@",hciTokenString];
    NSData * hciData = [hciString dataUsingEncoding:NSUTF8StringEncoding];
    NSData * hciBase64 = [hciData base64EncodedDataWithOptions:0];
    
    //reverse
    NSMutableData * hciTokenData = [[NSMutableData alloc] init];
    NSData * mdata;
    for (NSInteger i = hciBase64.length; i > 0; i--) {
        mdata = [hciBase64 subdataWithRange:NSMakeRange(i-1, 1)];
        [hciTokenData appendData:mdata];
    }
    
    //tripLeDES加密
    NSString *desKey = @"3Bq4z2p0eUJ7eDndWPDoQ2wI";
    size_t plainTextBufferSize = [hciTokenData length];
    const void *vplainText = (const void *)[hciTokenData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t bufferOutLength = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [desKey UTF8String];
    //偏移量
    const void *vinitVec = nil;
    //配置CCCrypt
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,  //key
                       kCCKeySize3DES,
                       vinitVec,   //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &bufferOutLength);
    
    NSString *hciTokenTripleDESString = nil;
    if (ccStatus != kCCSuccess) {
        OTSLogE(@"CCCrypt[3DES] failed, errorcode:[%d]", ccStatus);
        return nil;
    } else {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)bufferOutLength];
        hciTokenTripleDESString = [myData base64EncodedStringWithOptions:0];
    }
    if (bufferPtr) {
        free(bufferPtr);
    }
    return hciTokenTripleDESString;
}

#pragma mark - Getter & Setter
- (NSMutableDictionary*)hciInfo {
    NSMutableDictionary *mInfo = [self objc_getAssociatedObject:OTSHciAssociatedKeyInfo];
    if (!mInfo) {
        mInfo = [NSMutableDictionary dictionary];
        [self __addBaseInfoToHciInfo:mInfo];
        [self objc_setAssociatedObject:OTSHciAssociatedKeyInfo value:mInfo policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    
    return mInfo;
}

@end
