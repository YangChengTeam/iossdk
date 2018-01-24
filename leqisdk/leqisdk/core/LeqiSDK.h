//
//  YC6071SDK.h
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LeqiSDKInitConfigure.h"
#import "LeqiSDKOrderInfo.h"

//初始化回调
#define kLeqiSDKNotiInitDidFinished @"kLeqiSDKNotiInitDidFinished"
//登录回调
#define kLeqiSDKNotiLogin @"kLeqiSDKNotiLogin"
//注销回调
#define kLeqiSDKNotiLogout @"kLeqiSDKNotiLogout"
//支付回调
#define kLeqiSDKNotiPay @"kLeqiSDKNotiPay"

@interface LeqiSDK : NSObject
@property (nonatomic, strong) NSMutableDictionary *user;
@property (nonatomic, strong) LeqiSDKInitConfigure *configInfo;

+ (instancetype) shareInstance;

- (int)initWithConfig:(LeqiSDKInitConfigure *)configure;

- (int)login;

- (int)payWithOrderInfo:(LeqiSDKOrderInfo *)orderInfo;

- (void)showFloatView;

- (void)hideFloatView;

- (int)logout;

- (NSString *)getVersion;

- (NSMutableDictionary *)setParams;

@end
