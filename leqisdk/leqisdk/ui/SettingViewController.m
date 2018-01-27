//
//  SettingViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/18.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "SettingViewController.h"
#import "MenuTableViewCell.h"
#import "ModifyPasswordViewController.h"
#import "BindPhoneViewController.h"
#import "UnBindPhoneViewController.h"
#import "AuthViewController.h"

#define MENU_CELL_HEIGHT 40
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingViewController {
    UILabel *lbUserName;
    
    UIButton *btnCheckOrder;
    
    UITableView *tvMenu;
    
    UIView *serviceView;
    UIButton *btnPhone;
    UIButton *btnQQ;
    
    NSArray *datasource;
    
    NSMutableArray *orderList;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setViewHieght:250];
    
    lbUserName = [UILabel new];
    lbUserName.textColor = kColorWithHex(0x333333);
    lbUserName.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:lbUserName];
    
    btnCheckOrder = [UIButton new];
    [btnCheckOrder setTitle:@"同步订单" forState: UIControlStateNormal];
    [btnCheckOrder setTitleColor:kColorWithHex(0x19b1f5) forState: UIControlStateNormal];
    [btnCheckOrder setTitleColor:kColorWithHex(0xbfbfbf) forState: UIControlStateHighlighted];
    btnCheckOrder.font = [UIFont systemFontOfSize: 12];
    [btnCheckOrder addTarget:self action:@selector(checkOrder:) forControlEvents:UIControlEventTouchUpInside];
    btnCheckOrder.layer.borderWidth = 0.5;
    btnCheckOrder.layer.borderColor = [kColorWithHex(0x19b1f5) CGColor];
    btnCheckOrder.layer.cornerRadius = 2;
    [self.view addSubview:btnCheckOrder];
    
    //菜单
    tvMenu = [UITableView new];
    tvMenu.backgroundColor = [UIColor whiteColor];
    tvMenu.layer.cornerRadius = 2;
    tvMenu.dataSource = self;
    tvMenu.bounces = NO;
    tvMenu.delegate = self;
    tvMenu.scrollEnabled = NO;
    [self.view addSubview:tvMenu];
    
    //客服
    serviceView = [UIView new];
    serviceView.backgroundColor = [UIColor whiteColor];
    
    btnPhone = [UIButton new];
    [btnPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPhone setTitle:@"客服电话" forState:UIControlStateNormal];
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
    
    [btnQQ addTarget:self action:@selector(openQQ:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhone addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:kRefreshMenu
                                               object:nil];
    
    orderList = [[CacheHelper shareInstance] getCheckFailOrderList];
    if([orderList count] > 0){
        btnCheckOrder.hidden = NO;
    } else {
        btnCheckOrder.hidden = YES;
    }
}

#pragma mark -- 订单验证
- (void)checkOrder:(id)sender {
    [self show:@"订单校验中..."];
    __block int n = 0;
    for(NSMutableDictionary *info in orderList){
        NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/ios_order_query/p", [LeqiSDK shareInstance].configInfo.appid];
        NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
        [params setValue:[info objectForKey:@"receipt"] forKey:@"receipt"];
        [params setValue:[info objectForKey:@"order_sn"] forKey:@"order_sn"];
        [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
            if(res && [res[@"code"] integerValue] == 1){
                [orderList removeObject:info];
                [[CacheHelper shareInstance] setCheckFailOrderList:orderList];
            }
            n++;
            if(n >= [orderList count]){
                [self dismiss:nil];
            }
        } error:^(NSError * error) {
            [self showByError:error];
            n++;
            if(n >= [orderList count]){
                [self dismiss:nil];
            }
        }];
    }
}

