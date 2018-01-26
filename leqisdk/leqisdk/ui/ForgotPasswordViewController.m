//
//  ForgotPasswordViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/10.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "BindPhoneModifyPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController {
    UIView *loginView;
    
    UILabel *lbAccount;
    UIView *lineAccountView;
    UITextField *tfPhone;
    
    UIView *lineBgView;
    
    UILabel *lbPass;
    UIView *linePassView;
    UITextField *tfCode;
    
    UIButton *btnCode;
    
    
    UIButton *btnSubmit;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证手机-重置密码";
    [self setViewHieght:170];
    //登录框
    loginView = [UIView new];
    loginView.layer.cornerRadius = 3;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    lbAccount = [UILabel new];
    lbAccount.text = @"手机号";
    lbAccount.adjustsFontSizeToFitWidth = YES;
    lbAccount.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbAccount.font = [UIFont systemFontOfSize: 14];

    lineAccountView = [UIView new];
    lineAccountView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfPhone = [UITextField new];
    tfPhone.placeholder = @"请输入手机号";
    tfPhone.font = [UIFont systemFontOfSize: 14];
    tfPhone.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    
    lineBgView = [UIView new];
    lineBgView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    
    lbPass = [UILabel new];
    lbPass.text = @"验证码";
    lbPass.adjustsFontSizeToFitWidth = YES;
    lbPass.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbPass.font = [UIFont systemFontOfSize: 14];
    
    btnCode = [UIButton new];
    btnCode.font = [UIFont systemFontOfSize: 12];
    btnCode.layer.borderWidth = 0.5;
    btnCode.layer.borderColor = [kColorWithHex(0x19b1f5) CGColor];
    btnCode.layer.cornerRadius = 2;
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnCode setTitleColor:kColorWithHex(0x19b1f5) forState: UIControlStateNormal];
    [btnCode setTitleColor:kColorWithHex(0xbfbfbf) forState: UIControlStateHighlighted];
    [loginView addSubview:btnCode];
    
    linePassView = [UIView new];
    linePassView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfCode = [UITextField new];
    tfCode.placeholder = @"请输入验证码";
    tfCode.font = [UIFont systemFontOfSize: 14];
    tfCode.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfCode.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [loginView addSubview:lbAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfPhone];
    [loginView addSubview:lineBgView];
    [loginView addSubview:lbPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfCode];
    
    //登录按钮
    btnSubmit = [[UIButton alloc] init];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[self createImageWithColor:kColorWithHex(0x19b1f5)] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnSubmit.layer.cornerRadius = 3;
    btnSubmit.layer.masksToBounds = YES;
    [self.view addSubview:btnSubmit];
    
    //事件
    [btnCode addTarget:self action:@selector(countDown:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submit:(id)sender {
    NSString *phone = tfPhone.text;
    NSString *code = tfCode.text;
    
    if([phone length] == 0){
        [self alert:@"请输入手机号"];
        return;
    }
    
    if([code length] == 0){
        [self alert:@"请输入验证码"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/mobile_regORlogin/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setObject:phone forKey:@"m"];
    [params setObject:code forKey:@"code"];
    
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [self dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            BindPhoneModifyPasswordViewController *bindPhoneModifyPasswordViewController = [BindPhoneModifyPasswordViewController new];
            bindPhoneModifyPasswordViewController.phone = phone;
            [self.popupController pushViewController:bindPhoneModifyPasswordViewController animated:YES];
        } else {
            [self alertByfail:res[@"msg"]];
        }
    } error:^(NSError * error) {
        [self showByError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    int offset = 10;
    int width = self.view.frame.size.width;
    loginView.frame = CGRectMake(offset,  offset , (width - offset*2), 84);
    lbAccount.frame = CGRectMake(16,  14 , 60, 18);
    lineAccountView.frame = CGRectMake(62,  12 , 0.5, 22);
    tfPhone.frame = CGRectMake(72,  12 , width - 200, 22);
    btnCode.frame = CGRectMake(width - 100,  8, 70, 26);
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    lbPass.frame = CGRectMake(16,  14 + 42 , 60, 18);
    linePassView.frame = CGRectMake(62,  12 + 42, 0.5, 22);
    tfCode.frame = CGRectMake(72,  12 + 42, width - 240, 22);
    
    btnSubmit.frame = CGRectMake(offset, 105 , (width - offset*2), 40);
}

- (void)countDown:(id)sender {
    
    NSString *phone = tfPhone.text;
    if([phone length] == 0){
        [self alert:@"请输入手机号"];
        return;
    }
    
    [self show:@"获取中..."];
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/send_code/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setObject:phone forKey:@"m"];
    
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [self dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            [self dismiss:nil];
            [self initWithGCD:59 beginState:^(int seconds){
                [btnCode setTitle:[NSString stringWithFormat:@"%d秒后重试",seconds] forState:UIControlStateNormal];
                [btnCode setTitleColor:kColorWithHex(0x999999) forState:UIControlStateNormal];
                btnCode.layer.borderColor = [kColorWithHex(0x999999) CGColor];
                btnCode.userInteractionEnabled = NO;
            } endState:^{
                [btnCode setTitle:@"重新发送" forState:UIControlStateNormal];
                btnCode.layer.borderColor = [kColorWithHex(0x19b1f5) CGColor];
                [btnCode setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateNormal];
                btnCode.userInteractionEnabled = YES;
            }];
            [self alert:@"验证码已发送，请注意查收"];
        } else {
            [self alertByfail:res[@"msg"]];
        }
    } error:^(NSError * error) {
        [self showByError:error];
    }];
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
