//
//  ViewController.h
//  leqisdk-sample
//
//  Created by zhangkai on 2018/1/9.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define leqiBundle ([NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"leqibundle" withExtension:@"bundle"]])
#define kRGBColor(r, g, b, a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/255.0]
#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *btnLogin;
@property (nonatomic, weak) IBOutlet UIButton *btnPay;

@end

