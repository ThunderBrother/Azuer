//
//  OTSTableViewCell.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-1.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSTableViewCell.h"
#import "OTSFuncDefine.h"
#import "NSObject+Notification.h"

@implementation OTSTableViewCell

- (void)setFrame:(CGRect)frame {
    CGRect rc = CGRectMake(frame.origin.x + self.cellEdgeInsets.left, frame.origin.y + self.cellEdgeInsets.top, frame.size.width - self.cellEdgeInsets.left - self.cellEdgeInsets.right, frame.size.height - self.cellEdgeInsets.top - self.cellEdgeInsets.bottom);
    [super setFrame:rc];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)updateWithCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    
}

+ (CGFloat)heightForCellData:(id)aData {
    return 0;
}

+ (CGFloat)heightForCellData:(id)aData atIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

//这个方法如果滥用，会很恐怖。。。所以不能公开
- (UITableView *)__getTableView {
    static int level = 10;
    UITableView *tableView = nil;
    
    UIView *view = self.superview;
    for (int i = 0; i < level; i++) {
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
            break;
        }
        
        if (view.superview) {
            view = view.superview;
        }
        else {
            break;
        }
    }
    
    return tableView;
}

- (NSIndexPath *)indexPath {
    return _indexPath ?: [[self __getTableView] indexPathForCell:self];
}

@end
