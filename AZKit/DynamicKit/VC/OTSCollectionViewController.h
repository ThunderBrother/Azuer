//
//  OTSCollectionViewController.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/4.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTSDynamicCollectionViewLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSCollectionViewController : UIViewController<OTSDynamicVCProtocol>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) __kindof OTSDynamicCollectionViewLogic *logic;

- (NSArray<NSString*>* _Nullable)xibHeaderClassNames;
- (NSArray<NSString*>* _Nullable)codeHeaderClassNames;

- (NSArray<NSString*>* _Nullable)xibFooterClassNames;
- (NSArray<NSString*>* _Nullable)codeFooterClassNames;

@end

NS_ASSUME_NONNULL_END
