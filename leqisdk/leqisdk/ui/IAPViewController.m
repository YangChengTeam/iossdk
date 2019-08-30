//
//  IAPViewController.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/24.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "IAPViewController.h"
#import "UIAlertView+Block.h"
#import "Base64.h"

static NSString *ic_cz = @"WZP54mcW9iLZHdocb2YkrKHbmqeGcJKzME1936LsUi5n7CwAh0Na8MyWy1savMBJVp1nawTXwvgfsK4mlbIXSRrv9+dio1tkCGNKTBMBAEyxZYgyfgjgr1ptQ0wkqNrnfGbdDwf08CaUoY+FxGW14Nfk98+hA70iRLCNfmQA0AA=";
static NSString *ic_zb = @"PgMntjP4OhuRjfVdVVGiS2kKl5cfKNFw4DzAPa9KiTVk7gDUcL3mlLM7OnvwCDEZaPo4CIYE4YV6MLKHxHlGVeeRMNP6Onjqdc+Xmj26+OgfPHyviwpO9g39FDPwMUM1ejaeVesJTZsEZKf/gvcghuw1RajCUgBVQxSDKuPq3A0=";
static NSString *ic_wcx = @"i6QkV9yrve4+0Gf5PHKGD81zEDzdRoU3xHsA/qLophz3Q/uvK/KPqJp7pgmncyL1wgJ4RgIifnfJr7VCbTm/jsLbBM1ZA558leZxjQKSieNkFH7ptM93gQk2M7tf+yCVYWPCLHG3tHnmI10riIFJDOh17khwzHeAhknJQK+Zawc=";
static NSString *ic_pcs = @"lu9xNYyf1AFtoDjP23cBdoTdBM75AqC6uvPiOXspBYe72skmnprC4TIjd08bmnncqIp2NI1AvYe/P/sYmPn6ap3w/fKce5I5oNN7+mWHQ0Ree+ZgRwOjtaCTCudhxekAMhzy92ldGDKbXnQBcCKzmPMYyBYxWQj5A30F3UKgCiA=";
static NSString *ic_zbs = @"BlwIncwnR67PV8tbh4MSiZCR+oj3KGP40/iJ2fvWIVZTu48GfacoxPLfv8javuXCImvJYLqVd0LXm9jvG8RkiO+k+4oXwBkZa5CShNcDRqZFlXRnjxDKz3IfU/Kze1nJsLX2jici+1Kjfcxf9tHNjNmw3P/93JN353qQ88V8WNw=";
static NSString *ic_wcxs = @"ZeaFa1mGTHgL0QOueg3hEylYxpQCys+6aHYwt5dBtZ0eDqTMdgfRlXSF4g1LUrin9QvC+h6EHtLQ+h4G9woWv+zzzQX0HImNiMCAQS2DuiD0vgSQhYtilkoywQCWNZUwYkSbrRlauel6pYi/tBjduVRyeVpL5I2jhs0sHawVAIw=";
static NSString *ic_ee = @"WJPFH/vgAho7klpeiK8TPKrN9D7NAS14Zf87PV/KLuKJZfJbNE8BsEvvxttuPDacyK8iQfeC6VoVvUIt1WAFHjJeaESNh5qAQOdvvC3C3P8Fe0J4LA8NVeKj7hVU9xvnykJr8ICV7bSenVQExr5g+OWLNjsYPxfuqUEqEVj36Eg=";
@interface IAPViewController ()

@end



