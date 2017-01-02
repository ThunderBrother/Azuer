//
//  OTSLaunchModule.m
//  OneStoreLight
//
//  Created by Jerry on 16/8/26.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import <OTSKit/OTSKit.h>
#import <Aspects/Aspects.h>

#import "OTSLaunchModule.h"
#import "OTSLaunchLogic.h"


FOUNDATION_EXTERN NSString *const OTSHomeCacheKey;
FOUNDATION_EXTERN NSString *const OTSCategoryCacheKey;

@interface OTSLaunchModule()

@property (strong, nonatomic) OTSLaunchLogic *logic;
@property (strong, nonatomic) dispatch_semaphore_t semaphore;

@end

@implementation OTSLaunchModule

#pragma mark - LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        [self setupAppearance];
        [self setupAOP];
        [self setupRouter];
        
        [OTSLog setupLogerStatus];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(__applicationDidFinishLaunching:)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(__applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}

#pragma mark - LifeCycle
- (void)setupAppearance {
    UIColor *themeColor = [UIColor colorWithRGB:0xfa585d];
    [[UITabBar appearance] setTintColor:themeColor];
    [[UISearchBar appearance] setTintColor:themeColor];
    [[UITextField appearance] setTintColor:themeColor];
    [[OTSCircleProgressView appearance] setTintColor:themeColor];
    [[OTSCircleLoadingView appearance] setTintColor:themeColor];
    [[OTSSimpleShape appearance] setTintColor:themeColor];
    [[OTSTextPageControl appearance] setTintColor:themeColor];
    [[OTSCameraMaskView appearance] setTintColor:themeColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRGB:0x666666]];
    [[UINavigationBar appearance] setTranslucent:true];
    
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor colorWithRGB:0xff5559];
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor colorWithRGB:0xf2f2f2];
    
    [[UICollectionView appearance] setBackgroundColor:[UIColor colorWithRGB:0xf2f2f2]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRGB:0xf2f2f2]];
    [[UITableView appearance] setSeparatorColor:[UIColor colorWithRGB:0xe6e6e6]];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xf2f2f2] cornerRadius:15.0] forState:UIControlStateNormal];
    [[UISearchBar appearance] setSearchTextPositionAdjustment:UIOffsetMake(-5, 0)];
    [[UISearchBar appearance] setImage:[UIImage imageWithColor:[UIColor clearColor]] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundImage:[UIImage new]];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(.0, -4)];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xdddddd]]];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorWithRGB:0xdddddd]]];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navigation_back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigation_back"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor colorWithRGB:0x333333]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} forState:UIControlStateNormal];
    
}

- (void)setupAOP {
    [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, UIViewController *viewController, BOOL animated) {
        UINavigationController *instanceNC = aspectInfo.instance;
        if (instanceNC.viewControllers.count > 1) {
            UIViewController *previousVC = [instanceNC.viewControllers safeObjectAtIndex:instanceNC.viewControllers.count - 2];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            previousVC.navigationItem.backBarButtonItem = backItem;
        }
    } error:nil];
}

- (void)setupRouter {
    [OTSIntentContext defaultContext].routerScheme = @"yhd";
    [OTSIntentContext defaultContext].handlerScheme = @"yhdFunc";
    [OTSIntentContext defaultContext].actionScheme = @"yhdAction";
}

- (void)setupSubModules {
    [self mountSubModule:[[NSClassFromString(@"OTSAccountModule") alloc] init] forKey:@"account"];
    [self mountSubModule:[[NSClassFromString(@"OTSOrderModule") alloc] init] forKey:@"order"];
    [self mountSubModule:[[NSClassFromString(@"OTSCartModule") alloc] init] forKey:@"cart"];
    [self mountSubModule:[[NSClassFromString(@"OTSEntryModule") alloc] init] forKey:@"entry"];
    [self mountSubModule:[[NSClassFromString(@"OTSProductModule") alloc] init] forKey:@"product"];
    [self mountSubModule:[[NSClassFromString(@"OTSTrackerModule") alloc] init] forKey:@"tracker"];
    [self mountSubModule:[[NSClassFromString(@"OTSIMModule") alloc] init] forKey:@"im"];
}

#pragma mark - Notification Handler
- (void)__applicationDidFinishLaunching: (NSNotification*)sender {
    [self.logic registNetworkHandler];
    WEAK_SELF;
    [self.logic getSecretKeyWithHandler:^(BOOL success) {
        STRONG_SELF;
        dispatch_semaphore_signal(self.samaphore);
    }];
    
    NSArray *launchImageItems = [OTSUserDefault getValueForKey:OTSLaunchImageData];
    id cachedHomeData = [OTSArchiveData unarchiveDataInCacheWithFileName:OTSHomeCacheKey];
    id cachedCategoryData = [OTSArchiveData unarchiveDataInCacheWithFileName:OTSCategoryCacheKey];
    
    dispatch_semaphore_wait(self.samaphore, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC));
    
    [self setupSubModules];
    
    [self.logic dealWithCachedData];
    [self __showMainTBCWithCachedHomeData:cachedHomeData cachedCategoryData:cachedCategoryData];
    [self __showLaunchImageWithItems:launchImageItems];
}

- (void)__applicationDidEnterBackground: (NSNotification*)sender {
    
}

#pragma mark - Getter 
- (OTSLaunchLogic*) logic {
    if (!_logic) {
        _logic = [[OTSLaunchLogic alloc] initWithOwner:self];
        _logic.operationManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _logic;
}

- (dispatch_semaphore_t) samaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

#pragma mark - Private
- (void)__showMainTBCWithCachedHomeData:(NSArray*)cachedHomeData
                     cachedCategoryData:(NSArray*)cachedCategoryData {
    
    OTSRouter *mainTBCRouter = [[OTSRouter alloc] initWithSource:nil routerKey:@"main"];
    
    NSMutableDictionary *extraData = [NSMutableDictionary dictionary];
    [extraData safeSetObject:cachedHomeData forKey:@"homeData"];
    [extraData safeSetObject:cachedCategoryData forKey:@"categoryData"];
    
    mainTBCRouter.extraData = extraData;
    OTSSharedKeyWindow.rootViewController = mainTBCRouter.destination;
}

- (void)__showLaunchImageWithItems:(NSArray*)launchImageItems {
    if (launchImageItems.count) {
        OTSRouter *launchPageRouter = [[OTSRouter alloc] initWithSource:nil routerKey:@"launchPage"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params safeSetObject:launchImageItems forKey:@"items"];
        [params safeSetObject:^(OTSIntentModel *intentModel){
            OTSIntent *actionRouter = [OTSIntent intentWithItem:intentModel source:nil context:nil];
            [actionRouter submit];
        } forKey:@"imageClickedBlock"];
        [params safeSetObject:^(void){
            OTSSharedTopWindow.rootViewController = [UIViewController new];
            OTSSharedTopWindow.hidden = true;
        } forKey:@"dismissBlock"];
        
        launchPageRouter.extraData = params;
        
        UIWindow *topWindow = OTSSharedTopWindow;
        topWindow.rootViewController = launchPageRouter.destination;
        topWindow.hidden = false;
    }
}

@end
