//
//  RegViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/10.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "RegViewController.h"
#import "LoginViewController.h"
#import "Reg2LoginViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController {
    UIImageView *ivNavTitle;
    
    UIView *loginView;
    
    UIImageView *ivAccount;
    UIView *lineAccountView;
    UITextField *tfAccount;
    
    UIView *lineBgView;
    
    UIImageView *ivPass;
    UIView *linePassView;
    UITextField *tfPass;
    UIButton *btnReg;

    UIView *serviceView;
    UIButton *btnPhone;
    UIButton *btnQQ;
    
    UIButton *btnAccount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewHieght:190];
    //导航
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 , 90, 20)];
//    UIImage *image = [UIImage imageNamed:@"quick_title_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil];
//    ivNavTitle = [[UIImageView alloc] initWithImage:image];
//    [titleView addSubview:ivNavTitle];
//    self.navigationItem.titleView = titleView;
    
    //登录框
    loginView = [UIView new];
    loginView.layer.cornerRadius = 3;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    ivAccount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_account_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil]];
    lineAccountView = [UIView new];
    lineAccountView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfAccount = [UITextField new];
    tfAccount.placeholder = @"请输入帐号";
    tfAccount.font = [UIFont systemFontOfSize: 14];
    tfAccount.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfAccount.keyboardType = UIKeyboardTypeNamePhonePad;

    lineBgView = [UIView new];
    lineBgView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    
    ivPass =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil]];
    linePassView = [UIView new];
    linePassView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfPass = [UITextField new];
    tfPass.placeholder = @"请输入密码";
    tfPass.font = [UIFont systemFontOfSize: 14];
    tfPass.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfPass.keyboardType = UIKeyboardTypeNamePhonePad;
    tfPass.secureTextEntry = YES;
    
    [loginView addSubview:ivAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfAccount];
    [loginView addSubview:lineBgView];
    [loginView addSubview:ivPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfPass];
    
    //登录按钮
    btnReg = [[UIButton alloc] init];
    [btnReg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReg setTitle:@"注册" forState:UIControlStateNormal];
    [btnReg setBackgroundImage:[self createImageWithColor:kColorWithHex(0x19b1f5)] forState:UIControlStateNormal];
    [btnReg setBackgroundImage:[self createImageWithColor:kColorWithHex(0x979696)] forState:UIControlStateHighlighted];
    btnReg.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnReg.layer.cornerRadius = 3;
    btnReg.layer.masksToBounds = YES;
    [self.view addSubview:btnReg];
    
    //客服
    serviceView = [UIView new];
    serviceView.backgroundColor = [UIColor whiteColor];
    serviceView.hidden = YES;
    
    btnPhone = [UIButton new];
    [btnPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPhone setTitle:@"客服电话:400-796-6071" forState:UIControlStateNormal];
    [btnPhone setImage:[UIImage imageNamed:@"call_service_icon" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnPhone setTitleColor:kColorWithHex(0x999999) forState:UIControlStateNormal];
    btnPhone.titleLabel.font = [UIFont systemFontOfSize: 12];
    btnPhone.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [btnPhone setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    btnPhone.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [serviceView addSubview:btnPhone];
    
    btnQQ = [UIButton new];
    [btnQQ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnQQ setTitle:@"客服QQ" forState:UIControlStateNormal];
    [btnQQ setImage:[UIImage imageNamed:@"qq_kefu_icon" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnQQ setTitleColor:kColorWithHex(0x999999) forState:UIControlStateNormal];
    btnQQ.titleLabel.font = [UIFont systemFontOfSize: 12];
    btnQQ.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    btnQQ.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [btnQQ setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [serviceView addSubview:btnQQ];
    [self.view addSubview:serviceView];
    
    //已有帐号登录
    btnAccount = [UIButton new];
    [btnAccount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAccount setTitle:@"已有帐号登录" forState:UIControlStateNormal];
    [btnAccount setTitleColor:kColorWithHex(0x999999) forState:UIControlStateNormal];
    [btnAccount setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateHighlighted];
    btnAccount.titleLabel.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:btnAccount];
    btnReg.layer.masksToBounds = YES;
    
    //事件
    [btnQQ addTarget:self action:@selector(openQQ:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPhone addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAccount addTarget:self action:@selector(openAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnReg addTarget:self action:@selector(reg:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reg:(id)sender {
    NSString *username = tfAccount.text;
    NSString *password = tfPass.text;
    if([username length] == 0){
        [self alert:@"请输入账号"];
        return;
    }
    if([password length] == 0){
        [self alert:@"请输入密码"];
        return;
    }
    NSString *pattern = @"(^[A-Za-z0-9]{6,16}$)";;
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if(![regex evaluateWithObject:username]){
        [self alert:@"账号只能由6至16位英文或数字组成"];
        return;
    }
    
    if(![regex evaluateWithObject:password]){
        [self alert:@"密码只能由6至16位16位英文或数字组成"];
        return;
    }
    
    [self show:@"注册中..."];
    [self regWithAccount:username password:password isQuick:FALSE callback:nil];
}

- (void)openAccount:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[LoginViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}

- (void)openLogin:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[RegViewController new]];
    popupController.containerView.layer.cornerRadius = 4;

    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    ivNavTitle.frame = CGRectMake(0,  0 , 90, 20);
    int offset = 10;
    int width = self.view.frame.size.width;
    loginView.frame = CGRectMake(offset,  offset , (width - offset*2), 84);
    ivAccount.frame = CGRectMake(16,  14 , 18, 18);
    lineAccountView.frame = CGRectMake(40,  12 , 0.5, 22);
    tfAccount.frame = CGRectMake(50,  12 , width - 68, 22);
   
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    ivPass.frame = CGRectMake(16,  14 + 42 , 18, 18);
    linePassView.frame = CGRectMake(40,  12 + 42, 0.5, 22);
    tfPass.frame = CGRectMake(50,  12 + 42, width - 68, 22);
    btnReg.frame = CGRectMake(offset, 105 , (width - offset*2), 40);
    
    serviceView.frame = CGRectMake(offset, 150 , (width - offset*2), 26);
    btnPhone.frame = CGRectMake((width - 285) / 2, 5 , 175, 16);
    btnQQ.frame = CGRectMake((width - 285) / 2 + 150, 5 , 94, 16);
    
    btnAccount.frame = CGRectMake(5, 155 , 100, 16);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
