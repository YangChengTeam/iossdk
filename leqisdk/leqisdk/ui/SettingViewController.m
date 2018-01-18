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
#import "AuthViewController.h"

#define MENU_CELL_HEIGHT 40
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingViewController {
    UILabel *lbNickname;
    
    UITableView *tvMenu;
    
    UIView *serviceView;
    UIButton *btnPhone;
    UIButton *btnQQ;
    
    NSArray *datasource;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setViewHieght:210];
    
    lbNickname = [UILabel new];
    lbNickname.textColor = kColorWithHex(0x333333);
    lbNickname.font = [UIFont systemFontOfSize: 14];
    lbNickname.text = @"帐号:zhangkai";
    [self.view addSubview:lbNickname];
    
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
    
    [btnQQ addTarget:self action:@selector(openQQ:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPhone addTarget:self action:@selector(openPhone:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidLayoutSubviews {
    int offset = 10;
    int width = self.view.frame.size.width;
    lbNickname.frame = CGRectMake(offset,  offset , (width - offset*2), 14);
    
    [self initMenuTableView:offset y:offset + 25 w:(width - offset*2)];
    
    serviceView.frame = CGRectMake(offset, 165 , (width - offset*2), 26);
    btnPhone.frame = CGRectMake((width - 285) / 2, 5 , 175, 16);
    btnQQ.frame = CGRectMake((width - 285) / 2 + 150, 5 , 94, 16);
    
}

- (void)initMenuTableView:(int)x y:(int)y w:(int)w {
    datasource = @[@{@"name":@"修改密码"},@{@"name":@"绑定手机号"},@{@"name":@"身份认证"}];
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
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = datasource[indexPath.row];
    cell.lbMenuName.text = [dict objectForKey:@"name"];
    cell.ivArrow.frame = CGRectMake(cell.frame.size.width - 28, 12, 18, 18);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
    if(indexPath.row == 0){
        ModifyPasswordViewController *modifyPasswordViewController = [ModifyPasswordViewController new];
        [self.popupController pushViewController:modifyPasswordViewController animated:YES];
    }
    else if(indexPath.row == 1){
        BindPhoneViewController *bindPhoneViewController = [BindPhoneViewController new];
        [self.popupController pushViewController:bindPhoneViewController animated:YES];
    }
    else if(indexPath.row == 2){
        AuthViewController *authViewController = [AuthViewController new];
        [self.popupController pushViewController:authViewController animated:YES];
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
