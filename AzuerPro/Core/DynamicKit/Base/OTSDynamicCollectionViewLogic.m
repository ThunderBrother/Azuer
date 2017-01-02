//
//  OTSDynamicCollectionViewLogic.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicCollectionViewLogic.h"
#import "Aspects.h"

@implementation OTSDynamicCollectionViewLogic

- (OTSCollectionViewItem*)itemAtIndexPath:(NSIndexPath*)indexPath {
    OTSCollectionViewSection *sectionData = [self.sections safeObjectAtIndex:indexPath.section];
    return [sectionData.items safeObjectAtIndex:indexPath.row];
}

@end

@implementation OTSDynamicCollectionViewLogic (CollectionViewDelegate)

- (void)__didSelectCollectionViewItem:(OTSCollectionViewItem*)item {
    OTSIntentModel *intentModel = item.intentModel;
    if (intentModel) {
        OTSIntent *intent = [OTSIntent intentWithItem:intentModel source:nil context:nil];
        
        [intent submit];
    }
}

- (void)didSelectHeaderAtSection:(NSInteger)section {
    OTSCollectionViewSection *aSection = [self.sections safeObjectAtIndex:section];
    OTSCollectionViewItem *header = aSection.header;
    [self __didSelectCollectionViewItem:header];
}

- (void)didSelectFooterAtSection:(NSInteger)section {
    OTSCollectionViewSection *aSection = [self.sections safeObjectAtIndex:section];
    OTSCollectionViewItem *footer = aSection.footer;
    [self __didSelectCollectionViewItem:footer];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OTSCollectionViewItem *item = [self itemAtIndexPath:indexPath];
    [self __didSelectCollectionViewItem:item];
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
            CGSize aSize = [cellClass sizeForCellData:item];
            preferredWidth = aSize.width;
            preferredHeight = aSize.height;
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
    
    OTSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateWithCellData:cellData atIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    OTSCollectionViewSection *section = [self.sections safeObjectAtIndex:indexPath.section];
    OTSCollectionViewItem *targetData = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        targetData = section.header;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        targetData = section.footer;
    }
    
    if (!targetData) {
        return nil;
    }
    OTSCollectionReusableView *supplementaryElement = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:targetData.cellIdentifier forIndexPath:indexPath];
    supplementaryElement.delegate = self;
    [supplementaryElement updateWithCellData:targetData atSectionIndex:indexPath.section];
    return supplementaryElement;
}

@end
