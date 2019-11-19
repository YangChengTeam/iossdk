//
//  AgreementViewController.m
//  leqisdk
//
//  Created by zhangkai on 2019/7/12.
//  Copyright © 2019 zhangkai. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController {
    UIWebView *_webView;
    NSString *filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"乐七用户注册协议";
    if(IsPortrait){
        [self setViewHieght: 400];
    } else {
        [self setViewHieght: 240];
    }
    
    filePath = [leqiBundle pathForResource:@"yhxy" ofType:@"html"];
    NSError *error;
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    _webView = [[UIWebView alloc] init];
    [_webView loadHTMLString:htmlString baseURL:nil];

    [self.view addSubview:_webView];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
