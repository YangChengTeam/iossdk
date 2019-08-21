//
//  AppDelegate.m
//  leqisdk-sample
//
//  Created by zhangkai on 2018/1/9.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "AppDelegate.h"
#import <leqisdk/LeqiSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leqiInitResult:)
                                                 name:kLeqiSDKNotiInitDidFinished
                                               object:nil];
   
    LeqiSDKInitConfigure *config = [LeqiSDKInitConfigure new];
    config.agentid = @"67";
    config.gameid = @"680";
    config.appid = @"680";
    int error = [[LeqiSDK shareInstance] initWithConfig:config];
    if(error != 0){
        NSLog(@"不能启动初始化：%d",error);
    }
    return YES;
}

- (void)leqiInitResult:(NSNotification *)notify {
    NSLog(@"%@", notify);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
