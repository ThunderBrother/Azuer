//
//  OTSAbstractContentView.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSDynamicKitProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSAbstractContentView : UIView<OTSDynamicContentViewProtocol> {
    NSIndexPath *_indexPath;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
