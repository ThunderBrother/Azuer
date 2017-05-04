//
//  JSONValueTransformer+OTSTransformer.m
//  OTSKit
//
//  Created by Jerry on 2017/3/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "JSONValueTransformer+OTSTransformer.h"
#import <UIKit/UIGeometry.h>

@implementation JSONValueTransformer (OTSTransformer)

- (NSString *)JSONObjectFromCGSize:(NSValue *)cgsizeValue {
    return NSStringFromCGSize(cgsizeValue.CGSizeValue);
}

- (NSValue *)CGSizeFromNSString:(NSString *)cgsizeString {
    if (cgsizeString) {
        return [NSValue valueWithCGSize:CGSizeFromString(cgsizeString)];
    }
    return nil;
}

@end
