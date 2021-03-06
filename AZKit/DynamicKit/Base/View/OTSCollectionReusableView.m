//
//  OTSCollectionReusableView.m
//  OneStoreFramework
//
//  Created by Aimy on 9/16/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSCollectionReusableView.h"
//category
#import "NSObject+Notification.h"

@implementation OTSCollectionReusableView

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    NSString *className = NSStringFromClass([self class]);
    return [UINib nibWithNibName:className bundle:nil];
}

- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [self updateWithCellData:aData atSectionIndex:indexPath.section];
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    return [self sizeForCellData:aData];
}

+ (CGSize)sizeForCellData:(id)aData {
    return CGSizeZero;
}

- (void)dealloc {
    [self unobserveAllNotifications];
}


@end
