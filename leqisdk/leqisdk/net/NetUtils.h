//
//  NetUtils.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUtils : NSObject

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback error:(void (^)(NSError *))errorcallback;

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback;

//  encryt 关闭自定义加密  使用https
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback error:(void (^)(NSError *))errorcallback encryt:(BOOL)encryt;
@end
