//
//  ViewController.m
//  leqisdk-sample
//
//  Created by zhangkai on 2018/1/9.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ViewController.h"
#import <leqisdk/LeqiSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.btnLogin.backgroundColor = kColorWithHex(0x19b1f5);
    self.btnLogin.layer.cornerRadius = 5;
    [self.btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPay.layer.borderColor =  [kColorWithHex(0x19b1f5) CGColor];
    self.btnPay.layer.cornerRadius = 5;
    self.btnPay.layer.borderWidth = 1;
    [self.btnPay addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leqiLoginResult:)
                                                 name:kLeqiSDKNotiLogin
                                               object:nil];
}

- (void)leqiLoginResult:(NSNotification *)notify {
    NSLog(@"%@", notify.object);
}

- (void)viewDidAppear:(BOOL)animated {
    [[LeqiSDK shareInstance] showFloatView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[LeqiSDK shareInstance] hideFloatView];
}

- (void)login {
    [[LeqiSDK shareInstance] login];
}

- (void)pay {
    [[LeqiSDK shareInstance] payWithOrderInfo:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
