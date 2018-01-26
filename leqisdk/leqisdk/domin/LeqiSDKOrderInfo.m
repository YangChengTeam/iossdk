//
//  YC6071SDKOrderInfo.m
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "LeqiSDKOrderInfo.h"

@implementation LeqiSDKOrderInfo

- (instancetype)init {
    if([super init]){
        self.payways = @"iap";
    }
    return self;
}

@end
