//
//  OTSDynamicTableViewLogic.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/7.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSDynamicTableViewLogic.h"
#import "OTSDynamicKitProtocol.h"
#import "OTSTableViewSection.h"
#import "NSArray+safe.h"
#import "AZFuncDefine.h"
#import "UIScrollView+PullRefresh.h"

#import "OTSTableViewHeaderFooterView.h"
#import "UIViewController+RefreshAction.h"
#import "OTSTableViewCell.h"

#import "NSObject+Runtime.h"
#import "OTSIntent.h"


@implementation OTSDynamicTableViewLogic

- (OTSTableViewItem*)itemAtIndexPath:(NSIndexPath *)indexPath {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:indexPath.section];
    if (indexPath.item == -1) {
        return sectionData.header;
    } else if(indexPath.item == -2) {
        return sectionData.footer;
    } else {
        return [sectionData.rows safeObjectAtIndex:indexPath.row];
    }
}

@end

@implementation OTSDynamicTableViewLogic (TableViewDelegate)

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSTableViewItem *header = sectionData.header;
    if (!header) {
        return nil;
    }
    UITableViewHeaderFooterView<OTSDynamicContentViewProtocol> *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header.cellIdentifier];
    
    NSParameterAssert([headerFooterView conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]);
    headerFooterView.delegate = self;
    
    BOOL isHeaderUseContentView = false;
    NSIndexPath *transformedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    
    if ([headerFooterView isMemberOfClass:[OTSTableViewHeaderFooterView class]]) {
        Class contentClass = NSClassFromString(header.cellIdentifier);
        if ([contentClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
            UIView<OTSDynamicContentViewProtocol> *contentView = headerFooterView.contentView.subviews.firstObject;
            if (![contentView isMemberOfClass:contentClass]) {
                [contentView removeFromSuperview];
                contentView = [[contentClass alloc] initWithFrame:headerFooterView.bounds];
                contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [headerFooterView.contentView insertSubview:contentView atIndex:0];
            }
            contentView.delegate = self;
            [contentView updateWithCellData:header atIndexPath:transformedIndexPath];
            isHeaderUseContentView = true;
        }
    }
    
    if (!isHeaderUseContentView) {
        [headerFooterView updateWithCellData:header atIndexPath:transformedIndexPath];
    }
    
    return headerFooterView;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSTableViewItem *footer = sectionData.footer;
    if (!footer) {
        return nil;
    }
    UITableViewHeaderFooterView<OTSDynamicContentViewProtocol> *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footer.cellIdentifier];
    
    NSParameterAssert([headerFooterView conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]);
    headerFooterView.delegate = self;
    
    BOOL isFooterUseContentView = false;
    NSIndexPath *transformedIndexPath = [NSIndexPath indexPathForRow:-2 inSection:section];
    
    if ([headerFooterView isMemberOfClass:[OTSTableViewHeaderFooterView class]]) {
        Class contentClass = NSClassFromString(footer.cellIdentifier);
        if ([contentClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
            UIView<OTSDynamicContentViewProtocol> *contentView = headerFooterView.contentView.subviews.firstObject;
            if (![contentView isMemberOfClass:contentClass]) {
                [contentView removeFromSuperview];
                contentView = [[contentClass alloc] initWithFrame:headerFooterView.bounds];
                contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [headerFooterView.contentView insertSubview:contentView atIndex:0];
            }
            contentView.delegate = self;
            [contentView updateWithCellData:footer atIndexPath:transformedIndexPath];
            isFooterUseContentView = true;
        }
    }
    
    if (!isFooterUseContentView) {
        [headerFooterView updateWithCellData:footer atIndexPath:transformedIndexPath];
    }
    
    return headerFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OTSTableViewItem *item = [self itemAtIndexPath:indexPath];
    CGFloat cellHeight = item.contentAttribute.preferredHeight;
    
    if (!cellHeight) {
        NSString *cellIdentifier = item.cellIdentifier;
        if (cellIdentifier) {
            Class cellClass = NSClassFromString(cellIdentifier);
            if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                cellHeight = [cellClass sizeForCellData:item atIndexPath:indexPath].height;
            }
        }
    }
    
    if (!cellHeight) {
        cellHeight = 44.0;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSTableViewItem *header = sectionData.header;
    if (header) {
        CGFloat headerHeight = header.contentAttribute.preferredHeight;
        if (!headerHeight) {
            NSString *cellIdentifier = header.cellIdentifier;
            if (cellIdentifier) {
                Class cellClass = NSClassFromString(cellIdentifier);
                
                if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                    headerHeight = [cellClass sizeForCellData:header atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].height;
                }
            }
        }
        if (!headerHeight) {
            headerHeight = 30.0;
        }
        return headerHeight;
    } else {
        if (tableView.style == UITableViewStylePlain) {
            return 0.1f;
        } else {
            if (section > 0) {
                OTSTableViewSection *lastSectionData = [self.sections safeObjectAtIndex:section - 1];
                return lastSectionData.footer ? UI_DEFAULT_MARGIN : .1;

            } else {
                return .1;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    OTSTableViewItem *footer = sectionData.footer;
    if (footer) {
        CGFloat footerHeight = footer.contentAttribute.preferredHeight;
        
        if (!footerHeight) {
            NSString *cellIdentifier = footer.cellIdentifier;
            if (cellIdentifier) {
                Class cellClass = NSClassFromString(cellIdentifier);
                
                if ([cellClass conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]) {
                    footerHeight = [cellClass sizeForCellData:footer atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].height;
                }
            }
        }
        
        if (!footerHeight) {
            footerHeight = 30.0;
        }
        return footerHeight;
    } else {
        if (tableView.style == UITableViewStylePlain) {
            return 0.1f;
        } else {
            OTSTableViewSection *nextSection = [self.sections safeObjectAtIndex:section + 1];
            if (nextSection.header) {
                return .1f;
            }
            
            if (tableView.refreshFooter && section == self.sections.count - 1) {
                return .1f;
            }
            return UI_DEFAULT_MARGIN;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OTSTableViewItem *item = [self itemAtIndexPath:indexPath];
  
    if (item.appAction != OTSViewActionNone) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
            [tableView beginUpdates];
        }
        if (item.appAction & OTSViewActionToggle) {
            
            item.selected = !item.selected;
            self.actionIndexPath = indexPath;
            if (item.appAction & OTSViewActionReloadSection) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        } else if(item.appAction & OTSViewActionGroupToggle && !item.selected) {
            
            self.actionIndexPath = indexPath;
            OTSTableViewSection *aSection = [self.sections safeObjectAtIndex:indexPath.section];
            
            for (int i = 0; i < aSection.rows.count; i++) {
                OTSTableViewItem *anItem = aSection.rows[i];
                if (!anItem.blockAutoValueChange) {
                    anItem.selected = anItem == item;
                }
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else if(item.appAction & OTSViewActionAllToggle && !item.selected) {
            
            self.actionIndexPath = indexPath;
            for (OTSTableViewSection *aSection in self.sections) {
                for (OTSTableViewItem *anItem in aSection.rows) {
                    anItem.selected = anItem == item;
                }
            }
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.sections.count)] withRowAnimation:UITableViewRowAnimationNone];
        }
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
            [tableView endUpdates];
        }
    }
    
    [self didSelectItemAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - OTSDynamicLogicProtocol
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OTSTableViewItem *item = [self itemAtIndexPath:indexPath];
    
    OTSIntentModel *intentModel = item.intentModel;
    if (!intentModel) {
        OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:indexPath.section];
        intentModel = sectionData.intentModel;
    }
    
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

@end

@implementation OTSDynamicTableViewLogic (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OTSTableViewSection *sectionData = [self.sections safeObjectAtIndex:section];
    return sectionData.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OTSTableViewItem *item = [self itemAtIndexPath:indexPath];
    
    NSString *cellIdentifier = item.cellIdentifier;
    if (!cellIdentifier) {
        cellIdentifier = @"OTSTableViewCell";
    }
    UITableViewCell<OTSDynamicContentViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSParameterAssert([cell conformsToProtocol:@protocol(OTSDynamicContentViewProtocol)]);
    cell.delegate = self;
    
    BOOL isCellUseContentView = false;
    
    if ([cell isMemberOfClass:[OTSTableViewCell class]]) {
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
            [contentView updateWithCellData:item atIndexPath:indexPath];
            isCellUseContentView = true;
        }
    }
    
    if (!isCellUseContentView) {
        [cell updateWithCellData:item atIndexPath:indexPath];
    }
    
    if (item.selectionStyle != OTSTableViewSelectionStyleInherited) {
        if (item.selectionStyle == OTSTableViewSelectionStyleNone) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if(item.selectionStyle == OTSTableViewSelectionStyleDefault) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    
    if (!item.disabled) {
        cell.userInteractionEnabled = true;
        cell.contentView.alpha = 1.0;
    } else {
        cell.userInteractionEnabled = false;
        cell.contentView.alpha = .5;
    }
    
    return cell;
}

@end

@implementation OTSDynamicTableViewLogic (TextFieldDelegate)

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [textField objc_getAssociatedObject:@"ots_indexPath"];
    if (indexPath != nil) {
        OTSTableViewItem *item = [self itemAtIndexPath:indexPath];
        item.valueString = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.inputView) {
        return false;
    }
    return true;
}

@end
