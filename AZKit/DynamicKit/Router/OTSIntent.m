//
//  JWIntent.m
//  JWIntent
//
//  Created by Jerry on 16/4/22.
//  copyright (c) 2016 Jerry Wong jerrywong0523@icloud.com
//


#import "OTSIntent.h"
#import <objc/runtime.h>

#import "OTSRouter.h"
#import "OTSHandler.h"
#import "OTSAction.h"

NSString const* OTSIntentCallBackKey = @"OTSIntentCallBackKey";
NSString const* OTSIntentTitleKey = @"OTSIntentTitleKey";
NSString const* OTSIntentMessageKey = @"OTSIntentMessageKey";
NSString const* OTSIntentImageNameKey = @"OTSIntentImageNameKey";

NSString const* OTSIntentBDParamKey = @"OTSIntentBDParamKey";
NSString const* OTSIntentBDFromKey = @"OTSIntentBDFromKey";

UIViewController* OTS_AutoGetRootSourceViewController() {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *topVC = keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        topVC = ((UITabBarController*)topVC).selectedViewController;
    }
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        topVC = ((UINavigationController*)topVC).topViewController;
    }
    return topVC;
}

UINavigationController* OTS__AutoGetNavigationViewController(UIViewController *sourceVC) {
    UINavigationController *navigationController = nil;
    if ([sourceVC isKindOfClass:[UINavigationController class]]) {
        navigationController = (id)sourceVC;
    } else {
        UIViewController *superViewController = sourceVC.parentViewController;
        while (superViewController) {
            if ([superViewController isKindOfClass:[UINavigationController class]]) {
                navigationController = (id)superViewController;
                break;
            } else {
                superViewController = superViewController.parentViewController;
            }
        }
    }
    return navigationController;
}

@interface OTSIntentModel ()

@property (strong, nonatomic, nullable) id destinationValue;

@end

@implementation OTSIntent

@dynamic extraData;//使用NSObject+ExtraData中的setter和getter，所以此处不需要自己合成setter和getter

#pragma mark - Initialize
+ (instancetype)intentWithItem:(OTSIntentModel*)item
                        source:(id)source
                       context:(nullable OTSIntentContext*)context{
    
    OTSIntent *aIntent = nil;
    if (item.type == OTSIntentTypeAction) {
        aIntent = [[OTSAction alloc] initWithSource:source];
        ((OTSAction*)aIntent).option = item.option;
    } else if(item.type == OTSIntentTypeRouter) {
        if (item.destinationValue) {
            aIntent = [[OTSRouter alloc] initWithSource:source destinationClass:(Class)(item.destinationValue)];
        } else if (item.key.length) {
            aIntent = [[OTSRouter alloc] initWithSource:source routerKey:item.key context:context];
        }
        ((OTSRouter*)aIntent).option = item.option;
    } else if (item.type == OTSIntentTypeHandler) {
        if (item.destinationValue) {
            id callBackObj = item.destinationValue;
            if ([callBackObj isKindOfClass:[OTSCallBackDelegate class]]) {
                OTSCallBackDelegate *callBackDelegate = callBackObj;
                aIntent = [[OTSHandler alloc] initWithTarget:callBackDelegate.target action:callBackDelegate.action];
            } else if([callBackObj isKindOfClass:[OTSCallBackBlock class]]) {
                OTSCallBackBlock *callBackBlock = callBackObj;
                aIntent = [[OTSHandler alloc] initWithBlock:callBackBlock.block];
            }
        } else if (item.key.length) {
            aIntent = [[OTSHandler alloc] initWithHandlerKey:item.key context:context];
        }
    }
    
    aIntent.extraData = item.extraData;
    
    return aIntent;
}

#pragma mark - PublicAPI
- (void)submit {
    [self submitWithCompletion:nil];
}

- (void)submitWithCompletion:(void (^)(void))completionBlock {
    NSAssert(self.destination, @"Trying to submit intent with no destination");
}

@end
