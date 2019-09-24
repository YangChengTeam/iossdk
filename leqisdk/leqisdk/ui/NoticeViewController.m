//
//  NoticeViewController.m
//  leqisdk
//
//  Created by uke on 2019/9/24.
//  Copyright © 2019 zhangkai. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController {
    UIWebView *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知";
    if(IsPortrait){
        [self setViewHieght: 400];
    } else {
        [self setViewHieght: 240];
    }
    
    _webView = [[UIWebView alloc] init];
    [_webView loadHTMLString:self.notice baseURL:nil];
    
    [self.view addSubview:_webView];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20);
}

@end
