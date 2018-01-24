//
//  NetUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "NetUtils.h"
#import "AFNetworking.h"
#import "EncrytUtils.h"
#import "UIAlertView+Block.h"

#define UUID @"leqisdk-uuid"

@implementation NetUtils

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback {
    [NetUtils postWithUrl:url params:data callback:finishcallback error: nil];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback error:(void (^)(NSError *))errorcallback {
    NSLog(@"leqisdk:请求url->%@", url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //timestamp
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    NSMutableDictionary *defaultParams = [NSMutableDictionary new];
    [defaultParams setValue:[NSString stringWithFormat:@"%ld", (long)[timeStampObj integerValue]] forKey:@"ts"];
    
    //uuid
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *uuidString = [defaults stringForKey:UUID];
    if(!uuidString){
        CFUUIDRef udid = CFUUIDCreate(NULL);
        uuidString = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, udid));
        uuidString = [[uuidString stringByReplacingOccurrencesOfString:@"-"
                                                            withString:@""] lowercaseString];
        [defaults setObject:uuidString forKey:UUID];
        [defaults synchronize];
    }
    [defaultParams setValue:uuidString forKey:@"i"];
    
    //systemVersion
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [defaultParams setValue:[NSString stringWithFormat:@"iOS%@", systemVersion] forKey:@"sv"];
    
    //设备类型
    [defaultParams setValue:@"3" forKey:@"d"];
    
    if(data){
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [defaultParams setObject:obj forKey:key];
        }];
    }
    
    NSData *jsonData = [NetUtils dict2jsonString:defaultParams];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *params = [EncrytUtils gzipByRsa:jsonStr];
    NSLog(@"leqisdk:请求参数->%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    [req setHTTPBody:params];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器,请重试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if(buttonIndex == 1){
                    if(errorcallback){
                        errorcallback(error);
                    }
                    [NetUtils postWithUrl:url params:data callback:finishcallback error: errorcallback];
                } else {
                    if(errorcallback){
                        errorcallback(nil);
                    }
                }
            }];
            if(finishcallback != nil){
                finishcallback(nil);
            }
            return;
        }
        NSString *jsonStr = [EncrytUtils upgzipByResponse:responseObject];
        NSData *jsonData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog(@"leqisdk:服务器返回数据->%@", dictionary);
        if([dictionary[@"code"] integerValue] == -100){
            [EncrytUtils setPubKey:dictionary[@"data"][@"publickey"]];
            [NetUtils postWithUrl:url params:data callback:finishcallback error: errorcallback];
            return;
        }
        if(finishcallback != nil){
            finishcallback(dictionary);
        }
    }] resume];
}

+(NSData*) dict2jsonString:(NSDictionary *) data {
    if(data == nil) return nil;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:(NSJSONWritingOptions) 0
                                                         error:&error];
    
    return jsonData;
}



@end
