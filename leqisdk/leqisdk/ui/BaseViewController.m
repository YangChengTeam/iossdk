//
//  BaseViewController.m
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaseViewController.h"
#import "QQViewController.h"
#import "Reg2LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRGBColor(0xf1, 0xf1, 0xf1, 0xf2);
    [STPopupNavigationBar appearance].barTintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].tintColor = kRGBColor(0xbf, 0xbf, 0xbf, 0xff);
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:16], NSForegroundColorAttributeName:  kColorWithHex(0x333333) };
    self.popupController.navigationBar.draggable = NO;
}


- (void)show:(NSString *)message {
    self.hud = [MBProgressHUD showHUDAddedTo:self.popupController.containerView animated:YES];
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

- (void)setViewHieght:(int)height {
    [self setViewHieght:height lan:YES];
}

- (void)setViewHieght:(int)height lan:(BOOL)lan {
    int offset = 20;
    int width = kScreenWidth - offset * 2;
    int maxWidth = 400;
    if(!lan){
        maxWidth = width;
    }
    self.contentSizeInPopup = CGSizeMake(width, height);
    self.landscapeContentSizeInPopup = CGSizeMake(maxWidth, height);
}

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect= CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIViewController *)getCurrentViewController {
    if([LeqiSDK shareInstance].currentViewController){
        return [LeqiSDK shareInstance].currentViewController;
    }
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    @try {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            result = nextResponder;
        else
            result = window.rootViewController;
    } @catch(NSException *exception){
        if(window){
            result = window.rootViewController;
        }
    }
    return result;
}

- (void)initWithGCD:(int)timeValue beginState:(void (^)(int seconds))begin endState:(void (^)())end {
    __block NSInteger time = timeValue;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (time <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                end();
            });
        } else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                begin(seconds);
            });
            time--;
        }
    });
    dispatch_resume(timer);
}

- (NSDictionary *)getUser {
    NSDictionary *user = [LeqiSDK shareInstance].user;
    if(!user){
        user = [[CacheHelper shareInstance] getCurrentUser];
    }
    return user;
}

- (NSString *)getUserName {
    NSDictionary *user = [self getUser];
    NSString *username = @"";
    if(user){
        if([[user objectForKey:MAIN_KEY] intValue] == 1){
            username = [user objectForKey:@"name"];
        } else {
            username = [user objectForKey:@"mobile"];
        }
    }
    return username;
}

- (NSString *)getUserName:(NSDictionary *)user {
    NSString *username = @"";
    if(user){
        if([[user objectForKey:MAIN_KEY] intValue] == 1){
            username = [user objectForKey:@"name"];
        } else {
            username = [user objectForKey:@"mobile"];
        }
    }
    return username;
}

- (NSString *)getPassword {
    NSDictionary *user = [self getUser];
    NSString *password = @"";
    if(user){
        password = [user objectForKey:@"pwd"];
    }
    return password;
}

- (NSString *)getPassword:(NSDictionary *)user {
    NSString *password = @"";
    if(user){
        password = [user objectForKey:@"pwd"];
    }
    return password;
}

- (void)openQQ:(id)sender {
    [self.popupController pushViewController:[QQViewController new] animated:YES];
}

- (void)openPhone:(id)sender {
    NSDictionary *initInfo = [[CacheHelper shareInstance] getInitInfo];
    NSString *phone = [initInfo objectForKey:@"iso_tel"];
    if([phone length] ==  0){
        phone = @"tel://400-796-6071";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)passwrod {
    if(self.isCancel){
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/login/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params =  [[LeqiSDK shareInstance] setParams];
    [params setValue:account forKey:@"n"];
    [params setValue:passwrod forKey:@"p"];
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [self dismiss:nil];
        if(self.isCancel){
            return;
        }
        self.noCancel = true;
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            int mainkey = 1;
            if([[user objectForKey:@"is_vali_mobile"] intValue] == 1 && [[user objectForKey:@"mobile"] isEqualToString:account]){
                mainkey = 2;
            }
            [[CacheHelper shareInstance] setUser:user mainKey:mainkey];
            NSDictionary *dict = @{
                                   @"userId":[user objectForKey:@"user_id"],
                                   @"sign":[user objectForKey:@"sign"],
                                   @"loginTime": [user objectForKey:@"last_login_time"]
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiLogin object:dict];
            [LeqiSDK shareInstance].user = user;
            [self.popupController dismiss];
            [[LeqiSDK shareInstance] showFloatView];
        } else {
            [self alertByfail:res[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiLogin object:nil];
        }
    } error:^(NSError * error) {
        [self showByError:error];
        if(!error){
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeqiSDKNotiLogin object:nil];
        }
    }];
}

- (void)regWithAccount:(NSString *)account password:(NSString *)password isQuick:(BOOL)isQuick callback:(void (^)())callback{
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/reg/p", [LeqiSDK shareInstance].configInfo.appid];
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setValue:[NSNumber numberWithBool:isQuick] forKey:@"is_quick"];
    [params setValue:account forKey:@"n"];
    [params setValue:password forKey:@"p"];
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        [self dismiss:nil];
        if(!res){
            return;
        }
        if([res[@"code"] integerValue] == 1 && res[@"data"]){
            NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            [[CacheHelper shareInstance] setUser:user mainKey:1];
            Reg2LoginViewController *reg2LoginViewController = [Reg2LoginViewController new];
            [self.popupController pushViewController:reg2LoginViewController animated:YES];
            if(callback){
                callback();
            }
        } else {
            [self alertByfail:res[@"msg"]];
        }
    } error:^(NSError * error) {
        [self showByError:error];
    }];
}

+ (void)payWithOrderInfo:(LeqiSDKOrderInfo *)orderInfo callback:(void (^)(id))callback {
    NSString *url = [NSString stringWithFormat:@"%@/%@?ios", @"http://api.6071.com/index3/ios_order/p", [LeqiSDK shareInstance].configInfo.appid];
    
    NSMutableDictionary *params = [[LeqiSDK shareInstance] setParams];
    [params setValue:[[LeqiSDK shareInstance].user objectForKey:@"user_id"] forKey:@"user_id"];
    [params setValue:orderInfo.payways forKey:@"pay_ways"];
    [params setValue:[NSString stringWithFormat:@"%.02f", orderInfo.amount]  forKey:@"amount"];
    [params setValue:[NSString stringWithFormat:@"%d", orderInfo.count] forKey:@"count"];
    [params setValue:orderInfo.roleId forKey:@"role"];
    [params setValue:orderInfo.callback forKey:@"callback"];
    [params setValue:orderInfo.serverId forKey:@"server"];
    [params setValue:orderInfo.productName forKey:@"productname"];
    [params setValue:orderInfo.orderId forKey:@"attach"];
    [params setValue:orderInfo.extrasParams forKey:@"extra"];
    [NetUtils postWithUrl:url params:params callback:^(NSDictionary *res){
        if(callback){
            callback(res);
        }
    } error:^(NSError * error) {
        if(callback){
           callback(error);
        }
    }];
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
    NSString *msg = [message stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    if([msg length] == 0){
        msg = @"服务器未知错误, 请重试";
        message = msg;
    }
    [self alert:msg];
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
