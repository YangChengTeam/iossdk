//
//  BindPhoneModifyPasswordViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/24.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BindPhoneModifyPasswordViewController.h"

@interface BindPhoneModifyPasswordViewController ()

@end

@implementation BindPhoneModifyPasswordViewController {
    UILabel *lbPhone;
    
    UIView *loginView;
    
    UILabel *lbAccount;
    UIView *lineAccountView;
    UITextField *tfNewPass;
    
    UIView *lineBgView;
    
    UILabel *lbPass;
    UIView *linePassView;
    UITextField *tfAgainPass;
    
    UIButton *btnSubmit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self setViewHieght:190];
    
    lbPhone = [UILabel new];
    lbPhone.textColor = kColorWithHex(0x333333);
    lbPhone.font = [UIFont systemFontOfSize: 14];
    lbPhone.text = [NSString stringWithFormat:@"手机号:%@", self.phone];
    [self.view addSubview:lbPhone];
    
    //登录框
    loginView = [UIView new];
    loginView.layer.cornerRadius = 3;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    lbAccount = [UILabel new];
    lbAccount.text = @"    新密码";
    lbAccount.adjustsFontSizeToFitWidth = YES;
    lbAccount.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbAccount.font = [UIFont systemFontOfSize: 14];
    
    lineAccountView = [UIView new];
    lineAccountView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfNewPass = [UITextField new];
    tfNewPass.placeholder = @"请输入新密码";
    tfNewPass.font = [UIFont systemFontOfSize: 14];
    tfNewPass.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfNewPass.keyboardType = UIKeyboardTypeNumberPad;
    tfNewPass.secureTextEntry = true;
    
    lineBgView = [UIView new];
    lineBgView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    
    lbPass = [UILabel new];
    lbPass.text = @"确认密码";
    lbPass.adjustsFontSizeToFitWidth = YES;
    lbPass.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbPass.font = [UIFont systemFontOfSize: 14];
    
    linePassView = [UIView new];
    linePassView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfAgainPass = [UITextField new];
    tfAgainPass.placeholder = @"请输入再次新密码";
    tfAgainPass.font = [UIFont systemFontOfSize: 14];
    tfAgainPass.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfAgainPass.keyboardType = UIKeyboardTypeNumberPad;
    tfAgainPass.secureTextEntry = true;
    
    [loginView addSubview:lbAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfNewPass];
    [loginView addSubview:lineBgView];
    [loginView addSubview:lbPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfAgainPass];
    
    //登录按钮
    btnSubmit = [[UIButton alloc] init];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[self createImageWithColor:kColorWithHex(0x19b1f5)] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnSubmit.layer.cornerRadius = 3;
    btnSubmit.layer.masksToBounds = YES;
    [self.view addSubview:btnSubmit];
    
    [btnSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submit:(id)sender {
    NSString *newPass = tfNewPass.text;
    NSString *againPass = tfAgainPass.text;
    
    if([newPass length] == 0){
        [self alert:@"请输入新密码"];
        return;
    }
    NSString *pattern = @"(^[A-Za-z0-9]{6,16}$)";;
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if(![regex evaluateWithObject:newPass]){
        [self alert:@"新密码只能由6至16位英文或数字组成"];
        return;
    }
    
    if(![newPass isEqualToString:againPass]){
        [self alert:@"两次密码输入不一致"];
        return;
    }
    [self show:@"请稍后..."];
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/upd_pwd/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setObject:newPass forKey:@"new_pwd"];
    [params setObject:self.phone forKey:@"n"];
    __weak typeof(self) weakSelf = self;
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [weakSelf dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            NSMutableDictionary *user = [NSMutableDictionary new];
            [user setObject:weakSelf.phone forKey:@"mobile"];
            [user setObject:newPass forKey:@"pwd"];
            [user setObject:@"0" forKey:@"user_id"];
            
            int mainkey = 2;
            [[CacheHelper shareInstance] setUser:user mainKey:mainkey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUser object:nil];
            [(UINavigationController *)weakSelf.popupController popToRootViewControllerAnimated:YES];
        } else {
            [weakSelf alertByfail:res[@"msg"]];
        }
    } error:^(NSError * error) {
        [weakSelf showByError:error];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    int offset = 10;
    int width = self.view.frame.size.width;
    
    lbPhone.frame = CGRectMake(offset,  offset , (width - offset*2), 14);
    
    loginView.frame = CGRectMake(offset,  offset + 20, (width - offset*2), 84);
    lbAccount.frame = CGRectMake(16,  14, 80, 18);
    lineAccountView.frame = CGRectMake(82,  12 , 0.5, 22);
    tfNewPass.frame = CGRectMake(92,  12 , width - 140, 22);
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    lbPass.frame = CGRectMake(16,  14 + 42 , 80, 18);
    linePassView.frame = CGRectMake(82,  12 + 42, 0.5, 22);
    tfAgainPass.frame = CGRectMake(92,  12 + 42, width - 140, 22);
    
    btnSubmit.frame = CGRectMake(offset, 105 + 20 , (width - offset*2), 40);
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
