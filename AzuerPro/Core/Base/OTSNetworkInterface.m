//
//  OTSNetworkInterface.m
//  OneStoreFramework
//
//  Created by Aimy on 14-6-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSNetworkInterface.h"

@implementation OTSNetworkInterface

+ (NSString *)interfaceNameFromSelector:(SEL)aSelector
{
	if (aSelector)
		{
		NSString *selStr = NSStringFromSelector(aSelector);
		NSRange range = [NSStringFromSelector(aSelector) safeRangeOfString:@":" options:NSLiteralSearch];
		if (range.location != NSNotFound){
			NSString *retStr = [selStr safeSubstringToIndex:range.location];
			return retStr;
		}
			//add by zhangbin,need verify
		return selStr;
		}

	return nil;
}

+ (NSError *)typeMismatchErrorWithMatchType:(Class)aMathType
								 sourceType:(Class)aSourceType
{
	NSString *errorDomain = [NSString stringWithFormat:@"TypeMismatch: matchDataType:%@, errorDataType:%@",
							 NSStringFromClass(aMathType),NSStringFromClass(aSourceType)];
	NSError *error = [NSError errorWithDomain:errorDomain
										 code:kDataTypeMismatch
									 userInfo:nil];
	return error;
}
@end
