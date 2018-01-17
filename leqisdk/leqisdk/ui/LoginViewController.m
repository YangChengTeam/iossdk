//
//  LoginViewController.m
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "LoginViewController.h"
#import "QQViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegViewController.h"
#import "Reg2LoginViewController.h"
#import "UserTableViewCell.h"


#define USER_CELL_HEIGHT 40
@interface LoginViewController()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation LoginViewController {
    UIImageView *ivNavTitle;
    
    UIView *loginView;
    
    UIImageView *ivAccount;
    UIView *lineAccountView;
    UITextField *tfAccount;
    
    
    UIView *btnAccountView;
    
    UIView *lineBgView;
    
    UIImageView *ivPass;
    UIView *linePassView;
    UITextField *tfPass;
    UIButton *btnLogin;
    UIButton *btnMoreAccount;
    
    UIButton *btnForgot;
    
    UITableView *tvMoreAccount;
    
    UIView *serviceView;
    UIButton *btnPhone;
    UIButton *btnQQ;
    
    UIButton *btnReg;
    
    UIButton *btnTryPlay;
    
    NSArray *datasource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setViewHieght:190];
    //导航
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,  0 , 90, 20)];
    UIImage *image = [UIImage imageNamed:@"quick_title_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil];
    ivNavTitle = [[UIImageView alloc] initWithImage:image];
    [titleView addSubview:ivNavTitle];
    self.navigationItem.titleView = titleView;
    
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
    
    btnMoreAccount =  [UIButton new];
    [btnMoreAccount setImage:[UIImage imageNamed:@"more_account_normal_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnMoreAccount setImage:[UIImage imageNamed:@"more_account_select_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    btnAccountView = [UIView new];
    
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
    
    btnForgot = [UIButton new];
    [btnForgot setTitle:@"忘记密码" forState: UIControlStateNormal];
    [btnForgot setTitleColor:kColorWithHex(0x333333) forState:UIControlStateNormal];
    [btnForgot setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateHighlighted];
    btnForgot.font = [UIFont systemFontOfSize: 12];

    [loginView addSubview:ivAccount];
    [loginView addSubview:lineAccountView];
    [loginView addSubview:tfAccount];
    [loginView addSubview:btnAccountView];
    [btnAccountView addSubview:btnMoreAccount];
    [loginView addSubview:btnForgot];
    
    [loginView addSubview:lineBgView];
    
    [loginView addSubview:ivPass];
    [loginView addSubview:linePassView];
    [loginView addSubview:tfPass];
    
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
    
    //注册
    btnReg = [UIButton new];
    [btnReg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReg setTitle:@"账号注册" forState:UIControlStateNormal];
    [btnReg setImage:[UIImage imageNamed:@"quick_register_icon" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnReg setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateNormal];
    btnReg.titleLabel.font = [UIFont systemFontOfSize: 12];
    btnReg.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    btnReg.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [self.view addSubview:btnReg];
    
    tvMoreAccount = [UITableView new];
    [self.view addSubview:tvMoreAccount];
    tvMoreAccount.backgroundColor = kColorWithHex(0xf1f1f1);
    tvMoreAccount.layer.borderColor = [kColorWithHex(0xbfbfbf) CGColor];
    tvMoreAccount.layer.borderWidth = 0.5;
    tvMoreAccount.hidden = YES;
    tvMoreAccount.alpha = 0.9;
    tvMoreAccount.dataSource = self;
    tvMoreAccount.delegate = self;
    btnLogin.layer.masksToBounds = YES;
    
    //已有帐号登录
    btnTryPlay = [UIButton new];
    [btnTryPlay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTryPlay setTitle:@"一键试玩" forState:UIControlStateNormal];
    [btnTryPlay setImage:[UIImage imageNamed:@"change_icon1" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    btnTryPlay.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    [btnTryPlay setTitleColor:kColorWithHex(0x666666) forState:UIControlStateNormal];
    btnTryPlay.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 0, 0);
    [btnTryPlay setImageEdgeInsets:UIEdgeInsetsMake(5, 65, 0, 0)];
    //[btnTryPlay setTitleColor:kColorWithHex(0x19b1f5) forState:UIControlStateHighlighted];
    btnTryPlay.titleLabel.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:btnTryPlay];
    
    //事件
    [btnMoreAccount addTarget:self action:@selector(toogleAccout:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(toogleAccout:)];
    [btnAccountView addGestureRecognizer:singleFingerTap];
    
    [btnQQ addTarget:self action:@selector(openQQ:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPhone addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnForgot addTarget:self action:@selector(openForgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnReg addTarget:self action:@selector(openReg:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnLogin addTarget:self action:@selector(openLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnTryPlay addTarget:self action:@selector(tryPlay:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tryPlay:(id)sender {
    [self show:@"请稍后..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismiss:nil];
            [self.popupController popViewControllerAnimated:NO];
            [self.popupController dismiss];
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[Reg2LoginViewController new]];
            popupController.containerView.layer.cornerRadius = 4;
            [popupController presentInViewController:[BaseViewController getCurrentViewController]];
        });
    });
}

- (void)openLogin:(id)sender {
    [self show:@"正在登录"];
}

- (void)toogleAccout:(id)sender {
    
    tvMoreAccount.hidden = !tvMoreAccount.hidden;
    [tvMoreAccount setNeedsLayout];
}

- (void)openReg:(id)sender {
    [self.popupController popViewControllerAnimated:NO];
    [self.popupController dismiss];
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[RegViewController new]];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController getCurrentViewController]];
}

- (void)openForgotPassword:(id)sender {
    [self.popupController pushViewController:[ForgotPasswordViewController new] animated:YES];
}

- (void)openQQ:(id)sender {
    [self.popupController pushViewController:[QQViewController new] animated:YES];
}

- (void)openPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-796-6071"]];
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
    tfAccount.frame = CGRectMake(50,  12 , width - 100, 22);
    btnAccountView.frame = CGRectMake(loginView.frame.size.width - 52,  0 , 42, 42);
    btnMoreAccount.frame = CGRectMake(20,  13 , 20, 20);
    lineBgView.frame = CGRectMake(10,  42 , (width - offset*2) - 20, 0.5);
    
    ivPass.frame = CGRectMake(16,  14 + 42 , 18, 18);
    linePassView.frame = CGRectMake(40,  12 + 42, 0.5, 22);
    tfPass.frame = CGRectMake(50,  12 + 42, width - 140, 22);
    btnForgot.frame = CGRectMake(loginView.frame.size.width - 80,  12 + 42, 80, 22);
    serviceView.frame = CGRectMake(offset, 150 , (width - offset*2), 26);
    btnPhone.frame = CGRectMake((width - 285) / 2, 5 , 175, 16);
    btnQQ.frame = CGRectMake((width - 285) / 2 + 150, 5 , 94, 16);
    
    btnLogin.frame = CGRectMake(offset, 105, (width - offset*2), 40);
    btnReg.frame = CGRectMake(0, 155 , 100, 16); //186
    btnTryPlay.frame = CGRectMake(width - 90, 155 , 90, 16); // 185
    
    [self initUserTableView:loginView.frame.origin.x +50 y: loginView.frame.origin.y + 42 w:width - 100 ];
    if(datasource && [datasource count] > 1){
        ivAccount.hidden = NO;
    } else {
        ivAccount.hidden = YES;
    }
}

- (void)initUserTableView:(int)x y:(int)y w:(int)w {
    datasource = @[@{@"name":@"zhangkai"},@{@"name":@"dinghui"}];
    long len = [datasource count];
    if(len > 3){
        len = 3;
    }
    tvMoreAccount.frame = CGRectMake(x, y , w, USER_CELL_HEIGHT*len);
    [tvMoreAccount reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!datasource) return 0;
    return [datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"user_cell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = datasource[indexPath.row];
    cell.lbUsername.text = [dict objectForKey:@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return USER_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
    NSDictionary *userDict = datasource[indexPath.row];
    tfAccount.text = [userDict objectForKey:@"name"];
    tfPass.text = [userDict objectForKey:@"name"];
    tvMoreAccount.hidden = YES;
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
