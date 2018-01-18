//
//  BindPhoneViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController {
    UIView *loginView;
    
    UILabel *lbAccount;
    UIView *lineAccountView;
    UITextField *tfAccount;
    
    UIView *lineBgView;
    
    UILabel *lbPass;
    UIView *linePassView;
    UITextField *tfPass;
    
    UIButton *btnCode;
    
    
    UIButton *btnSubmit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号";
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
    tfAccount = [UITextField new];
    tfAccount.placeholder = @"请输入手机号";
    tfAccount.font = [UIFont systemFontOfSize: 14];
    tfAccount.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfAccount.keyboardType = UIKeyboardTypeNumberPad;
    
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
    tfPass = [UITextField new];
    tfPass.placeholder = @"请输入验证码";
    tfPass.font = [UIFont systemFontOfSize: 14];
    tfPass.tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    tfPass.keyboardType = UIKeyboardTypeNumberPad;
    
    [loginView addSubview:lbAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfAccount];
    [loginView addSubview:lineBgView];
    [loginView addSubview:lbPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfPass];
    
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

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    int offset = 10;
    int width = self.view.frame.size.width;
    loginView.frame = CGRectMake(offset,  offset , (width - offset*2), 84);
    lbAccount.frame = CGRectMake(16,  14 , 60, 18);
    lineAccountView.frame = CGRectMake(62,  12 , 0.5, 22);
    tfAccount.frame = CGRectMake(72,  12 , width - 200, 22);
    btnCode.frame = CGRectMake(width - 100,  8, 70, 26);
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    lbPass.frame = CGRectMake(16,  14 + 42 , 60, 18);
    linePassView.frame = CGRectMake(62,  12 + 42, 0.5, 22);
    tfPass.frame = CGRectMake(72,  12 + 42, width - 240, 22);
    
    btnSubmit.frame = CGRectMake(offset, 105 , (width - offset*2), 40);
}

- (void)countDown:(id)sender {
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
