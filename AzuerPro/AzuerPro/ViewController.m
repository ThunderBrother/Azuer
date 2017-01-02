//
//  ViewController.m
//  AzuerPro
//
//  Created by zhangzuming on 12/26/16.
//  Copyright © 2016 Azuer. All rights reserved.
//

#import "ViewController.h"
#import <SDImageCache.h>
#import <PureLayout.h>
#import <AZKit/AZkit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
    

    UILabel *lbl = [UILabel newAutoLayoutView];
    lbl.text = @"adfasdfsadfsadfa";
    [self.view addSubview:lbl];
    [lbl autoPinEdgesToSuperviewEdges];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIAlertController *aController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Wwarning" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [aController addAction:cancelAction];
    [aController addAction:okAction];
    [self presentViewController:aController animated:YES completion:nil];
}
@end
