//
//  AZMainTabBarVC.m
//  AzuerPro
//
//  Created by zhangzuming on 1/2/17.
//  Copyright © 2017 Azuer. All rights reserved.
//

#import "AZMainTabBarVC.h"

@interface AZMainTabBarVC ()

@end

@implementation AZMainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubTabs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubTabs {
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:4];
    {
        UIViewController *homeVC = [[UIViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:homeVC];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        UIViewController *secondVC = [[UIViewController alloc] init];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:secondVC];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Category" image:[UIImage imageNamed:@"tabbar_category"] selectedImage:[UIImage imageNamed:@"tabbar_category_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        UIViewController *thirdVC = [[UIViewController alloc] init];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:thirdVC];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cart" image:[UIImage imageNamed:@"tabbar_cart"] selectedImage:[UIImage imageNamed:@"tabbar_cart_selected"]];
        [vcArray addObject:nc];
    }
    
    {
        UIViewController *fourthVC = [[UIViewController alloc] init];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:fourthVC];
        nc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage imageNamed:@"tabbar_account"] selectedImage:[UIImage imageNamed:@"tabbar_account_selected"]];
        [vcArray addObject:nc];
    }
    
    [self setViewControllers:vcArray.copy animated:false];
    self.selectedIndex = 0;

}
@end
