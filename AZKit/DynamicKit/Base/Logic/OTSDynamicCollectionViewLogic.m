//
//  OTSDynamicCollectionViewLogic.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicCollectionViewLogic.h"
#import "Aspects.h"
#import "NSArray+safe.h"
#import "OTSIntent.h"

#import "OTSDynamicKitProtocol.h"
#import "OTSCollectionViewCell.h"
#import "OTSCollectionReusableView.h"
#import "NSMutableDictionary+safe.h"
#import "NSMutableArray+safe.h"
#import <SDWebImagePrefetcher.h>
#import "OTSReachability.h"
#import "OTSNotificationDefine.h"
#import "OTSConvertImageString.h"
#import "NSObject+Notification.h"

@implementation OTSDynamicCollectionViewLogic

- (instancetype)initWithOwner:(id)owner {
    if (self = [super initWithOwner:owner]) {
        [self observeNotification:NotificationNetworkStatusChange];
    }
    return self;
}

- (void)setSections:(NSArray<OTSCollectionViewSection *> *)sections {
    _sections = sections;
    if ([OTSReachability sharedInstance].currentNetStatus == kConnectToWifi) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSMutableArray *prefetcherImageUrlArray = [NSMutableArray array];
            for (OTSCollectionViewSection *sectionVM in _sections) {
                for (OTSCollectionViewItem *item  in sectionVM.items) {
                    if (!item.imageAttribute.imageURL) {
                        continue;
                    }
                    NSString * convertedURL = item.imageAttribute.imageURL;
                    if (!CGSizeEqualToSize([item.imageAttribute preferredSize], CGSizeZero)) {
                        convertedURL = [OTSConvertImageString convertPicURL:item.imageAttribute.imageURL toSize:CGSizeMake(item.imageAttribute.preferredWidth, item.imageAttribute.preferredHeight)];
                    }
                    [prefetcherImageUrlArray safeAddObject:[NSURL URLWithString:convertedURL]];
                }
            }
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:prefetcherImageUrlArray progress:nil completed:nil];
        });
    }
}

- (void)handleNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:NotificationNetworkStatusChange]){
        if ([OTSReachability sharedInstance].currentNetStatus != kConnectToWifi) {
            [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
        }
    }
}

- (OTSCollectionViewItem*)itemAtIndexPath:(NSIndexPath*)indexPath {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:indexPath.section];
    if (indexPath.item == -1) {
        return sectionData.header;
    } else if(indexPath.item == -2) {
        return sectionData.footer;
    } else {
        return [sectionData.items safeObjectAtIndex:indexPath.item];
    }
}

@end

@implementation OTSDynamicCollectionViewLogic (CollectionViewDelegate)

#pragma mark - OTSDynamicLogicProtocol
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OTSCollectionViewItem *item = [self itemAtIndexPath:indexPath];
    OTSIntentModel *intentModel = item.intentModel;
    [self didexecuteIntentModel:intentModel];
}

