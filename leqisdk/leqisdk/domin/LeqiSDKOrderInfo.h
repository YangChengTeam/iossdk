//
//  YC6071SDKOrderInfo.h
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeqiSDKOrderInfo : NSObject

@property (nonatomic, copy) NSString *goodId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *callback;
@property (nonatomic, copy) NSString *extrasParams;

@end
