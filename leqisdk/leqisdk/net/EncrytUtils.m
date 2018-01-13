//
//  EncrytUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "EncrytUtils.h"
#import "RSA.h"
#import "NSData+GZIP.h"


static NSString *pubkey = @"-----BEGIN PUBLIC KEY----- \
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsDodkyEPbvjtJzYE9LUO \
IK7lqgMHoCMSdC/dPjAT+e63tYC/Zq0lOoMj3UYst4pReSCDTI5V+AsByskDZUs3 \
DTn2gUm0GsntRTDlMSB/4ZeeyTBfKehNeP20wHlrN9olndedo7kyf8mdM+5IKIcI \
knW1yJq+ZW/0yzHkSTZ8T0pJ0egHTp+sG6wWbvpFQGkXHqZ2ItNSMuT/UNqGRH3e \
ugcJxaITCgKMK/bCiyaRl7NU80qmWuXVvYcDGuo9iIFF/CAm2gF3fZuBNHVZJuaY \
LT+61F0fckoMcqNXvU9GnAbyDw32RN8LsPhIRxeGIKzDv/UoB9SL2+CoKaOACG0x \
Jz22MgtSowf+jEPHc3x8KrjfmGkvJNW0wJuDEQIRZw+S/h9r/OrWhz4J/+JJrt+a \
gjMewuet0Ch0yIRcpecbRUWjk8rg2d4UeQgqk4bxoMjKuF5dDnZgyPxxnS671TgH \
19E7vmajJ8fn2+vcO/QDk0/4Qq8h4HQ6d0XY8xj+WtMDbKBQqYOr7KDVnk3zllAS \
2us97aqEPVspu3EBiIYP4mJi9ENxSA+A9RkGYTq7x2RY8dp5YZgRulevUMQcESCP \
/DO8fJNTIU6fq7uTsuvemjtyMZ8Z3Qmafsbf/0CPfksX4qqNLfHalBgiyrjZjkb9 \
t5XISoQ1s3S+oye4FeMT7ycCAwEAAQ== \
-----END PUBLIC KEY-----";


static char *k = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ*!";
@implementation EncrytUtils

+ (NSString *)encode:(NSString *)str {
    if(str == nil) return @"";
    
    NSMutableString *result = [NSMutableString new];
    const char *carr = [[[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0] UTF8String];
    size_t length= strlen(carr);
    [result appendString:@"x"];
    for (int i = 0; i < length; i++) {
        [result appendString:[NSString stringWithFormat:@"%d", carr[i] + k[i%strlen(k)]]];
        if(i != length - 1){
            [result appendString:@"_"];
        }
    }
    [result appendString:@"y"];
    NSLog(@"%@", result);
    return result;
}

+ (NSString *)getPubKey {
    return pubkey;
}

+ (void)setPubKey:(NSString *)_pubkey {
    pubkey = _pubkey;
}

+ (NSString *)decode:(NSString *)str {
    if(str == nil) return @"";
    NSMutableString *result = [NSMutableString new];
    if([str hasPrefix:@"x"] && [str hasSuffix:@"y"]){
        NSRange range = NSMakeRange(1, str.length - 2);
        NSArray *sarr = [[str substringWithRange:range] componentsSeparatedByString:@"_"];
        for(int i = 0; i < [sarr count]; i++){
            [result appendString:[NSString stringWithFormat:@"%c", [sarr[i] intValue] - k[i%strlen(k)]]];
        }
    }
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:result options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

+ (NSString *)rsaWithPublickey:(NSString *)publicKey data:(NSString *)jsonStr {
    return [RSA encryptString:jsonStr publicKey:publicKey];
}

+ (NSData *)gzipByRsa:(NSString *)jsonStr {
    if(jsonStr == nil) return nil;
    jsonStr = [EncrytUtils rsaWithPublickey:[EncrytUtils getPubKey] data:jsonStr];
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [jsonData gzippedData];
}

+ (NSString *)upgzipByResponse:(NSData *)data {
    if(data ==  nil) return nil;
    NSData *undata = [data gunzippedData];
    NSString *str = [[NSString alloc] initWithData:undata encoding:NSUTF8StringEncoding];
    return [EncrytUtils decode:str];
}


@end
