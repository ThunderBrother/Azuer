//
//  UINavigationItem+Custom.h
//  OneStoreLight
//
//  Created by Jerry on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OTSNavigationItemDelegate <NSObject>

@optional
- (void)searchBarDidSubmit:(UISearchBar *)searchBar;
- (void)didPressBackButtonItem:(id)sender;
- (void)didCancelSearch:(UISearchBar *)sender;
- (void)searchBarTextDidChange:(NSString *)searchText;
@end

@interface UINavigationItem (Make)

@property (weak, nonatomic, nullable) __kindof UIViewController *delegate;

- (void)makeForLogoSearchUI; //首页
- (void)makeForSearchUI; //搜索图标
- (void)makeForSearchAndCartUI; //搜索和购物车图标

- (void)makeForCustomBackButtonUI;
- (void)makeForCustomBackButtonAndHomeUI;

- (void)makeForHomeAndSearchAndCartUI; //首页、搜索、购物车

- (void)makeForSearchResultListUI; //展开的searchbar和购物车
- (void)makeForSearchHistoryUI; //searchbar,cancel
- (void)makeForAccountUI; //个人中心
- (void)setSearchBarText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
