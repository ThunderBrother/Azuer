//
//  OTSImageAttribute.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/16.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTextAttribute.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSImageAttribute : OTSTextAttribute

@property (strong, nonatomic, nullable) NSString *imageName;
@property (strong, nonatomic, nullable) NSString *imageURL;

@property (assign, nonatomic) BOOL compressed; //default is YES

@end

NS_INLINE OTSImageAttribute* OTSImageMake(NSString *imageName) {
    OTSImageAttribute *item = [[OTSImageAttribute alloc] init];
    item.imageName = imageName;
    return item;
}

NS_INLINE OTSImageAttribute* OTSImageMakeF(NSString *imageURL, CGFloat width, CGFloat height) {
    OTSImageAttribute *item = [[OTSImageAttribute alloc] init];
    item.imageURL = imageURL;
    item.preferredWidth = width;
    item.preferredHeight = height;
    return item;
}

@interface UIImageView (OTSImageAttributeApply)

- (void)applyAttribute:(nullable OTSImageAttribute*)attribute;

@end

@interface UIButton (OTSImageAttributeApply)

- (void)applyAttribute:(nullable OTSImageAttribute*)attribute;

@end

NS_ASSUME_NONNULL_END