-(void)viewDidLayoutSubviews {
    int offset = 10;
    int width = self.view.frame.size.width;
    lbUserName.frame = CGRectMake(offset,  offset , (width - offset*2), 14);
    btnCheckOrder.frame = CGRectMake(width - 70,  offset - 4 , 60, 20);
    
    [self initMenuTableView:offset y:offset + 25 w:(width - offset*2)];

    serviceView.frame = CGRectMake(offset, 205 , (width - offset*2), 26);
    btnPhone.frame = CGRectMake(50, 5 , 94, 16);
    btnQQ.frame = CGRectMake(serviceView.frame.size.width - 50 - 94, 5 , 94, 16);
    [self initUserInfo];
    
}

- (void)initUserInfo {
    NSDictionary *user = [[CacheHelper shareInstance] getCurrentUser];
    lbUserName.text = [NSString stringWithFormat: @"用户名: %@", [[self getUser] objectForKey:@"name"]];
}

- (void)initMenuTableView:(int)x y:(int)y w:(int)w {
    datasource = @[@{@"name":@"修改密码"},@{@"name":@"绑定手机号"},@{@"name":@"身份认证"},@{@"name":@"自动登录"}];
    long len = [datasource count];
    tvMenu.frame = CGRectMake(x, y , w, MENU_CELL_HEIGHT*len - 1);
    [tvMenu reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!datasource) return 0;
    return [datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"menu_cell";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = datasource[indexPath.row];
    cell.lbMenuName.text = [dict objectForKey:@"name"];
    cell.ivArrow.hidden = NO;
    cell.sAutoLogin.hidden = YES;
    if(indexPath.row == 1){
        if([[[self getUser] objectForKey:@"is_vali_mobile"] intValue] == 1){
            cell.lbSel.hidden = NO;
            cell.lbSel.text = @"(已绑定)";
            cell.lbSel.frame = CGRectMake(cell.frame.size.width - 72, 11, 60, 20);
        }
    }
    else if(indexPath.row == 2){
        if([[CacheHelper shareInstance] getRealAuth]){
            cell.ivArrow.hidden = YES;
            cell.lbSel.hidden = NO;
            cell.lbSel.text = @"(已认证)";
            cell.lbSel.frame = CGRectMake(cell.frame.size.width - 72, 11, 60, 20);
        }
    }
    else if(indexPath.row == 3){
        cell.ivArrow.hidden = YES;
        cell.sAutoLogin.hidden = NO;
    }
    
    cell.ivArrow.frame = CGRectMake(cell.frame.size.width - 28, 12, 18, 18);
    cell.sAutoLogin.frame = CGRectMake(cell.frame.size.width - 72, 4, 60, 20);
    [cell.sAutoLogin addTarget:self action:@selector(autoLogin:) forControlEvents:UIControlEventValueChanged];
    BOOL isON = [[CacheHelper shareInstance] getAutoLogin];
    [cell.sAutoLogin setOn: isON];
    return cell;
}

- (void)reload:(NSNotification *)noti {
    [tvMenu reloadData];
}

- (void)autoLogin:(id)sender {
    UISwitch *sAutoLogin = (UISwitch *)sender;
    BOOL isAutoLogin = [sAutoLogin isOn];
    [[CacheHelper shareInstance] setAutoLogin:isAutoLogin];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        ModifyPasswordViewController *modifyPasswordViewController = [ModifyPasswordViewController new];
        [self.popupController pushViewController:modifyPasswordViewController animated:YES];
    }
    else if(indexPath.row == 1){
        if([[[self getUser] objectForKey:@"is_vali_mobile"] intValue] == 1){
            UnBindPhoneViewController *unBindPhoneViewController = [UnBindPhoneViewController new];
            [self.popupController pushViewController:unBindPhoneViewController animated:YES];
        } else {
            BindPhoneViewController *bindPhoneViewController = [BindPhoneViewController new];
            [self.popupController pushViewController:bindPhoneViewController animated:YES];
        }
    }
    else if(indexPath.row == 2){
        if(![[CacheHelper shareInstance] getRealAuth]){
            AuthViewController *authViewController = [AuthViewController new];
            [self.popupController pushViewController:authViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
