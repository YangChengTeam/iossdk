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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leqiPayResult:)
                                                 name:kLeqiSDKNotiPay
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leqiLogoutResult:)
                                                 name:kLeqiSDKNotiLogout
                                               object:nil];
}

- (void)leqiLoginResult:(NSNotification *)notify {
    
    NSLog(@"%@", notify.object);
}

- (void)leqiPayResult:(NSNotification *)notify {
    NSLog(@"%@", notify.object);
}

- (void)leqiLogoutResult:(NSNotification *)notify {
    [[LeqiSDK shareInstance] login];
    NSLog(@"%@", notify.object);
}

- (void)viewDidAppear:(BOOL)animated {
    [[LeqiSDK shareInstance] showFloatView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[LeqiSDK shareInstance] hideFloatView];
}

- (void)login {
    if([LeqiSDK shareInstance].user){
        [[LeqiSDK shareInstance] logout];
        return;
    }
    [[LeqiSDK shareInstance] login];
}

- (void)pay {
    LeqiSDKOrderInfo *orderInfo = [LeqiSDKOrderInfo new];
    orderInfo.goodId = @"com.leqi.xianmosy_60";
    orderInfo.productName = @"阴阳师:640枚勾玉";
    orderInfo.amount = 0.02;
    orderInfo.count = 2;
    orderInfo.roleId = @"111";
    orderInfo.orderId = @"111111111";
    orderInfo.serverId = @"11111122";
    [[LeqiSDK shareInstance] payWithOrderInfo:orderInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
