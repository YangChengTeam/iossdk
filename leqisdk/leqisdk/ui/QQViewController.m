//
//  QQViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/10.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "QQViewController.h"

@interface QQViewController ()

@end

@implementation QQViewController {
    UIButton *btnQQ;
    UILabel *lTitle;
    UIButton *btnQQ2;
    UILabel *lTitle2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"客服QQ";
    [self setViewHieght:180];
    btnQQ = [UIButton new];
    lTitle = [UILabel new];
    btnQQ2 = [UIButton new];
    lTitle2 = [UILabel new];
    
    [btnQQ setImage:[UIImage imageNamed:@"contact_qq" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnQQ setImage:[UIImage imageNamed:@"contact_qq1" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    btnQQ.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    
    lTitle.textColor = kColorWithHex(0x999999);
    lTitle.text = @"客服QQ-1";
    lTitle.textAlignment = NSTextAlignmentCenter;
    lTitle.font = [UIFont systemFontOfSize: 16];
    
    [btnQQ2 setImage:[UIImage imageNamed:@"contact_qq" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnQQ2 setImage:[UIImage imageNamed:@"contact_qq1" inBundle:leqiBundle compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    
    lTitle2.textColor = kColorWithHex(0x999999);
    lTitle2.text = @"客服QQ-2";
    lTitle2.textAlignment = NSTextAlignmentCenter;
    lTitle2.font = [UIFont systemFontOfSize: 16];
    
    [self.view addSubview:lTitle2];
    [self.view addSubview:lTitle];
    [self.view addSubview:btnQQ];
    [self.view addSubview:btnQQ2];
    
    [btnQQ addTarget:self action:@selector(openQQ) forControlEvents:UIControlEventTouchUpInside];
    [btnQQ2 addTarget:self action:@selector(openQQ2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openQQ:(NSString *)qq{
    @try {
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web"  , qq];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } @catch (NSException *exception) {
        [self alert:@"请先安装QQ"];
    } @finally {
        
    }
}


- (NSArray *)getKeQQ {
    NSDictionary *initInfo = [[CacheHelper shareInstance] getInitInfo];
    NSString *kefuQQ = [initInfo objectForKey:@"game_kefu_qq"];
    if(kefuQQ){
        return [kefuQQ componentsSeparatedByString:@","];
    }
    return nil;
}

- (void)openQQ {
    NSArray *qqs = [self getKeQQ];
    if([qqs count]){
        [self openQQ:qqs[0]];
    }
}

- (void)openQQ2 {
    NSArray *qqs = [self getKeQQ];
    if([qqs count] > 1){
        [self openQQ:qqs[1]];
    }
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    btnQQ.frame = CGRectMake(40, 20, 80, 80);
    lTitle.frame = CGRectMake(40, 105, 80, 20);
    float width = self.view.frame.size.width;
    
    btnQQ2.frame = CGRectMake(width -  120, 20, 80, 80);
    lTitle2.frame = CGRectMake(width -  120, 105, 80, 20);
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
