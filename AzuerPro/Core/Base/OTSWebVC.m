//
//  OTSWebVC.m
//  OneStoreLight
//
//  Created by Jerry on 16/9/21.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSWebVC.h"
#import <WebKit/WebKit.h>
#import <OTSKit/OTSKit.h>
#import "OTSBIGlobalValue.h"
#import "NSObject+FBKVOController.h"
#import "UINavigationItem+Make.h"
#import "OTSLogic.h"

@interface OTSWebVC ()<WKNavigationDelegate, OTSNavigationItemDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UILabel *urlLabel;

@property (strong, nonatomic) UIBarButtonItem *closeItem;
@property (assign, nonatomic) double loadProgress;
@property (strong, nonatomic) CAShapeLayer *progressLayer;

@end

@implementation OTSWebVC

+ (void)load {
    [[OTSIntentContext defaultContext] registerRouterClass:[self class] forKey:@"web"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, self.view.height - self.topLayoutGuide.length);
    [self __layoutProgressShapeLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [OTSWebVC setupDefaultCookie];
    [self __setupViews];
    [self __setupObservers];
    [self __loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)didDoneButtonItem:(UIBarButtonItem*)sender {
    if(self.doneButtonItemBlock) {
       self.doneButtonItemBlock();
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didPressCloseButtonItem:(UIBarButtonItem*)sender {
    [self __popWebVC];
}

#pragma mark - OTSNavigationItemDelegate
- (void)didPressBackButtonItem:(UIBarButtonItem*)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
        if (self.navigationItem.leftBarButtonItems.count == 2) {
            NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
            [itemsArray addObject:self.closeItem];
            self.navigationItem.leftBarButtonItems = itemsArray;
        }
    } else {
        [self __popWebVC];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.didFinishLoadBlock) {
        self.didFinishLoadBlock();
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    BOOL allowNavigation = true;
    
    NSURL *requestURL = navigationAction.request.URL;
    NSString *requestURLString = [requestURL.absoluteString stringByRemovingPercentEncoding];
    
    if (self.navigationRespondBlock) {
        allowNavigation = self.navigationRespondBlock(requestURLString);
    }
    
    if (allowNavigation) {
        if ([requestURLString hasPrefix:@"yhd://"] || [requestURLString hasPrefix:@"yhdiosfun://"]) {
            requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"yhd://" withString:[NSString stringWithFormat:@"%@://", [OTSIntentContext defaultContext].routerScheme]];
            requestURLString = [requestURLString stringByReplacingOccurrencesOfString:@"yhdiosfun://" withString:[NSString stringWithFormat:@"%@://", [OTSIntentContext defaultContext].handlerScheme]];
            
            OTSIntentModel *item = [OTSIntentModel modelWithUrlString:requestURLString param:nil];
            OTSIntent *anIntent = [OTSIntent intentWithItem:item source:nil context:nil];
            [self __handleAddCartIntent:anIntent];
            if (anIntent.destination) {
                [anIntent submit];
            }
            allowNavigation = false;
        }
    }
    
    if (allowNavigation && !navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    
    decisionHandler(allowNavigation ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSURLCredential *credential = nil;
    NSString *host = challenge.protectionSpace.host;
    if([host containsString:@"yhd.com"] && [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    }
    
    if(completionHandler) {
        completionHandler(credential ? NSURLSessionAuthChallengeUseCredential : NSURLSessionAuthChallengePerformDefaultHandling,credential);
    }
}

#pragma mark - Getter & Setter
- (UIBarButtonItem*)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_close"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButtonItem:)];
        _closeItem.imageInsets = UIEdgeInsetsMake(0, -14, 0, 14);
    }
    return _closeItem;
}

- (UILabel*)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -44.0, self.view.width, 44.0)];
        _urlLabel.textColor = [UIColor colorWithRGB:0x666666];
        _urlLabel.font = OTSSmallFont;
        _urlLabel.textAlignment = NSTextAlignmentCenter;
        _urlLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _urlLabel;
}

- (CAShapeLayer*)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor colorWithRGB:0xfa585d].CGColor;
        _progressLayer.lineWidth = 2.0;
        _progressLayer.strokeEnd = .0;
    }
    return _progressLayer;
}

