//
//  CacheUtils.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/23.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "CacheHelper.h"
#import "YYCache.h"

#define USERS_KEYS @"users_key"
#define CURRENT_USER_KEY @"current_user_key"
#define AUTO_LOGIN_KEY @"auto_login_key"
#define INIT_KEY_INFO @"init_info_key"
#define REAL_AUTH_INFO @"real_auth_key"
#define FAIL_ORDER_LIST @"fail_order_list"
#import "LeqiSDK.h"

@interface CacheHelper()

@property (nonatomic, strong) YYDiskCache *diskCache;

@end

@implementation CacheHelper

static CacheHelper* instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    instance.diskCache = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:@"sdk"]];
    return instance;
}

- (NSMutableArray *)getUsers {
    id users =  [self.diskCache objectForKey:USERS_KEYS];
    if(users && [users isKindOfClass:[NSMutableArray class]]){
        return users;
    }
    return nil;
}

- (void)setUser:(nonnull NSMutableDictionary *)data mainKey:(int)mainkey {
    id users =  [self.diskCache objectForKey:USERS_KEYS];
    if(!users || ![users isKindOfClass:[NSMutableArray class]]){
        users = [NSMutableArray new];
    }
    [data setObject:[NSNumber numberWithInt:mainkey] forKey:MAIN_KEY];
    for(NSMutableDictionary *info in users){
        int value = [[data objectForKey:MAIN_KEY] intValue];
        if(value == 2 && [[data objectForKey:@"user_id"] isEqual:@"0"] && [[data objectForKey:@"mobile"] isEqual:[info objectForKey:@"mobile"]]){
            [data setObject:[info objectForKey:@"user_id"] forKey:@"user_id"];
            [data setObject:[info objectForKey:@"name"] forKey:@"name"];
        }
        if([[data objectForKey:@"user_id"] isEqual:[info objectForKey:@"user_id"]]){
            [users removeObject:info];
            break;
        }
    }
    [self setCurrentUser:data];
    [users insertObject:data atIndex:0];
    [self.diskCache setObject:users forKey:USERS_KEYS];
}

- (void)setUsers:(nonnull NSArray *)users {
    [self.diskCache setObject:users forKey:USERS_KEYS];
}
- (void)setCurrentUser:(NSDictionary *)user {
    [self.diskCache setObject:user forKey:CURRENT_USER_KEY];
}

- (NSMutableDictionary *)getCurrentUser {
    return (NSMutableDictionary *)[self.diskCache objectForKey:CURRENT_USER_KEY];
}

- (BOOL)getAutoLogin {
    NSNumber *number = (NSNumber *)[self.diskCache objectForKey:AUTO_LOGIN_KEY];
    return [number boolValue];
}

- (void)setAutoLogin:(BOOL)autologin {
    [self.diskCache setObject:[NSNumber numberWithBool:autologin] forKey:AUTO_LOGIN_KEY];
}

- (NSDictionary *)getInitInfo {
    return (NSDictionary *)[self.diskCache objectForKey:INIT_KEY_INFO];
}

- (void)setInitInfo:(NSDictionary *)initinfo {
    [self.diskCache setObject:initinfo forKey:INIT_KEY_INFO];
}

- (void)setRealAuth {
    [self.diskCache setObject:@"authed" forKey:REAL_AUTH_INFO];
}

- (BOOL)getRealAuth {
    NSString *realAuth = (NSString *)[self.diskCache objectForKey:REAL_AUTH_INFO];
    if(realAuth && [realAuth isEqual:@"authed"]){
        return YES;
    }
    return NO;
}

- (void)setCheckFailOrder:(NSDictionary *)dict {
    id orders =  [self.diskCache objectForKey:[NSString stringWithFormat:@"%@%@", FAIL_ORDER_LIST, [[LeqiSDK shareInstance].user objectForKey:@"userid"]]];
    if(!orders || ![orders isKindOfClass:[NSMutableArray class]]){
        orders = [NSMutableArray new];
    }
    for(NSMutableDictionary *info in orders){
        id rececipt = [dict objectForKey:@"rececipt"];
        id rececipt2 = [info objectForKey:@"rececipt"];
        if([rececipt isEqual:[info objectForKey:rececipt2]]){
           [orders removeObject:info];
            break;
        }
    }
    [orders insertObject:dict atIndex:0];
    [self.diskCache setObject:orders forKey:[NSString stringWithFormat:@"%@%@", FAIL_ORDER_LIST, [[LeqiSDK shareInstance].user objectForKey:@"user_id"]]];
}

- (void)setCheckFailOrderList:(NSMutableArray *)orderList {
    [self.diskCache setObject:orderList forKey:[NSString stringWithFormat:@"%@%@", FAIL_ORDER_LIST, [[LeqiSDK shareInstance].user objectForKey:@"user_id"]]];
}

- (NSMutableArray *)getCheckFailOrderList {
    id orderList =  [self.diskCache objectForKey:[NSString stringWithFormat:@"%@%@", FAIL_ORDER_LIST, [[LeqiSDK shareInstance].user objectForKey:@"user_id"]]];
    if(orderList && [orderList isKindOfClass:[NSMutableArray class]]){
        return orderList;
    }
    return nil;
}

@end
