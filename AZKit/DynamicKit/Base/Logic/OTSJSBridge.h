//
//  OTSJSBridge.h
//  OTSKit
//
//  Created by Jerry on 2017/2/13.
//  Copyright © 2017年 Yihaodian. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@class OTSIntentModel;
@class OTSOperationManager;

@protocol OTSJSBridgeExport<JSExport>

- (void)setIntentModelDict:(NSDictionary*)dict;
- (void)sendDataDict:(NSDictionary*)dict;
- (void)sendDataArray:(NSArray<NSDictionary*>*)array;

- (void)showToast:(NSString*)toast;
- (void)showLoading: (NSString*)msg;
- (void)hideLoading;

JSExportAs(post, - (void)postWithBusinessName:(NSString*)businessName
                                   methodName:(NSString*)methodName
                                        param:(NSDictionary*)param
                                     callBack:(JSValue*)callBack //void (^)(id aResponseObject, NSError* anError)
           );

JSExportAs(showAlert, - (void)showAlertWith:(NSString*)title
                                    message:(NSString*)msg
                                cancelTitle:(NSString*)cancelTitle
                              positiveTitle:(NSString*)positiveTitle
                                 eventBlock:(JSValue*)event//void (^)(NSInteger index)
           );

JSExportAs(showSheet, - (void)showSheetWith:(NSString*)title
                                    message:(NSString*)msg
                                cancelTitle:(NSString*)cancelTitle
                             positiveTitles:(NSArray<NSString*>*)positiveTitles
                                 eventBlock:(JSValue*)event//void (^)(NSInteger index)
           );


@end

@interface OTSJSBridge : NSObject<OTSJSBridgeExport>

@property (strong, nonatomic) OTSIntentModel *intentModel;
@property (strong, nonatomic) NSDictionary *jsDataDict;
@property (strong, nonatomic) NSArray<NSDictionary*> *jsDataArray;

- (instancetype)initWithOperationManager:(OTSOperationManager*)operationManager;

@end