- (WKWebView*)webView {
    if (!_webView) {
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        if (self.injectionScript.length) {
            WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:self.injectionScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            [wkUController addUserScript:wkUScript];
        }
        
        WKUserScript * cookieScript = [[WKUserScript alloc]
                                       initWithSource: [OTSWebVC injectedCookieJS]
                                       injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [wkUController addUserScript:cookieScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:wkWebConfig];
        _webView.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = true;
        
        NSString *customUA = @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4 yhdios";
        if (IOS_SDK_LESS_THAN(9.0)) {
            [_webView setValue:customUA forKey:@"applicationNameForUserAgent"];
        } else {
            _webView.customUserAgent = customUA;
        }
    }
    return _webView;
}

#pragma mark - Private
- (void)__setupViews {
    self.hidesBottomBarWhenPushed = true;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor colorWithRGB:0xf2f2f2];
    [self.view addSubview:self.webView];
    [self.view.layer addSublayer:self.progressLayer];
    
    [self __layoutProgressShapeLayer];
    [self.webView.scrollView insertSubview:self.urlLabel atIndex:0];
    
    [self.navigationItem makeForCustomBackButtonUI];
    self.navigationItem.delegate = self;
    
    if (!self.prohibitedPanPop.boolValue) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    if(self.doneButtonItemBlock) {
        UIBarButtonItem *doneItem;
        if(self.isImageFile.boolValue){
            doneItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:self.textOrImage]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(didDoneButtonItem:)];
        } else {
            doneItem = [[UIBarButtonItem alloc] initWithTitle:self.textOrImage
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(didDoneButtonItem:)];
        }
        
        
        self.navigationItem.rightBarButtonItems = @[doneItem];
    }
}

- (void)__setupObservers {
    WEAK_SELF;
    if (!self.title.length) {
        [self.KVOController observe:self.webView keyPath:@"title" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
            STRONG_SELF;
            NSString *newTitle = change[NSKeyValueChangeNewKey];
            if ((id)newTitle != [NSNull null]) {
                self.title = newTitle;
            }
        }];
    }
    
    [self.KVOController observe:self.webView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
        STRONG_SELF;
        double newProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        self.progressLayer.strokeEnd = newProgress;
        self.progressLayer.opacity = newProgress == 1.0 ? .0 : 1.0;
    }];
}

- (void)__loadData {
    if (self.htmlContents.length) {
        [self.webView loadHTMLString:self.htmlContents baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    } else if (self.url.length) {
        WEAK_SELF;
        [self.KVOController observe:self.webView keyPath:@"URL" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> *change) {
            STRONG_SELF;
            OTSNullReturn(NSKeyValueChangeNewKey);
            NSURL *url = change[NSKeyValueChangeNewKey];
            self.urlLabel.text = [self __stringByURL:url];
        }];
        
        NSMutableURLRequest *aRequest;
        if([self.url rangeOfString:@"http"].location != NSNotFound) {
            aRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
            [aRequest addValue:[OTSWebVC stringForCookie] forHTTPHeaderField:@"Cookie"];
        } else {
            NSURL *fileURL;
            if (IOS_SDK_MORE_THAN_OR_EQUAL(9.0)){
                fileURL = [NSURL fileURLWithPath:self.url];
            }else{
                fileURL = [OTSWebVC fileURLTransferPositionWithFileURL:[NSURL fileURLWithPath:self.url]];
            }
            aRequest = [NSMutableURLRequest requestWithURL:fileURL];
        }
        [self.webView loadRequest:aRequest];
    }
}
- (void)__layoutProgressShapeLayer {
    self.progressLayer.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, 2.0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 1.0)];
    [path addLineToPoint:CGPointMake(self.view.width, 1.0)];
    
    self.progressLayer.path = path.CGPath;
}

