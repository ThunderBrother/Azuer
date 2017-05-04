//
//  OTSTableViewController.h
//  OneStoreLight
//
//  Created by Jerry on 2016/11/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <AZKit/AZKit.h>
#import "OTSDynamicTableViewLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTSTableViewController : UIViewController<OTSDynamicVCProtocol>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) __kindof OTSDynamicTableViewLogic *logic;

- (NSArray<NSString*>*)xibHeaderFooterClassNames;
- (NSArray<NSString*>*)codeHeaderFooterClassNames;

- (UITableViewStyle) tableViewStyle;//default is UITableViewStyleGrouped

@end

NS_ASSUME_NONNULL_END
