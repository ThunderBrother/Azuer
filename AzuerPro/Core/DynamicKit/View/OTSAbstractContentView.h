//
//  OTSAbstractContentView.h
//  OneStoreLight
//
//  Created by Jerry on 2016/12/27.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTSAbstractContentView : UIView {
    NSIndexPath *_indexPath;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
