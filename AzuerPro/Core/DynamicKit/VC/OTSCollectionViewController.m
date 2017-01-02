//
//  OTSCollectionViewController.m
//  OneStoreLight
//
//  Created by Jerry on 2016/11/4.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//
#import <OTSKit/OTSKit.h>
#import "OTSCollectionViewController.h"

@implementation OTSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupViews];
    [self __setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray<NSString*>*)xibHeaderClassNames {
    return nil;
}

- (NSArray<NSString*>*)codeHeaderClassNames {
    return nil;
}

- (NSArray<NSString*>*)xibFooterClassNames {
    return nil;
}

- (NSArray<NSString*>*)codeFooterClassNames {
    return nil;
}

#pragma mark - OTSDynamicLogicProtocol
- (Class) logicClass {
    return [OTSDynamicCollectionViewLogic class];
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
            [self.collectionView reloadData];
            break;
            
        case OTSDataSourceActionInsertSection:
            if (data) {
                [self.collectionView insertSections:data];
            }
            break;
        case OTSDataSourceActionDeleteSection:
            if (data) {
                [self.collectionView deleteSections:data];
            }
            break;
        case OTSDataSourceActionReloadSection:
            if (data) {
                [self.collectionView reloadSections:data];
            }
            break;
            
        case OTSDataSourceActionInsertRow:
            if (data) {
                [self.collectionView insertItemsAtIndexPaths:data];
            }
            break;
        case OTSDataSourceActionDeleteRow:
            if (data) {
                [self.collectionView deleteItemsAtIndexPaths:data];
            }
            break;
        case OTSDataSourceActionReloadRow:
            if (data) {
                [self.collectionView reloadItemsAtIndexPaths:data];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Setter & Getter
- (UICollectionView*)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        _collectionView.alwaysBounceVertical = true;
        
        [_collectionView registerClass:NSClassFromString(@"OTSCollectionViewCell") forCellWithReuseIdentifier:@"OTSCollectionViewCell"];
        
        
        NSArray *xibCellClassArray = [self xibCellClassNames];
        for (NSString *cellClassName in xibCellClassArray) {
            [_collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellWithReuseIdentifier:cellClassName];
        }
        
        NSArray *codeCellClassArray = [self codeCellClassNames];
        for (NSString *codeClassName in codeCellClassArray) {
            [_collectionView registerClass:NSClassFromString(codeClassName) forCellWithReuseIdentifier:codeClassName];
        }
        
        NSArray *xibHeaderClassArray = [self xibHeaderClassNames];
        for (NSString *cellClassName in xibHeaderClassArray) {
            [_collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellClassName];
        }
        
        NSArray *codeHeaderClassArray = [self codeHeaderClassNames];
        for (NSString *codeClassName in codeHeaderClassArray) {
            [_collectionView registerClass:NSClassFromString(codeClassName) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:codeClassName];
        }
        
        NSArray *xibFooterClassArray = [self xibFooterClassNames];
        for (NSString *cellClassName in xibFooterClassArray) {
            [_collectionView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellClassName];
        }
        
        NSArray *codeFooterClassArray = [self codeFooterClassNames];
        for (NSString *codeClassName in codeFooterClassArray) {
            [_collectionView registerClass:NSClassFromString(codeClassName) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:codeClassName];
        }
        
        _collectionView.delegate = self.logic;
        _collectionView.dataSource = self.logic;
        
    }
    return _collectionView;
}

- (__kindof OTSDynamicCollectionViewLogic*)logic {
    if (!_logic) {
        Class logicClass = [self logicClass];
        NSAssert([logicClass isSubclassOfClass:[OTSDynamicCollectionViewLogic class]], @"logic class %@ is not a subclass of OTSDynamicCollectionViewLogic", logicClass);
        _logic = [[logicClass alloc] initWithOwner:self];
    }
    return _logic;
}

- (UICollectionViewFlowLayout*)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

#pragma mark - Private
- (void)__setupViews {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    [self.view addSubview:self.collectionView];
    self.scrollView = self.collectionView;
}

- (void)__setupObserver {
    WEAK_SELF;
    [OTSObserve(self.collectionView.panGestureRecognizer, @"state"){
        STRONG_SELF;
        NSInteger state = [change[NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateBegan) {
            [self.view endEditing:true];
        }
    }];
    
    [OTSObserve(self.logic, @"intentModel"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        
        OTSIntentModel *anItem = change[NSKeyValueChangeNewKey];
        [self handleIntentModel:anItem];
    }];
    
    [OTSObserve(self.logic, @"sections"){
        STRONG_SELF;
        [self handleDataSourceAction:OTSDataSourceActionReload params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"insertedSectionIndexSet"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionInsertSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"deletedSectionIndexSet"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionDeleteSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"reloadedSectionIndexSet"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionReloadSection params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"insertedRowsIndexPathes"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionInsertRow params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"deletedRowsIndexPathes"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionDeleteRow params:change[NSKeyValueChangeNewKey]];
    }];
    
    [OTSObserve(self.logic, @"reloadedRowsIndexPathes"){
        STRONG_SELF;
        OTSNullReturn(NSKeyValueChangeNewKey);
        [self handleDataSourceAction:OTSDataSourceActionReloadRow params:change[NSKeyValueChangeNewKey]];
    }];
}

@end
