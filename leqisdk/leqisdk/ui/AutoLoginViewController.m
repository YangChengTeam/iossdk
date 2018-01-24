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
    
    UILabel *lUserName;
    
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
    
    lUserName = [UILabel new];
    lUserName.adjustsFontSizeToFitWidth = YES;
    lUserName.textColor = kColorWithHex(0x333333);
    lUserName.textAlignment = NSTextAlignmentCenter;
    lUserName.font = [UIFont systemFontOfSize: 16];
    [self.view addSubview:lUserName];
    
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
    
    [self initUserInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginWithAccount:[self getUserName]  password:[self getPassword]];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    if(!self.isCancel){
        NSLog(@"%@:%@", TAG, @"cancel auto login");
        self.isCancel = true;
    }
}

- (void)initUserInfo {
    lUserName.text = [NSString stringWithFormat: @"帐号: %@", [self getUserName]];
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
    lUserName.frame = CGRectMake(0, 80, width, 20);
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