- (void)didexecuteIntentModel:(OTSIntentModel *)intentModel {
    if (intentModel) {
        UIViewController *source = nil;
        if ([self->_owner isKindOfClass:[UIViewController class]]) {
            source = self->_owner;
        }
        OTSIntent *intent = [OTSIntent intentWithItem:intentModel source:source context:nil];
        [intent submit];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:indexPath.section];
    OTSCollectionViewItem *item = [sectionData.items safeObjectAtIndex:indexPath.row];
    
    CGFloat preferredWidth = item.contentAttribute.preferredWidth;
    CGFloat preferredHeight = item.contentAttribute.preferredHeight;
    
    if (!preferredHeight) {
        NSString *cellIdentifier = item.cellIdentifier;
        if (cellIdentifier) {
            Class cellClass = NSClassFromString(cellIdentifier);
            if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                CGSize aSize = [cellClass sizeForCellData:item atIndexPath:indexPath];
                preferredWidth = aSize.width;
                preferredHeight = aSize.height;
            }
        }
    }
    
    if (preferredWidth == 0) {
        preferredWidth = UI_REFRENCE_WIDTH;
    }
    
    return CGSizeMake(preferredWidth, preferredHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    return sectionData.insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    return sectionData.vSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    return sectionData.hSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSCollectionViewItem *item = sectionData.header;
    
    CGFloat preferredWidth = item.contentAttribute.preferredWidth;
    CGFloat preferredHeight = item.contentAttribute.preferredHeight;
    
    if (!preferredHeight) {
        NSString *cellIdentifier = item.cellIdentifier;
        if (cellIdentifier) {
            Class cellClass = NSClassFromString(cellIdentifier);
            if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                CGSize aSize = [cellClass sizeForCellData:item atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                preferredWidth = aSize.width;
                preferredHeight = aSize.height;
            }
        }
    }
    
    if (preferredWidth == 0) {
        preferredWidth = UI_REFRENCE_WIDTH;
    }
    return CGSizeMake(preferredWidth, preferredHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSCollectionViewItem *item = sectionData.footer;
    
    CGFloat preferredWidth = item.contentAttribute.preferredWidth;
    CGFloat preferredHeight = item.contentAttribute.preferredHeight;
    
    if (!preferredHeight) {
        NSString *cellIdentifier = item.cellIdentifier;
        if (cellIdentifier) {
            Class cellClass = NSClassFromString(cellIdentifier);
            if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                CGSize aSize = [cellClass sizeForCellData:item atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                preferredWidth = aSize.width;
                preferredHeight = aSize.height;
            }
        }
    }
    
    if (preferredWidth == 0) {
        preferredWidth = UI_REFRENCE_WIDTH;
    }
    
    return CGSizeMake(preferredWidth, preferredHeight);
}

@end

@implementation OTSDynamicCollectionViewLogic (CollectionViewDataSource)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    return sectionData.itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OTSCollectionViewSection *section = [self.sections safeObjectAtIndex:indexPath.section];
    id cellData = nil;
    NSString *cellIdentifier = nil;
    
    if (section.overlapped) {
        cellData = section.items;
        cellIdentifier = section.items.firstObject.cellIdentifier;
    } else {
        cellData = [section.items safeObjectAtIndex:indexPath.row];
        cellIdentifier = ((OTSCollectionViewItem*)cellData).cellIdentifier;
    }
    
    if (!cellIdentifier) {
        cellIdentifier = @"OTSCollectionViewCell";
    }
    
    UICollectionViewCell<OTSDynamicContentViewProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSParameterAssert([cell conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]);
    cell.delegate = self;
    
    BOOL isCellUseContentView = false;
    
    if ([cell isMemberOfClass:[OTSCollectionViewCell class]]) {
        Class contentClass = NSClassFromString(cellIdentifier);
        if ([contentClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
            UIView<OTSDynamicContentViewProtocol> *contentView = cell.contentView.subviews.firstObject;
            if (![contentView isMemberOfClass:contentClass]) {
                [contentView removeFromSuperview];
                contentView = [[contentClass alloc] initWithFrame:cell.bounds];
                contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [cell.contentView insertSubview:contentView atIndex:0];
            }
            contentView.delegate = self;
            [contentView updateWithCellData:cellData atIndexPath:indexPath];
            isCellUseContentView = true;
        }
    }
    
    if (!isCellUseContentView) {
        [cell updateWithCellData:cellData atIndexPath:indexPath];
    }
    
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    OTSCollectionViewSection *section = [self.sections safeObjectAtIndex:indexPath.section];
    OTSCollectionViewItem *targetData = nil;
    
    NSInteger index = indexPath.item;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        targetData = section.header;
        index = -1;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        targetData = section.footer;
        index = -2;
    }
    
    if (!targetData) {
        return nil;
    }
    
    NSIndexPath *transformedIndexPath = [NSIndexPath indexPathForItem:index inSection:indexPath.section];
    
    UICollectionReusableView<OTSDynamicContentViewProtocol> *supplementaryElement = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:targetData.cellIdentifier forIndexPath:indexPath];
    
    NSParameterAssert([supplementaryElement conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]);
    supplementaryElement.delegate = self;
    
    BOOL isCellUseContentView = false;
    
    if ([supplementaryElement isMemberOfClass:[OTSCollectionReusableView class]]) {
        Class contentClass = NSClassFromString(targetData.cellIdentifier);
        if ([contentClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
            UIView<OTSDynamicContentViewProtocol> *contentView = supplementaryElement.subviews.firstObject;
            if (![contentView isMemberOfClass:contentClass]) {
                [contentView removeFromSuperview];
                contentView = [[contentClass alloc] initWithFrame:supplementaryElement.bounds];
                contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [supplementaryElement insertSubview:contentView atIndex:0];
            }
            contentView.delegate = self;
            [contentView updateWithCellData:targetData atIndexPath:transformedIndexPath];
            isCellUseContentView = true;
        }
    }
    
    if (!isCellUseContentView) {
        [supplementaryElement updateWithCellData:targetData atIndexPath:transformedIndexPath];
    }

    
    return supplementaryElement;
}

@end
