//
//  BaseViewController.h
//  ycsdk
//
//  Created by zhangkai on 2018/1/8.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPopup.h"
#import "MBProgressHUD.h"
#import "CacheHelper.h"
#import "LeqiSDK.h"
#import "NetUtils.h"

#define TAG @"leqisdk"
#define leqiBundle ([NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"leqibundle" withExtension:@"bundle"]])
#define kRGBColor(r, g, b, a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/255.0]
#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define kScreenWidth \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kScreenHeight \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)

#define kRefreshUser @"refresh_user"
#define kRefreshMenu @"refresh_menu"

@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL noCancel;

@property (nonatomic, strong) MBProgressHUD *hud;

- (UIImage*)createImageWithColor: (UIColor*) color;
- (void)setViewHieght:(int)height;
+ (UIViewController *)getCurrentViewController;
- (void)show:(NSString *)message;
- (void)dismiss:(void (^)(void))callback;
- (void)initWithGCD:(int)timeValue beginState:(void (^)(int seconds))begin endState:(void (^)())end;

- (NSDictionary *)getUser;
- (NSString *)getUserName;
- (NSString *)getPassword;
- (NSString *)getUserName:(NSDictionary *)user;
- (NSString *)getPassword:(NSDictionary *)user;

- (void)loginWithAccount:(NSString *)account password:(NSString *)passwrod;
- (void)regWithAccount:(NSString *)account password:(NSString *)password isQuick:(BOOL)isQuick callback:(void (^)())callback;

- (void)showByError:(NSError *)error;
- (void)alert:(NSString *)message;
- (void)alertByfail:(NSString *)message;

- (void)openQQ:(id)sender;
- (void)openPhone:(id)sender;

@end