@implementation IAPViewController {
    UILabel *lbGood;
    UILabel *lbAmount;
    
    UIButton *iap1Bt;
    UIButton *iap2Bt;
    UILabel *ipa1Label;
    UILabel *iap2Label;
    
    UILabel *lbRealMoeny;
    UIButton *btnPay;
    
    NSString *currentOrderId;
    
    BOOL isPaying;
    int n;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ic_cz.keyDecrypt;
    n = 5;
    [self setViewHieght:160 lan:NO];
    

    
    lbGood = [UILabel new];
    lbGood.textColor = kColorWithHex(0x333333);
    lbGood.font = [UIFont systemFontOfSize: 14];
    [self.view addSubview:lbGood];
    
    lbAmount = [UILabel new];
    lbAmount.textColor = kColorWithHex(0x333333);
    lbAmount.font = [UIFont systemFontOfSize: 12];
    lbAmount.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lbAmount];
    
    iap1Bt = [UIButton new];
    iap1Bt.selected = YES;
    [iap1Bt setBackgroundImage:[UIImage imageNamed:@"py1_normal_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [iap1Bt setBackgroundImage:[UIImage imageNamed:@"py1_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [iap1Bt setBackgroundImage:[UIImage imageNamed:@"py1_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [self.view addSubview:iap1Bt];
    
    ipa1Label = [UILabel new];
    ipa1Label.textColor = kColorWithHex(0xffffff);
    ipa1Label.textAlignment = NSTextAlignmentCenter;
    ipa1Label.font = [UIFont systemFontOfSize: 12];
    ipa1Label.text = ic_zb.keyDecrypt;
    [self.view addSubview:ipa1Label];
    
    iap2Bt = [UIButton new];
    [iap2Bt setBackgroundImage:[UIImage imageNamed:@"py2_normal_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [iap2Bt setBackgroundImage:[UIImage imageNamed:@"py2_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [iap2Bt setBackgroundImage:[UIImage imageNamed:@"py2_selected_icon" inBundle:leqiBundle  compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [self.view addSubview:iap2Bt];
    
    iap2Label = [UILabel new];
    iap2Label.textColor = kColorWithHex(0xffffff);
    iap2Label.font = [UIFont systemFontOfSize: 12];
    iap2Label.text = ic_wcx.keyDecrypt;
    iap2Label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:iap2Label];
    
    self.orderInfo.payways = ic_zbs.keyDecrypt;
    lbRealMoeny = [UILabel new];
    lbRealMoeny.textColor = kColorWithHex(0x333333);
    lbRealMoeny.backgroundColor = kColorWithHex(0xE3E3E3);
    lbRealMoeny.font = [UIFont systemFontOfSize: 14];
    lbRealMoeny.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbRealMoeny];
    
    btnPay = [UIButton new];
    [btnPay setTitle:ic_pcs.keyDecrypt forState: UIControlStateNormal];
    [btnPay setTitleColor:kColorWithHex(0xffffff) forState:UIControlStateNormal];
    [btnPay setBackgroundImage:[self createImageWithColor:kColorWithHex(0xEE2C2C)] forState:UIControlStateNormal];
    [btnPay setBackgroundImage:[self createImageWithColor:kColorWithHex(0x979696)] forState:UIControlStateHighlighted];
    btnPay.font = [UIFont systemFontOfSize: 12];
    [self.view addSubview:btnPay];
    
    [self initOrderInfo];
    iap1Bt.tag = 1;
    iap2Bt.tag = 2;
    [iap1Bt addTarget:self action:@selector(selectPay:) forControlEvents:UIControlEventTouchUpInside];
    [iap2Bt addTarget:self action:@selector(selectPay:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnPay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    //self.popupController.delegate = self;
    
    
}

- (void)cancel {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiPay object:[NSNumber numberWithInt:LEQI_SDK_ERROR_RECHARGE_CANCELED]];
}

- (void)selectPay:(id)sender {
    int tag = (int)((UIView *)sender).tag;
    if(tag == 1){
        self.orderInfo.payways = ic_zbs.keyDecrypt;
        iap1Bt.selected = YES;
        iap2Bt.selected = NO;
    }
    else if(tag == 2){
        self.orderInfo.payways = ic_wcxs.keyDecrypt;
        iap1Bt.selected = NO;
        iap2Bt.selected = YES;
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
    __weak typeof(self) weakSelf = self;
    [BaseViewController payWithOrderInfo:self.orderInfo callback:^(id res) {
        if([res isKindOfClass:[NSError class]]){
            [weakSelf showByError:res];
            return;
        }
        
        [weakSelf dismiss:nil];
        if(res && [res[@"code"] integerValue] == 1){
            currentOrderId = res[@"data"][@"order_sn"];
            NSString *url = res[@"data"][@"url"];
            [weakSelf openPay:url];
            return;
        }
    }];
}

- (void)openPay:(NSString *)url{
    if(![self.orderInfo.payways isEqual:ic_wcxs.keyDecrypt]){
        url = [NSString stringWithFormat:@"http://%@.6071.com/pay/%@",ic_ee.keyDecrypt, currentOrderId];
    }
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        [self checkingOrder];
    } @catch (NSException *exception) {
        
    } @finally {
        
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
        
    lbGood.frame = CGRectMake(offset,  offset , width / 2 - 10, 20);
    lbAmount.frame = CGRectMake(width / 2,  offset , width / 2 - 10, 20);
    iap1Bt.frame = CGRectMake(20,  40 , 135, 63);
    iap2Bt.frame = CGRectMake(width - 155,  40 , 135, 63);
    
    ipa1Label.frame = CGRectMake(20,  82 , 135, 20);
    iap2Label.frame = CGRectMake(width - 155,  82 , 135, 20);
    
    lbRealMoeny.frame = CGRectMake(0,  120 , width / 2 , 40);
    btnPay.frame = CGRectMake(width / 2 ,  120 , width / 2 + 2 , 40);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[LeqiSDK shareInstance] hideFloatView];
}

- (void)dealloc {
    [[LeqiSDK shareInstance] showFloatView];
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
