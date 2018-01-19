//
//  AutoLoginViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/19.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "AutoLoginViewController.h"
#import "LoginViewController.h"

@interface AutoLoginViewController ()

@end

@implementation AutoLoginViewController {
    UIView *bgView;
    UIActivityIndicatorView *indicator;
    
    UILabel *lbUsername;
    
    UIButton *btnSwitch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"自动登录";
    [self setViewHieght:180];
    //self.popupController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    self.view.alpha = 0.9;
    self.view.backgroundColor = [UIColor whiteColor];
    
    bgView = [UIView new];
    [self.view addSubview:bgView];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.transform = CGAffineTransformMakeScale(2, 2);
    [bgView addSubview:indicator];
    [indicator startAnimating];

    lbUsername = [UILabel new];
    lbUsername.text = @"帐号: zhangkai";
    lbUsername.adjustsFontSizeToFitWidth = YES;
    lbUsername.textColor = kColorWithHex(0x333333);
    lbUsername.textAlignment = NSTextAlignmentCenter;
    lbUsername.font = [UIFont systemFontOfSize: 16];
    [self.view addSubview:lbUsername];
    
    //登录按钮
    btnSwitch = [[UIButton alloc] init];
    [btnSwitch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSwitch setTitle:@"切换帐号" forState:UIControlStateNormal];
    [btnSwitch setBackgroundImage:[self createImageWithColor:kColorWithHex(0x19b1f5)] forState:UIControlStateNormal];
    btnSwitch.titleLabel.font = [UIFont systemFontOfSize: 14];
    btnSwitch.layer.cornerRadius = 3;
    btnSwitch.layer.masksToBounds = YES;
    [self.view addSubview:btnSwitch];
    
    [btnSwitch addTarget:self action:@selector(switchLogin:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchLogin:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[LoginViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}

- (void)viewDidLayoutSubviews {
    int width = self.view.frame.size.width;
    bgView.frame = CGRectMake(0, 0, width, 80);
    indicator.center = bgView.center;
    lbUsername.frame = CGRectMake(0, 80, width, 20);
    btnSwitch.frame = CGRectMake((width - 120) / 2, 120, 120, 40);

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
