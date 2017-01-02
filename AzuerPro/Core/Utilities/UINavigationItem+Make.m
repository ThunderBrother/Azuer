//
//  UINavigationItem+Custom.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/30.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "UINavigationItem+Make.h"
#import <OTSKit/OTSKit.h>
#import "NSObject+FBKVOController.h"

static NSInteger historySearchBarTag = 1000;

@interface UINavigationItem ()<UISearchBarDelegate>

@end

@implementation UINavigationItem (Make)

#pragma mark - PublicAPI
- (void)makeForSearchUI {
    self.rightBarButtonItem = [self __searchItem];
    UISearchBar *searchBar = [self __searchBar];
    [self objc_setAssociatedObject:@"ots_searchbar" value:searchBar policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)makeForSearchAndCartUI {
    UIBarButtonItem *cartItem = [self __cartItem];
    UIBarButtonItem *searchItem = [self __searchItem];
    [searchItem setImageInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    self.rightBarButtonItems = @[cartItem, searchItem];
    UISearchBar *searchBar = [self __searchBar];
    [self objc_setAssociatedObject:@"ots_searchbar" value:searchBar policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)makeForCustomBackButtonUI {
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressBackButtonItem:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    
    self.leftBarButtonItems = @[negativeSeperator, backItem];
}

- (void)makeForCustomBackButtonAndHomeUI {
    [self makeForCustomBackButtonUI];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 30, 30);
    [homeButton setImageEdgeInsets:UIEdgeInsetsMake(-1, -10, 1, 10)];
    [homeButton setImage:[UIImage imageNamed:@"navigation_home"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(__gotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    
    NSMutableArray *leftItems = [NSMutableArray array];
    if (self.leftBarButtonItems) {
        [leftItems addObjectsFromArray:self.leftBarButtonItems];
    }
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -32;
    [leftItems addObject:negativeSeperator];
    [leftItems addObject:homeItem];
    self.leftBarButtonItems = leftItems;
}

- (void)makeForHomeAndSearchAndCartUI {
    [self makeForCustomBackButtonAndHomeUI];
    
    UIBarButtonItem *cartItem = [self __cartItem];
    UIBarButtonItem *searchItem = [self __searchItem];
    
    [searchItem setImageInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    self.rightBarButtonItems = @[cartItem, searchItem];
    
    UISearchBar *searchBar = [self __searchBar];
    [self objc_setAssociatedObject:@"ots_searchbar" value:searchBar policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)makeForLogoSearchUI {
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_logo"]];
    self.titleView = logoImageView;
    
    UIButton *cityButton = [[UIButton alloc] init];
    [cityButton setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateNormal];
    [cityButton setTitle:@"Shanghai" forState:UIControlStateNormal];
    [cityButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [cityButton setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    cityButton.titleLabel.font = OTSSmallFont;
    [cityButton sizeToFit];
    
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:cityButton];
    self.leftBarButtonItem = cityItem;
    
    [self makeForSearchUI];
}

- (void)makeForSearchResultListUI {
    [self makeForCustomBackButtonAndHomeUI];
    self.rightBarButtonItems = @[[self __cartItem]];
    UISearchBar *searchBar = [self objc_getAssociatedObject:@"ots_searchbar"];
    if (!searchBar) {
        searchBar = [self __searchBar];
        [self objc_setAssociatedObject:@"ots_searchbar" value:searchBar policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    self.titleView = searchBar;
    [self objc_removeAssociatedObjectForPropertyName:@"ots_rightItems"];
    [searchBar resignFirstResponder];
}

- (void)makeForSearchHistoryUI {
    UISearchBar *searchBar = [self objc_getAssociatedObject:@"ots_searchbar"];
    if (!searchBar) {
        searchBar = [self __searchBar];
        [searchBar setShowsCancelButton:YES animated:YES];
        [self objc_setAssociatedObject:@"ots_searchbar" value:searchBar policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    searchBar.text = nil;
    searchBar.tag = historySearchBarTag;
    searchBar.tintColor = [UIColor colorWithRGB:0x666666];
    
    self.titleView = searchBar;
    self.leftBarButtonItems = nil;
    self.hidesBackButton = true;
    [searchBar becomeFirstResponder];
}

- (void)makeForAccountUI {
    self.leftBarButtonItems = @[[self __IMItem]];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_set"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(__gotoSetting:)];
    self.rightBarButtonItems = @[settingItem];
}

- (void)setSearchBarText:(NSString *)text {
    if ([self.titleView isKindOfClass:[UISearchBar class]]) {
        UISearchBar *searchBar = (id)self.titleView;
        searchBar.text = text;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    id delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(searchBarDidSubmit:)]) {
        [delegate searchBarDidSubmit:searchBar];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (searchBar.tag != historySearchBarTag) {
        [self __enterSearch:nil];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidChange:)]) {
        [self.delegate searchBarTextDidChange:searchText];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    id delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(didCancelSearch:)]) {
        [delegate didCancelSearch:searchBar];
    }
}

#pragma mark - Getter & Setter
- (void)setDelegate:(__kindof UIViewController *)delegate {
    [self objc_setAssociatedObject:@"ots_delegate" value:delegate policy:OBJC_ASSOCIATION_ASSIGN];
}

- (__kindof UIViewController*)delegate {
    return [self objc_getAssociatedObject:@"ots_delegate"];
}

#pragma mark - Private
- (void)__enterSearch:(UIBarButtonItem*)sender {
    OTSRouter *router = [[OTSRouter alloc] initWithSource:nil routerKey:@"productsearch"];
    router.option = OTSRouterPush | OTSRouterOptionCancelAnimation;
    [router submit];
}

- (void)__gotoCart:(UIBarButtonItem *)sender {
    OTSRouter *router = [[OTSRouter alloc] initWithSource:nil routerKey:@"cart"];
    router.option = OTSRouterPush;
    [router submit];
}

- (void)__gotoHomePage:(UIBarButtonItem *)sender {
    UIViewController *source = nil;
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        source = self.delegate;
    }
    OTSRouter *router = [[OTSRouter alloc] initWithSource:source routerKey:@"home"];
    router.option = OTSRouterSwitch;
    [router submitWithCompletion:^{
        [source.navigationController popToRootViewControllerAnimated:false];
    }];
}

- (void)didPressBackButtonItem:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(didPressBackButtonItem:)]) {
        [self.delegate didPressBackButtonItem:sender];
    }
}

- (void)__gotoSetting:(UIBarButtonItem *)sender {
    OTSRouter *router = [[OTSRouter alloc] initWithSource:nil routerKey:@"setting"];
    router.option = OTSRouterPush;
    [router submit];
}

- (void)__gotoIMNotificationList:(UIBarButtonItem *)sender {
    OTSRouter *router = [[OTSRouter alloc] initWithSource:nil routerKey:@"notifications"];
    router.option = OTSRouterPush;
    [router submit];
}

#pragma mark - BarItems
- (UIBarButtonItem *)__searchItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_search"] style:UIBarButtonItemStylePlain target:self action:@selector(__enterSearch:)];
}

- (UIBarButtonItem *)__cartItem {
    OTSBadgedBarButtonItem *cartItem = [[OTSBadgedBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bottom_icon_cart_normal"] target:self action:@selector(__gotoCart:)];
    
    WEAK_SELF;
    [self.KVOController observe:[OTSGlobalValue sharedInstance] keyPath:@"cartCount" options:NSKeyValueObservingOptionInitial block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
        STRONG_SELF;
        [self performInMainThreadBlock:^{
            OTSGlobalValue *value = object;
            cartItem.badgeString = (value.cartCount.integerValue > 99) ? @"99+" : value.cartCount.stringValue;
        }];
    }];
    return cartItem;
}

- (UIBarButtonItem *)__IMItem {
    OTSBadgedBarButtonItem *IMItem = [[OTSBadgedBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"accont-icon-notifications"] target:self action:@selector(__gotoIMNotificationList:)];
    
    return IMItem;
}

- (UISearchBar *)__searchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setImage:[UIImage imageNamed:@"topbar_searchbar_icon_delete_normal"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.placeholder = @"Search for Products...";
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return searchBar;
}

@end
