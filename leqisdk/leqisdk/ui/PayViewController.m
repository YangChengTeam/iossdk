//
//  PayViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/24.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "PayViewController.h"
#import "UIAlertView+Block.h"

@interface PayViewController ()<PopupControllerDelegate, UIWebViewDelegate>

@end

@implementation PayViewController {
    UILabel *lbGood;
    UILabel *lbAmount;
    
    UIButton *btnAlipay;
    UIButton *btnWxPay;
    UILabel *lbAlipay;
    UILabel *lbWxPay;
    
    UILabel *lbRealMoeny;
    UIButton *btnPay;
    
    NSString *currentOrderId;
    
    BOOL isPaying;
    int n;
    
    UIWebView *webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值";
    n = 5;
    [self setViewHieght:160 lan:NO];
    
    webView = [UIWebView new];
    [self.view addSubview:webView];
    
    lbGood = [UILabel new];
    lbGood.textColor = kColorWithHex(0x333333);
    lbGood.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:lbGood];
    
    lbAmount = [UILabel new];
    lbAmount.textColor = kColorWithHex(0x333333);
    lbAmount.font = [UIFont systemFontOfSize: 12];
    lbAmount.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lbAmount];
    
    btnAlipay = [UIButton new];
    btnAlipay.selected = YES;
    [btnAlipay setBackgroundImage:[UIImage imageNamed:@"alipay_normal_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnAlipay setBackgroundImage:[UIImage imageNamed:@"alipay_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [btnAlipay setBackgroundImage:[UIImage imageNamed:@"alipay_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [self.view addSubview:btnAlipay];
    
    lbAlipay = [UILabel new];
    lbAlipay.textColor = kColorWithHex(0xffffff);
    lbAlipay.textAlignment = NSTextAlignmentCenter;
    lbAlipay.font = [UIFont systemFontOfSize: 12];
    lbAlipay.text = @"支付宝";
    [self.view addSubview:lbAlipay];
    
    btnWxPay = [UIButton new];
    [btnWxPay setBackgroundImage:[UIImage imageNamed:@"wxpay_normal_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [btnWxPay setBackgroundImage:[UIImage imageNamed:@"wxpay_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [btnWxPay setBackgroundImage:[UIImage imageNamed:@"wxpay_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [self.view addSubview:btnWxPay];
    
    lbWxPay = [UILabel new];
    lbWxPay.textColor = kColorWithHex(0xffffff);
    lbWxPay.font = [UIFont systemFontOfSize: 12];
    lbWxPay.text = @"微信";
    lbWxPay.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbWxPay];
    
    self.orderInfo.payways = @"alipay";
    lbRealMoeny = [UILabel new];
    lbRealMoeny.textColor = kColorWithHex(0x333333);
    lbRealMoeny.backgroundColor = kColorWithHex(0xE3E3E3);
    lbRealMoeny.font = [UIFont systemFontOfSize: 14];
    lbRealMoeny.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbRealMoeny];
    
    btnPay = [UIButton new];
    [btnPay setTitle:@"立即支付" forState: UIControlStateNormal];
    [btnPay setTitleColor:kColorWithHex(0xffffff) forState:UIControlStateNormal];
    [btnPay setBackgroundImage:[self createImageWithColor:kColorWithHex(0xEE2C2C)] forState:UIControlStateNormal];
    [btnPay setBackgroundImage:[self createImageWithColor:kColorWithHex(0x979696)] forState:UIControlStateHighlighted];
    btnPay.font = [UIFont systemFontOfSize: 12];
    [self.view addSubview:btnPay];
    
    [self initOrderInfo];
    btnAlipay.tag = 1;
    btnWxPay.tag = 2;
    [btnAlipay addTarget:self action:@selector(selectPay:) forControlEvents:UIControlEventTouchUpInside];
    [btnWxPay addTarget:self action:@selector(selectPay:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    self.popupController.delegate = self;
    
    
}

- (void)cancel {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiPay object:[NSNumber numberWithInt:LEQI_SDK_ERROR_RECHARGE_CANCELED]];
}

- (void)selectPay:(id)sender {
    int tag = (int)((UIView *)sender).tag;
    if(tag == 1){
        self.orderInfo.payways = @"alipay";
        btnAlipay.selected = YES;
        btnWxPay.selected = NO;
    }
    else if(tag == 2){
        self.orderInfo.payways = @"wxpay";
        btnAlipay.selected = NO;
        btnWxPay.selected = YES;
    }
}

- (void)checkOrder {
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/ios_order_query/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setValue:@"0" forKey:@"receipt"];
    [params setValue:currentOrderId forKey:@"order_sn"];
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        if(res && [res[@"code"] integerValue] == 1){
            [self dismiss:nil];
            [self.popupController dismissWithCompletion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiPay object:[NSNumber numberWithInt:LEQI_SDK_ERROR_NONE]];
        } else {
            if(--n <= 0){
                //[[CacheHelper shareInstance] setCheckFailOrder:params];
                [self dismiss:nil];
                [self.popupController dismissWithCompletion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiPay object:[NSNumber numberWithInt:LEQI_SDK_ERROR_RECHARGE_FAILED]];
                n = 5;
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self checkOrder];
                });
            });
        }
    } error:^(NSError * error) {
        [self showByError:error];
        if(!error){
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiPay object:[NSNumber numberWithInt:LEQI_SDK_ERROR_RECHARGE_FAILED]];
        }
    }];
}

