//
//  CacheUtils.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/23.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAIN_KEY @"main_key"


@interface CacheHelper : NSObject

+ (_Nullable instancetype)shareInstance;
- (NSMutableArray *_Nullable)getUsers;
- (void)setUser:(nonnull NSMutableDictionary *)data mainKey:(int)mainkey;
- (NSMutableDictionary *)getCurrentUser;
- (void)setAutoLogin:(BOOL)autologin;
- (BOOL)getAutoLogin;
- (void)setCurrentUser:(NSDictionary *)user;
- (void)setUsers:(nonnull NSMutableArray *)users;
- (NSDictionary *)getInitInfo;
- (void)setInitInfo:(NSDictionary *)initinfo;
- (void)setRealAuth;
- (BOOL)getRealAuth;

- (NSMutableArray *_Nullable)getCheckFailOrderList;
- (void)setCheckFailOrderList:(nonnull NSMutableArray *)orderList;
- (void)setCheckFailOrder:(NSDictionary *_Nonnull)dict;

@end
