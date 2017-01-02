//
//  PhoneWeChat.h
//  OneStoreMain
//
//  Created by 黄吉明 on 10/27/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <OTSKit/OTSKit.h>

typedef void(^OTSWeChatRespBlock)(id aResponseObject, NSError* anError);

@interface OTSWeChat : NSObject

AS_SINGLETON(OTSWeChat)

- (BOOL)registeWithAppId:(NSString*)appID;

- (BOOL)handleOpenURLFromWeChat:(NSURL *)aUrl;

- (void)payWithInfo:(NSDictionary *)payInfo compelet:(OTSWeChatRespBlock)block;

@end