- (void)checkingOrder {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认完成支付" message:@"校验订单,请务必完成操作，支付完成请点击[已支付]，否则点击[未支付]" delegate:nil cancelButtonTitle:@"未支付" otherButtonTitles:@"已支付", nil];
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if(buttonIndex == 1){
                    [self show:@"订单校验中..."];
                    [self checkOrder];
                }
            }];
        });
    });
}

- (void)pay:(id)sender {
    [self show:@"创建订单中..."];
    [BaseViewController payWithOrderInfo:self.orderInfo callback:^(id res) {
        if([res isKindOfClass:[NSError class]]){
            [self showByError:res];
            return;
        }
        
        [self dismiss:nil];
        if(res && [res[@"code"] integerValue] == 1){
            currentOrderId = res[@"data"][@"order_sn"];
            NSString *url = res[@"data"][@"url"];
            [self openPay:url];
            return;
        }
    }];
}

- (void)openPay:(NSString *)url{
    if([self.orderInfo.payways isEqual:@"wxpay"]){
        @try {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [self checkingOrder];
        } @catch (NSException *exception) {
        
        } @finally {
        
        }
    } else {
        [webView loadHTMLString:url baseURL:nil];
        [self checkingOrder];
    }
}



- (void)initOrderInfo {
    if(self.orderInfo){
        if(self.orderInfo.count > 1){
            self.orderInfo.productName = [NSString stringWithFormat:@"%@  数量:%d", self.orderInfo.productName, self.orderInfo.count];
        }
        lbGood.adjustsFontSizeToFitWidth = YES;
        lbGood.text = self.orderInfo.productName;
        lbAmount.text = [NSString stringWithFormat:@"订单金额: %.02f", self.orderInfo.amount];
        NSString *str =[NSString stringWithFormat:@"实付款: %.02f", self.orderInfo.amount] ;
    
        NSMutableParagraphStyle *attrStyle = [NSMutableParagraphStyle new];
        attrStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSParagraphStyleAttributeName value:attrStyle range:NSMakeRange(0, str.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:kColorWithHex(0xEE2C2C) range:NSMakeRange(4, str.length - 4)];
        lbRealMoeny.attributedText = attrStr;
    }
}

- (void)viewDidLayoutSubviews {
    int offset = 10;
    int width = self.view.frame.size.width;
    
    webView.frame = CGRectMake(0,  134, width, 1);
    
    lbGood.frame = CGRectMake(offset,  offset , width / 2 - 10, 20);
    lbAmount.frame = CGRectMake(width / 2,  offset , width / 2 - 10, 20);
    btnAlipay.frame = CGRectMake(20,  40 , 135, 63);
    btnWxPay.frame = CGRectMake(width - 155,  40 , 135, 63);
    
    lbAlipay.frame = CGRectMake(20,  82 , 135, 20);
    lbWxPay.frame = CGRectMake(width - 155,  82 , 135, 20);
    
    lbRealMoeny.frame = CGRectMake(0,  120 , width / 2 , 40);
    btnPay.frame = CGRectMake(width / 2 ,  120 , width / 2 + 2 , 40);
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