- (NSString*)__stringByURL:(NSURL*)url {
    NSString *resultString = [url.host stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    return resultString;
}

- (void)__popWebVC {
    if (self.didPopBlock) {
        self.didPopBlock();
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)__handleAddCartIntent:(OTSIntent*)anIntent {
    if ([anIntent isKindOfClass:[OTSHandler class]] &&
        [((OTSHandler*)anIntent).handlerKey isEqualToString:@"addCart"]) {
        NSDictionary *extraData = anIntent.extraData;
        if (extraData) {
            NSMutableDictionary *mutableExtraData = [NSMutableDictionary dictionaryWithDictionary:extraData];
            [mutableExtraData setObject:^(NSDictionary *params){
                
                if ([[params objectForKey:@"rtn_code"] integerValue] == 0) {
                    [[OTSAlertView alertWithTitle:@"Tip" message:@"Added to Cart" leftBtn:@"Go on Shopping" rightBtn:@"Go to Cart" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            OTSRouter *cartRouter = [[OTSRouter alloc] initWithSource:nil routerKey:@"cart"];
                            [cartRouter submit];
                        }
                    }] show];
                }
                
            } forKey:OTSIntentCallBackKey];
            anIntent.extraData = mutableExtraData;
        }
    }
}

#pragma mark - Cookie
+ (void)setCookie:(NSString *)aDomain name:(NSString *)aName value:(NSString *)aValue {
    if (!aName) {
        return ;
    }
    if (!aValue) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.copy enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
            if ([cookie.properties[NSHTTPCookieName] isEqualToString:aName]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                *stop = YES;
            }
        }];
        return ;
    }
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieDomain] = aDomain;
    cookieProperties[NSHTTPCookieName] = aName;
    cookieProperties[NSHTTPCookieValue] = aValue;
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieVersion] = @"0";
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)setCookieName:(NSString *)aName value:(NSString *)aValue {
    [self setCookie:@".yhd.com" name:aName value:aValue];
}

+ (void)setupDefaultCookie {
    [self setCookieName:@"usertoken" value:[OTSGlobalValue sharedInstance].token];
    [self setCookieName:@"provinceid" value:[OTSCurrentAddress sharedInstance].currentProvinceId.stringValue];
    [self setCookieName:@"provinceId" value:[OTSCurrentAddress sharedInstance].currentProvinceId.stringValue];
    [self setCookieName:@"sessionid" value:[OTSGlobalValue sharedInstance].sessionId];
    [self setCookieName:@"clientinfo" value:[[OTSJsonKit stringFromDict:[[OTSClientInfo sharedInstance] convertDictionary]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self setCookieName:@"frameworkver" value:@"1.0"];
    [self setCookieName:@"platform" value:@"ios"];
    [self setCookieName:@"ut" value:[OTSGlobalValue sharedInstance].token];
    [self setCookieName:@"guid" value:[OTSClientInfo sharedInstance].deviceCode];
    [self setCookieName:@"tracker_msessionid" value:[OTSBIGlobalValue sharedInstance].generateSessionId];
    [self setCookieName:@"tracker_u" value:[OTSBIGlobalValue sharedInstance].trackerUrl];
    [self setCookieName:@"websiteId" value:[OTSBIGlobalValue sharedInstance].website];
    [self setCookieName:@"uid" value:[OTSBIGlobalValue sharedInstance].uid];
}

+ (NSString*)stringForCookie {
    NSMutableString *cookieString = [NSMutableString string];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.copy enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        [cookieString appendFormat:@"%@=%@;domain=.yhd.com;", cookie.properties[NSHTTPCookieName], cookie.properties[NSHTTPCookieValue]];
    }];
    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    return cookieString;
}

+ (NSString*)injectedCookieJS {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *jsFuncString = @" \
    function setCookie(name,value){\
    var exp = new Date();\
    exp.setDate(exp.getDate()+1);\
    document.cookie= name+'='+value+';expires='+exp.toUTCString()+';domain=.yhd.com';\
    }";
    
    NSMutableString *jsCookieString = jsFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@');", cookie.name, cookie.value];
        [jsCookieString appendString:excuteJSString];
    }
    return jsCookieString;
}

#pragma mark - File Operations
+(NSURL *)fileURLTransferPositionWithFileURL:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"otsweb"];
    [fileManager createDirectoryAtURL:temURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    return dstURL;
}
@end
