//
//  OTSCombinedAttribute.h
//  OTSKit
//
//  Created by Jerry on 2017/1/7.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"
#import "OTSImageAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSCombinedAttribute : OTSViewAttribute

@property (strong, nonatomic, nullable) OTSTextAttribute *textAttribute;
@property (strong, nonatomic, nullable) OTSImageAttribute *imageAttribute;
@property (assign, nonatomic) NSUInteger backgroundImageColor;

@end

NS_INLINE OTSCombinedAttribute* OTSCombinedAttributeMake( NSString * _Nullable  title, NSString *_Nullable imageName) {
    OTSCombinedAttribute *item = [[OTSCombinedAttribute alloc] init];
    item.textAttribute = OTSTitleMake(title);
    item.imageAttribute = OTSImageMake(imageName);
    return item;
}

@interface UIButton (OTSCombinedAttribute)

- (void)applyAttribute:(nullable OTSCombinedAttribute*)attribute delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
