//
//  OTSTestRouterVC.m
//  OneStoreLight
//
//  Created by Jerry on 16/10/28.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSTestRouterVC.h"
#import <OTSKit/OTSKit.h>

NSString * const OTSLastRouterURLKey = @"ots_last_test_router_url";

@interface OTSTestRouterVC ()

@property (strong, nonatomic) UIView *dimView;

@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *inputContainer;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation OTSTestRouterVC

#ifdef OTS_TEST

+ (void)load {
    [[OTSIntentContext defaultContext] registerHandlerForTarget:self selector:@selector(__showTestVC) forKey:@"testRouter"];
}

+ (void)__showTestVC {
    OTSTestRouterVC *vc = [[OTSTestRouterVC alloc] init];
    
    UIWindow *topWindow = OTSSharedModalWindow;
    topWindow.rootViewController = vc;
    topWindow.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputContainer.layer.masksToBounds = true;
    self.inputContainer.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.inputContainer.layer.borderColor = [UIColor colorWithRGB:0xe6e6e6].CGColor;
    self.inputContainer.layer.cornerRadius = 2.0;
    
    [self.view addSubview:self.dimView];
    [self.view addSubview:self.cardView];
    
    self.cardView.frame = CGRectMake(15, -120, self.view.width - 30.0, 120.0);
    self.cardView.layer.masksToBounds = true;
    self.cardView.layer.cornerRadius = 2.0;
    
    self.textField.text = [OTSUserDefault getValueForKey:OTSLastRouterURLKey] ?: @"yhd://detail?body={\"pmId\":1902294, \"productId\":1704383}";
    
    [UIView animateWithDuration:.25 animations:^{
        self.dimView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.6];
        self.cardView.frame = CGRectMake(15, 64 + 10, self.view.width - 30.0, 120.0);
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissWithComptetion:(void (^)())aCompletion {
    [self.view endEditing:true];
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = .0;
    } completion:^(BOOL finished) {
        UIWindow *topWindow = OTSSharedModalWindow;
        topWindow.rootViewController = [UIViewController new];
        topWindow.hidden = true;
        if (aCompletion) {
            aCompletion();
        }
    }];
}
- (IBAction)didPressSubmitButton:(id)sender {
    NSString *routerURL = self.textField.text;
    if (routerURL.length) {
        [OTSUserDefault setValue:routerURL forKey:OTSLastRouterURLKey];
    }
    
    [self dismissWithComptetion:^{
        [[OTSIntent intentWithItem:[OTSIntentModel modelWithUrlString:routerURL param:nil] source:nil context:nil] submit];
    }];
}

- (IBAction)didPressCancelButton:(id)sender {
    [self dismissWithComptetion:nil];
}

#pragma mark - Getter & Setter
- (UIView*)dimView {
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
        _dimView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressCancelButton:)];
        [_dimView addGestureRecognizer:tapGes];
    }
    return _dimView;
}

#endif

@end
