//
//  OTSIntentModel.h
//  OTSKit
//
//  Created by Jerry on 2016/11/25.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSCodingObject.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString const* OTSIntentCallBackKey;

FOUNDATION_EXTERN NSString const* OTSIntentTitleKey;
FOUNDATION_EXTERN NSString const* OTSIntentMessageKey;

FOUNDATION_EXTERN NSString const* OTSIntentBDFromKey;
FOUNDATION_EXTERN NSString const* OTSIntentBDParamKey;

FOUNDATION_EXTERN NSString const* OTSActionCancelTitleKey;//alert & sheet :cancel title
FOUNDATION_EXTERN NSString const* OTSActionValues;// alert & sheet :action titles->[NSString]; share :shared values->[NSString, UIImage, NSURL...]
FOUNDATION_EXTERN NSString const* OTSActionEventBlockKey;//alert & sheet :actions->[(void (^)(NSInteger index))] {index == default title index, -1 means cancel}

typedef NS_OPTIONS(NSUInteger, OTSActionOption) {
    OTSActionOptionShowLoading     = 1 << 0,
    OTSActionOptionHideLoading     = 1 << 1,
    
    OTSActionOptionShowAlert       = 1 << 2,
    OTSActionOptionShowToast       = 1 << 3,
    OTSActionOptionShowSheet       = 1 << 4,
    
    OTSActionOptionDismiss         = 1 << 5,
    OTSActionOptionHideKeyboard    = 1 << 6,
    
    OTSActionOptionShare           = 1 << 7,
    
    OTSActionOptionApplication0    = 1 << 8,
    OTSActionOptionApplication1    = 1 << 9,
    OTSActionOptionApplication2    = 1 << 10,
    
    OTSActionOptionHeaderSuccessfully = 1<< 11,
    OTSActionOptionFooterSuccessfully = 1<< 12,
    
    OTSActionOptionHeaderError = 1<< 13,
    OTSActionOptionFooterError = 1<< 14,
    OTSActionOptionFooterPause = 1<< 15

    
    
};

typedef NS_OPTIONS(NSUInteger, OTSRouterOption) {
    OTSRouterPresent     = 1 << 0,   //call presentViewController:animated:completion:
    OTSRouterPush        = 1 << 1,   //call pushViewController:animated:
    OTSRouterChild       = 1 << 2,   //call addChildViewController: and view.addSubview
    OTSRouterSwitch      = 1 << 3,
    
    OTSRouterPushOptionClearTop    = 1 << 4,   //if options & OTSRouterPush, push item and clear items before
    OTSRouterPushOptionSingleTop   = 1 << 5,   //if options & OTSRouterPush, remove all item.class in stack before pushing it.
    OTSRouterPushOptionRootTop     = 1 << 6,   //if options & OTSRouterPush, push item and remove items to make sure that there are less equal than two vcs in stack
    OTSRouterPushOptionClearLast   = 1 << 7,   //if options & OTSRouterPush, push item and remove the last one
    OTSRouterPresentOptionWrapNC   = 1 << 8,   //if option & OTSRouterPresent, wrap destination with UINavigationController
    
    OTSRouterOptionCancelAnimation = 1 << 9   // cancel animation
};


typedef NS_ENUM(NSUInteger, OTSIntentType) {
    OTSIntentTypeAction,
    OTSIntentTypeRouter,
    OTSIntentTypeHandler
};

@interface OTSIntentModel : OTSCodingObject

@property (assign, nonatomic) NSUInteger option;
@property (assign, nonatomic) OTSIntentType type;

@property (strong, nonatomic, nullable) NSString *key;
@property (strong, nonatomic, nullable) NSDictionary *extraData;

+ (instancetype)routerModelWithKey:(NSString*)key
                            option:(NSUInteger)option
                              data:(nullable NSDictionary*)extraData;

+ (instancetype)routerModelWithDestinationClass:(Class)destinationClass
                                         option:(NSUInteger)option
                                           data:(nullable NSDictionary*)extraData;

+ (instancetype)actionModelWithOption:(NSUInteger)option
                                 data:(nullable NSDictionary*)extraData;

+ (instancetype)actionModelWithError:(nullable NSError*)anError
                          altMessage:(nullable NSString*)alternativeMessage
                                type:(NSUInteger)actionType;

+ (instancetype)handlerModelWithKey:(NSString*)key
                              param:(nullable NSDictionary*)param;

+ (instancetype)handlerModelWithTarget:(id)target
                                action:(SEL)action
                                 param:(nullable NSDictionary*)param;

/**
 *  Init function.
 *
 *
 *  destinationURLString contains action,extraData.
 *  e.g. "router://testHost?body={"name":"Jerry", option:10}"
 *  The scheme "router" is equal to JWIntentContext.routerScheme, so we know that it's a router action.
 *  The host "testHost" indicates targetClassName, which is registered by the class or app loaded in JWIntentContext mannually.
 *  The query part(formatted "body={}") indicates the json value of extraData, which will be translated and set automatically.
 *  Similarlly, if scheme is equal to JWIntentContext.handlerScheme, we know that it's a perform-block action.
 *
 */

+ (instancetype)modelWithUrlString:(NSString*)destinationUrlString
                             param:(nullable NSDictionary*)param;

+ (instancetype)alertWithTitle:(nullable NSString*)title
                       message:(nullable NSString*)msg
                   cancelTitle:(nullable NSString*)cancelTitle
                 positiveTitle:(nullable NSString*)positiveTitle
                    eventBlock:(nullable void (^)(NSInteger index))eventBlock;

+ (instancetype)actionSheetWithTitle:(nullable NSString*)title
                       message:(nullable NSString*)msg
                   cancelTitle:(nullable NSString*)cancelTitle
                 positiveTitle:(nullable NSString*)positiveTitle
                    eventBlock:(nullable void (^)(NSInteger index))eventBlock;
@end

NS_ASSUME_NONNULL_END
