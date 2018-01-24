//
//  YC6071SDK.m
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "LeqiSDK.h"
#import "LoginViewController.h"
#import "STPopup.h"
#import "IAPManager.h"
#import "Reg2LoginViewController.h"
#import "NetUtils.h"
#import "XHFloatWindow.h"
#import "SettingViewController.h"
#import "AutoLoginViewController.h"
#import "CacheHelper.h"

#define FIRST_LOGIN @"first_login"

@interface LeqiSDK()<IAPManagerDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation LeqiSDK {
    BOOL isInitOk;
    BOOL isReInit;
    BOOL isFloatViewAdded;
}

static LeqiSDK* instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    [IAPManager sharedManager].delegate = instance;
    return instance;
}

#pragma mark -- 初始化
- (int)initWithConfig:(LeqiSDKInitConfigure *)configure {
    if(isReInit){
        [self show:@"重试中..."];
    }
    
    self.configInfo = configure;
    if(self.configInfo){
        NSMutableDictionary *params =[self setParams];
        NSString *url = [NSString stringWithFormat:@"%@%@?ios", @"http://api.6071.com/index3/init/p/", self.configInfo.appid];
        [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
            if(isReInit){
               [self dismiss:nil];
            }
            if(!res){
                return;
            }
            if([res[@"code"] integerValue] == 1){
                isInitOk = true;
                [[CacheHelper shareInstance] setInitInfo:res[@"data"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiInitDidFinished object:nil];
            } else {
                if(isReInit){
                    [self alertByfail:res[@"msg"]];
                }
            }
        } error:^(NSError *error) {
            [self showByError:error];
        }];
        return 0;
    } else {
        [self alert:@"初始化信息未配置"];
        return -1;
    }
    

}

#pragma mark -- 自动登录
- (void)openAutoLogin {
    AutoLoginViewController *loginViewController = [AutoLoginViewController new];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:loginViewController];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController  getCurrentViewController]];
}

#pragma mark -- 快速登录
- (void)openQuickLogin {
    [self show:@"请稍后..."];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/reg/p", self.configInfo.appid];
    NSMutableDictionary *params = [self setParams];
    [params setValue:[NSNumber numberWithBool:YES] forKey:@"is_quick"];
    [params setValue:@"" forKey:@"n"];
    [params setValue:@"" forKey:@"p"];
    
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [self dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            [[CacheHelper shareInstance] setUser:user mainKey:1];
            
            LoginViewController *loginViewController = [LoginViewController new];
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:loginViewController];
            popupController.containerView.layer.cornerRadius = 4;
            [popupController presentInViewController:[BaseViewController  getCurrentViewController]];
           
            Reg2LoginViewController *reg2LoginViewController = [Reg2LoginViewController new];
            [popupController pushViewController:reg2LoginViewController animated:YES];
            
            [[CacheHelper shareInstance] setAutoLogin:YES];
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:FIRST_LOGIN];
            [defaults synchronize];
        } else {
            [self alertByfail:res[@"msg"]];
        }
    } error:^(NSError * error) {
        [self showByError:error];
    }];
}

#pragma mark -- 正常登录
- (void)openNormalLogin {
    LoginViewController *loginViewController = [LoginViewController new];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:loginViewController];
    popupController.containerView.layer.cornerRadius = 4;
    [popupController presentInViewController:[BaseViewController  getCurrentViewController]];
}

#pragma mark -- 登录
- (int)login {
    NSLog(@"%@:%@", TAG, @"login");
    if(self.user){
        return -10002;  //已经登录
    }
    if(!isInitOk){
        isReInit = YES;
        [self initWithConfig: self.configInfo];
        return -10001; //初始化失败
    }
    
    BOOL isAutoLogin = [[CacheHelper shareInstance] getAutoLogin];
    if(isAutoLogin){
        [self openAutoLogin];
        return 0;
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    BOOL isNotFirstLogin = [defaults boolForKey:FIRST_LOGIN];
    if(!isNotFirstLogin){
        [self openQuickLogin];
    } else {
        [self openNormalLogin];
    }
    return 0;
}

#pragma mark -- 支付
- (int)payWithOrderInfo:(id)orderInfo {
    if(!self.user) return -10003; //没有登录
    
    [self show:@"请稍后..."];
    [[IAPManager sharedManager] requestProductWithId: @"sdktest1"];
    return 0;
}

- (void)showFloatView {
    if(!self.user) return;
    if(!isFloatViewAdded){
       [XHFloatWindow xh_addWindowOnTarget:[BaseViewController getCurrentViewController] onClick:^{
           // do something after floating button clicked...
           SettingViewController *settingController = [SettingViewController new];
           STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:settingController];
           popupController.containerView.layer.cornerRadius = 4;
           [popupController presentInViewController:[BaseViewController  getCurrentViewController]];
       }];
    } else {
        [XHFloatWindow xh_setHideWindow:NO];
    }
    isFloatViewAdded = true;
}

- (void)hideFloatView {
    [XHFloatWindow xh_setHideWindow:YES];
}

#pragma mark -- SDK版本号
- (NSString *)getVersion {
    return @"1.0";
}

#pragma mark -- 退出
- (int)logout {
    return 0;
}

#pragma mark -- 接收内购支付回调
- (void)receiveProduct:(SKProduct *)product {
    NSLog(@"%@:%@", TAG, @"接收内购支付回调");
    [self dismiss:nil];
    if (product != nil) {
        if (![[IAPManager sharedManager] purchaseProduct:product]) {
           [self alert:@"您禁止了应用内购买权限,请到设置中开启!"];
        }
    } else {
        [self alert:@"无法连接App Store!"];
    }
}

#pragma mark -- 购买成功
- (void)successedWithReceipt:(NSData *)transactionReceipt {
    NSLog(@"%@:%@", TAG, @"购买成功");
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
    
    if ([transactionReceiptString length] > 0) {
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
        /**
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
         */
        
        /**
         if (凭证校验成功) {
         [[MLIAPManager sharedManager] finishTransaction];
         }
         */
    }
}


#pragma mark -- 购买失败
- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    NSLog(@"%@:%@", TAG, @"购买失败");
    [self alert:errorDescripiton];
}

#pragma mark -- 显示Loading
- (void)show:(NSString *)message {
    self.hud = [MBProgressHUD showHUDAddedTo:[BaseViewController getCurrentViewController].view animated:YES];
    self.hud.label.font = [UIFont systemFontOfSize: 14];
    self.hud.label.text = message;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.hud){
                [self.hud hideAnimated:YES];
                self.hud = nil;
            }
        });
    });
}

#pragma mark -- 关闭Loading
- (void)dismiss:(void (^)(void))callback {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        if(callback){
            callback();
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.hud){
                [self.hud hideAnimated:YES];
                self.hud = nil;
            }
        });
    });
}

- (void)showByError:(NSError *)error {
    [self dismiss:nil];
    if(error){
        [self show:@"重试中..."];
    }
}

#pragma mark -- alert
- (void)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertByfail:(NSString *)message {
    NSString *msg = message;
    if(!msg){
        msg = @"服务器未知错误";
    }
    [self alert:message];
}

#pragma mark -- 设置默认参数
- (NSMutableDictionary *)setParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSString *version = [self getVersion];
    [params setValue:version forKey:@"version"];
    NSString *agentid = self.configInfo.agentid;
    
    if(agentid){
        [params setValue:agentid forKey:@"a"];
    } else {
        [params setValue:agentid forKey:@"default"];
    }
    
    NSString *gameid = self.configInfo.gameid;
    [params setValue:gameid forKey:@"g"];
    
    return params;
}




@end
