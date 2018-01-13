//
//  Reg2LoginViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/10.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "Reg2LoginViewController.h"
#import "LoginViewController.h"
#import "QQViewController.h"
#import "RegViewController.h"

@interface Reg2LoginViewController ()

@end

@implementation Reg2LoginViewController {
    UIImageView *ivNavTitle;
    
    UILabel *lUserName;
    
    UIButton *btnLogin;
    
    UIView *serviceView;
    UIButton *btnPhone;
    UIButton *btnQQ;
    
    UIButton *btnOtherLogin;
    UIButton *btnReg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewHieght:190];

    //导航
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 , 90, 20)];
    UIImage *image = [UIImage imageNamed:@"quick_title_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil];
    ivNavTitle = [[UIImageView alloc] initWithImage:image];
    [titleView addSubview:ivNavTitle];
    self.navigationItem.titleView = titleView;
    
    //用户名
    lUserName = [UILabel new];
    lUserName.text = @"帐号: zhangkai";
    lUserName.font = [UIFont systemFontOfSize: 16];
    lUserName.textColor = kColorWithHex(0x999999);
    lUserName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lUserName];
    
    //登录按钮
    btnLogin = [[UIButton alloc] init];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitle:@"进入游戏" forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[self createImageWithColor:kColorWithHex(0x19b1f5)] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[self createImageWithColor:kColorWithHex(0x979696)] forState:UIControlStateHighlighted];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnLogin.layer.cornerRadius = 3;
    btnLogin.layer.masksToBounds = YES;
    [self.view addSubview:btnLogin];
    
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
    btnOtherLogin = [UIButton new];
    [btnOtherLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnOtherLogin setTitle:@"其它登录方式" forState:UIControlStateNormal];
    [btnOtherLogin setImage:[UIImage imageNamed:@"change_icon1" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    btnOtherLogin.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [btnOtherLogin setTitleColor:kColorWithHex(0x666666) forState:UIControlStateNormal];
    btnOtherLogin.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 0, 0);
    [btnOtherLogin setImageEdgeInsets:UIEdgeInsetsMake(5, 95, 0, 0)];
    //[btnOtherLogin setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateHighlighted];
    btnOtherLogin.titleLabel.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:btnOtherLogin];
    
    //注册
    btnReg = [UIButton new];
    btnReg.hidden = YES;
    [btnReg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReg setTitle:@"快速注册" forState:UIControlStateNormal];
    [btnReg setImage:[UIImage imageNamed:@"quick_register_icon" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnReg setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateNormal];
    btnReg.titleLabel.font = [UIFont systemFontOfSize: 12];
    btnReg.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    btnReg.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.view addSubview:btnReg];
    
    //事件
    [btnOtherLogin addTarget:self action:@selector(openOtherLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btnQQ addTarget:self action:@selector(openQQ:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhone addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];
    [btnReg addTarget:self action:@selector(openReg:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openReg:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[RegViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}

- (void)openQQ:(id)sender {
    [self.popupController pushViewController:[QQViewController new] animated:YES];
}

- (void)openPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-796-6071"]];
}

- (void)openOtherLogin:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[LoginViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}


- (void)viewDidLayoutSubviews {
    ivNavTitle.frame = CGRectMake(0,  0 , 90, 20);
    int offset = 10;
    int width = self.view.frame.size.width;
    lUserName.frame = CGRectMake(offset,  offset , (width - offset*2), 84);
    btnLogin.frame = CGRectMake(offset, 105 , (width - offset*2), 40);
    
    serviceView.frame = CGRectMake(offset, 150 , (width - offset*2), 26);
    btnPhone.frame = CGRectMake((width - 285) / 2, 5 , 175, 16);
    btnQQ.frame = CGRectMake((width - 285) / 2 + 150, 5 , 94, 16);
    
    btnOtherLogin.frame = CGRectMake(width - 120, 155 , 120, 16);
    btnReg.frame = CGRectMake(5, 156 , 100, 16);

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
