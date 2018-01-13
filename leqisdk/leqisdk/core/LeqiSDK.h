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
#define TAG @"leqisdk"

#define kLeqiSDKNotiInitDidFinished @"LeqiSDKNotiInitDidFinished"

@interface LeqiSDK : NSObject

@property (nonatomic, strong) LeqiSDKInitConfigure *configInfo;

+ (instancetype) shareInstance;

- (int)initWithConfig:(LeqiSDKInitConfigure *)configure;

- (int)login;

- (int)payWithOrderInfo:(LeqiSDKOrderInfo *)orderInfo;

- (int)logout;

- (NSString *)getVersion;

@end
