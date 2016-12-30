//
//  JWIntent.h
//  JWIntent
//
//  Created by Jerry on 16/4/22.
//  copyright (c) 2016 Jerry Wong jerrywong0523@icloud.com
//

#import "OTSIntentContext.h"
#import "OTSFuncDefine.h"
#import "OTSIntentModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN UIViewController* OTS_AutoGetRootSourceViewController();
FOUNDATION_EXTERN UINavigationController* _Nullable  OTS__AutoGetNavigationViewController(UIViewController *sourceVC);

@interface OTSIntent : NSObject {
    id _destination;
    OTSIntentContext *_context;
}

@property (strong, nonatomic, readonly) id destination;
/**
 *  if not set, will use [OTSIntentContext defaultContext]
 *
 */
@property (strong, nonatomic, readonly) OTSIntentContext *context;

/**
 *  the parameter passed by intent. 
 *  In target viewController, you can get extraData by calling self.extraData.
 *  In block, it will be passed to block input params.
 *
 */
@property (strong, nonatomic, nullable) NSDictionary *extraData;

/**
 * OTSHandler       0
 * OTSRouter        OTSRouterOption
 * OTSAction        OTSActionOption
 */
@property (assign, nonatomic) NSUInteger option;

+ (nullable instancetype)intentWithItem:(OTSIntentModel*)item
                                 source:(nullable id)source
                                context:(nullable OTSIntentContext*)context;

/**
 *  submit the action
 */
- (void)submit;

/**
 *  submit the action with a completion block.
 */
- (void)submitWithCompletion:(void (^ __nullable)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
