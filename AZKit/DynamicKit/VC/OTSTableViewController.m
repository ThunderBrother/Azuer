//
//  OTSTableViewController.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/2.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTableViewController.h"

@interface OTSTableViewController ()

@end

@implementation OTSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupViews];
    [self __setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray<NSString*>*)xibHeaderFooterClassNames {
    return nil;
}

- (NSArray<NSString*>*)codeHeaderFooterClassNames {
    return nil;
}

- (UITableViewStyle) tableViewStyle {
    return UITableViewStyleGrouped;
}

#pragma mark - OTSDynamicVCProtocol
- (Class) logicClass {
    return [OTSDynamicTableViewLogic class];
}

- (NSArray<NSString*>*)xibCellClassNames {
    return nil;
}

- (NSArray<NSString*>*)codeCellClassNames {
    return nil;
}

- (void)handleIntentModel:(OTSIntentModel*)intentModel {
    OTSIntent *anIntent = [OTSIntent intentWithItem:intentModel source:self context:nil];
    [anIntent submit];
}

- (void)handleDataSourceAction:(OTSDataSourceAction)action
                        params:(id)data {
    switch (action) {
        case OTSDataSourceActionReload:
            [self.tableView reloadData];
            break;
            
        case OTSDataSourceActionInsertSection:
            if (data) {
                [self.tableView insertSections:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case OTSDataSourceActionDeleteSection:
            if (data) {
                [self.tableView deleteSections:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case OTSDataSourceActionReloadSection:
            if (data) {
                [self.tableView reloadSections:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
            
        case OTSDataSourceActionInsertRow:
            if (data) {
                [self.tableView insertRowsAtIndexPaths:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case OTSDataSourceActionDeleteRow:
            if (data) {
                [self.tableView deleteRowsAtIndexPaths:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
        case OTSDataSourceActionReloadRow:
            if (data) {
                [self.tableView reloadRowsAtIndexPaths:data withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Setter & Getter
- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:[self tableViewStyle]];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        Class defaultTableViewCellClass = [OTSTableViewCell class];
        [_tableView registerClass:defaultTableViewCellClass forCellReuseIdentifier:@"OTSTableViewCell"];
        
        NSArray *xibCellClassArray = [self xibCellClassNames];
        for (NSString *cellClassName in xibCellClassArray) {
            [_tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
        }
        
        NSArray *codeCellClassArray = [self codeCellClassNames];
        for (NSString *codeClassName in codeCellClassArray) {
            Class cellClass = NSClassFromString(codeClassName);
            [_tableView registerClass:([cellClass isSubclassOfClass:defaultTableViewCellClass] ? cellClass : defaultTableViewCellClass)  forCellReuseIdentifier:codeClassName];
        }
        
        NSArray *xibHeaderFooterClassArray = [self xibHeaderFooterClassNames];
        for (NSString *cellClassName in xibHeaderFooterClassArray) {
            [_tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forHeaderFooterViewReuseIdentifier:cellClassName];
        }
        
        NSArray *codeHeaderFooterClassArray = [self codeHeaderFooterClassNames];
        Class defaultHeaderFooterClass = [OTSTableViewHeaderFooterView class];
        
        for (NSString *codeClassName in codeHeaderFooterClassArray) {
            Class headerFooterClass = NSClassFromString(codeClassName);
            
            [_tableView registerClass:([headerFooterClass isSubclassOfClass:defaultHeaderFooterClass] ? headerFooterClass : defaultHeaderFooterClass)forHeaderFooterViewReuseIdentifier:codeClassName];
        }
        
        _tableView.delegate = self.logic;
        _tableView.dataSource = self.logic;
    }
    return _tableView;
}

- (__kindof OTSDynamicTableViewLogic*)logic {
    if (!_logic) {
        Class logicClass = [self logicClass];
        NSAssert([logicClass isSubclassOfClass:[OTSDynamicTableViewLogic class]], @"logic class %@ is not a subclass of OTSDynamicTableViewLogic", logicClass);
        _logic = [[logicClass alloc] initWithOwner:self];
    }
    return _logic;
}

#pragma mark - Private
- (void)__setupViews {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    [self.view addSubview:self.tableView];
    self.scrollView = self.tableView;
}

- (void)__setupObserver {
    WEAK_SELF;
    [OTSObserve(self.tableView.panGestureRecognizer, state) {
        NSInteger state = [change[NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateBegan) {
            [OTSSharedKeyWindow endEditing:true];
        }
    }];
    
    [OTSObserve(self.logic, intentModel) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        
        OTSIntentModel *anItem = change[NSKeyValueChangeNewKey];
        [self handleIntentModel:anItem];
    }];
    
    [OTSObserve(self.logic, sections) {
        STRONG_SELF;
        [self handleDataSourceAction:OTSDataSourceActionReload params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, insertedSectionIndexSet) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionInsertSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, deletedSectionIndexSet) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionDeleteSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, reloadedSectionIndexSet) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionReloadSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, insertedRowsIndexPathes) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionInsertRow params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, deletedRowsIndexPathes) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionDeleteRow params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, reloadedRowsIndexPathes) {
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionReloadRow params:change[NSKeyValueChangeNewKey]];
    }];
}

@end
