//
//  OTSCodingObject.h
//  OTSKit
//
//  Created by Jerry on 2016/11/22.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTSCodingObject : NSObject<NSCoding>

+ (Class)collectionClassForKey:(NSString*)key;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

+ (NSArray<__kindof OTSCodingObject*>*) arrayWithJSONArray:(NSArray<NSDictionary*>*)array;

@end
