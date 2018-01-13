//
//  EncrytUtils.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EncrytUtils : NSObject

+ (NSString *)encode:(NSString *)str;
+ (NSString *)decode:(NSString *)str;
+ (NSString *)rsaWithPublickey:(NSString *)publicKey data:(NSString *)jsonStr;
+ (NSString *)upgzipByResponse:(NSData *)data;
+ (NSData *)gzipByRsa:(NSString *)jsonStr;
+ (NSString *)getPubKey;
+ (void)setPubKey:(NSString *)pubkey;

@end
