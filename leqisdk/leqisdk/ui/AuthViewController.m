//
//  AuthViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController {
    UIView *loginView;
    
    UILabel *lbAccount;
    UIView *lineAccountView;
    UITextField *tfRealName;
    
    UIView *lineBgView;
    
    UILabel *lbPass;
    UIView *linePassView;
    UITextField *tfCardNum;
    
    UIButton *btnSubmit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    [self setViewHieght:170];
    
    //登录框
    loginView = [UIView new];
    loginView.layer.cornerRadius = 3;
    loginView.layer.masksToBounds = YES;
    loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginView];
    
    lbAccount = [UILabel new];
    lbAccount.text = @"    姓名";
    lbAccount.adjustsFontSizeToFitWidth = YES;
    lbAccount.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbAccount.font = [UIFont systemFontOfSize: 14];
    
    lineAccountView = [UIView new];
    lineAccountView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfRealName = [UITextField new];
    tfRealName.placeholder = @"请输入您的姓名";
    tfRealName.font = [UIFont systemFontOfSize: 14];
    tfRealName.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    
    lineBgView = [UIView new];
    lineBgView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    
    lbPass = [UILabel new];
    lbPass.text = @"身份证";
    lbPass.adjustsFontSizeToFitWidth = YES;
    lbPass.textColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    lbPass.font = [UIFont systemFontOfSize: 14];
    
    linePassView = [UIView new];
    linePassView.backgroundColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfCardNum = [UITextField new];
    tfCardNum.placeholder = @"请输入您的身份证号";
    tfCardNum.font = [UIFont systemFontOfSize: 14];
    tfCardNum.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfCardNum.keyboardType = UIKeyboardTypeNamePhonePad;
    
    [loginView addSubview:lbAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfRealName];
    [loginView addSubview:lineBgView];
    [loginView addSubview:lbPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfCardNum];
    
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
    NSString *realName = tfRealName.text;
    NSString *cardNum = tfCardNum.text;
    
    if([realName length] < 2){
        [self alert:@"请输入真实姓名"];
        return;
    }
    
    if([cardNum length] == 0){
        [self alert:@"请输入身份证号"];
        return;
    }
   
    if([cardNum length] < 10){
        [self alert:@"请输入正确的身份证号"];
        return;
    }
    [self show:@"请稍后..."];
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/real_auth/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setObject:[[self getUser] objectForKey:@"user_id"] forKey:@"user_id"];
    [params setObject:realName  forKey:@"real_name"];
    [params setObject:cardNum  forKey:@"card_num"];
    __weak typeof(self) weakSelf = self;

    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [weakSelf dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            [weakSelf alert:@"身份认证成功"];
            [[CacheHelper shareInstance] setRealAuth];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshMenu object:nil];
            [weakSelf.popupController popToRootViewControllerAnimated:YES];
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
    loginView.frame = CGRectMake(offset,  offset , (width - offset*2), 84);
    lbAccount.frame = CGRectMake(16,  14 , 60, 18);
    lineAccountView.frame = CGRectMake(62,  12 , 0.5, 22);
    tfRealName.frame = CGRectMake(72,  12 , width - 140, 22);
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    lbPass.frame = CGRectMake(16,  14 + 42 , 60, 18);
    linePassView.frame = CGRectMake(62,  12 + 42, 0.5, 22);
    tfCardNum.frame = CGRectMake(72,  12 + 42, width - 140, 22);
    
    btnSubmit.frame = CGRectMake(offset, 105 , (width - offset*2), 40);
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
