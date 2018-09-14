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
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>


#define UUID @"leqisdk-uuid"

@implementation NetUtils

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback {
    [NetUtils postWithUrl:url params:data callback:finishcallback error: nil];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback error:(void (^)(NSError *))errorcallback {
    [self postWithUrl:url params:data callback:finishcallback error:errorcallback encryt:YES];
}

+ (NSString *)getSysytemInfo {
    UIDevice *device = [UIDevice currentDevice];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@-%@-%@",
                        device.name,
                        model,
                        device.systemVersion
            ];
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)data callback:(void (^)(NSDictionary *))finishcallback error:(void (^)(NSError *))errorcallback encryt:(BOOL)encryt {
    NSLog(@"leqisdk:请求url->%@", url);
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(!encryt){
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setAllowInvalidCertificates:YES];
        manager.securityPolicy = securityPolicy;
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *defaultParams = [NSMutableDictionary new];
    if(encryt){
        //timestamp
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
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
        
        [defaultParams setValue:[NetUtils getSysytemInfo] forKey:@"sv"];
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        idfa = [[idfa stringByReplacingOccurrencesOfString:@"-"
                                                      withString:@""] lowercaseString];
        [defaultParams setValue:idfa forKey:@"idfa"];
        
        //设备类型
        [defaultParams setValue:@"3" forKey:@"d"];
    }
    

    if(data){
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [defaultParams setObject:obj forKey:key];
        }];
    }
   
    NSData *jsonData = [NetUtils dict2jsonString:defaultParams];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"leqisdk:请求参数->%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    if(encryt){
        NSData *params  = [EncrytUtils gzipByRsa:jsonStr];
        [req setHTTPBody:params];
    } else {
        [req setHTTPBody:jsonData];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法连接服务器,请重试" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
            return;
        }
        NSData *jsonData = nil;
        if(encryt){
            NSString *jsonStr  = [EncrytUtils upgzipByResponse:responseObject];
            jsonData =[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            jsonData = responseObject;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog(@"leqisdk:服务器返回数据->%@", dictionary);
        if(encryt && [dictionary[@"code"] integerValue] == -100){
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
