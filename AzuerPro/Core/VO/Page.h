//
//  Page.h
//  OneStoreMain
//
//  Created by Aimy on 8/26/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OTSKit/OTSKit.h>

@interface Page : OTSModel

@property (strong, nonatomic) NSNumber *currentPage;
@property (strong, nonatomic) NSNumber *endIndex;
@property (strong, nonatomic) NSNumber *startIndex;
@property (strong, nonatomic) NSMutableArray *objList;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *totalSize;

@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSMutableArray *resultList;
@property (assign, nonatomic) NSInteger count;
@end
