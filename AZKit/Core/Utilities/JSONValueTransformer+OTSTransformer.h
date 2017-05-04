//
//  JSONValueTransformer+OTSTransformer.h
//  OTSKit
//
//  Created by Jerry on 2017/3/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JSONValueTransformer (OTSTransformer)

- (NSString *)JSONObjectFromCGSize:(NSValue *)cgsizeValue;

- (NSValue *)CGSizeFromNSString:(NSString *)cgsizeString;

@end
