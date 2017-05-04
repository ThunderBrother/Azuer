//
//  OTSTableViewHeaderFooterView.m
//  OneStoreFramework
//
//  Created by Aimy on 9/26/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSTableViewHeaderFooterView.h"
#import "NSObject+Notification.h"
#import "AZFuncDefine.h"

@implementation OTSTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGRect rc = CGRectMake(frame.origin.x + self.cellEdgeInsets.left, frame.origin.y + self.cellEdgeInsets.top, frame.size.width - self.cellEdgeInsets.left - self.cellEdgeInsets.right, frame.size.height - self.cellEdgeInsets.top - self.cellEdgeInsets.bottom);
    [super setFrame:rc];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)updateWithCellData:(id)aData atSectionIndex:(NSInteger)section {
    
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [self updateWithCellData:aData atSectionIndex:indexPath.section];
}

+ (CGFloat)heightForCellData:(id)aData atSectionIndex:(NSUInteger)section {
    return 0;
}

+ (CGSize)sizeForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UI_CURRENT_SCREEN_WIDTH, [self heightForCellData:aData atSectionIndex:indexPath.section]);
}

- (void)dealloc {
    [self unobserveAllNotifications];
}

@end
