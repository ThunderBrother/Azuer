//
//  OTSUpLoadNetworkInterface.m
//  OneStoreFramework
//
//  Created by airspuer on 14-11-3.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSNIUpLoad.h"
//define
//#import "OTSUserDefaultDefine.h"
//cache
//#import "OTSUserDefault.h"
//#import "OTSConnectUrl.h"

@interface OTSNIUpLoad()

@end

@implementation OTSNIUpLoad

+ (OTSUploadOperationParam *)uploadFileForReturn:(NSArray *)aFileValues
											   token:(NSString *)aToken
									 completionBlock:(OTSCompletionBlock)aCompletionBlock;
{
    if (!aFileValues || !aToken) {
        aCompletionBlock(nil,[NSError new]);
        return nil;
    }
	NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict safeSetObject:aToken forKey:@"token"];
	[paramDict safeSetObject:@"uploadFileForReturn" forKey:@"methodName"];
	[paramDict safeSetObject:@"2" forKey:@"resultType"];
    
    NSString *currentUrlAddress = @"http://interface.m.yhd.com";
#ifdef OTS_TEST
    OTSNetworkEnvironmentType currentType = [OTSNetworkEnvironment getNetworkType];
    int newType = currentType;
    [OTSNetworkEnvironment setNetworkType:newType];
    switch (newType) {
        case OTSNetworkEnvironmentTypeTest:
            currentUrlAddress = @"http://10.161.146.46:8080";
            break;
    }
#endif
    
	currentUrlAddress = [NSString stringWithFormat:@"%@/centralmobile/servlet/ImageUploadServlet",currentUrlAddress];

	OTSUploadOperationParam *uploadParam = [OTSUploadOperationParam paramWithUrl:currentUrlAddress name:@"fileupload" files:aFileValues param:paramDict mimeType:kJpg callback:^(id aResponseObject, NSError *anError) {
		if (anError == nil) {
			if (![aResponseObject isKindOfClass:[NSArray class]]) {
				anError = [self typeMismatchErrorWithMatchType:[NSArray class] sourceType:[aResponseObject class]];
			}
		}
		aCompletionBlock(aResponseObject,anError);
	}];
	return uploadParam;
}

@end
