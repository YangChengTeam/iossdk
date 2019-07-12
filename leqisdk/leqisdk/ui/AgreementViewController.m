//
//  AgreementViewController.m
//  leqisdk
//
//  Created by zhangkai on 2019/7/12.
//  Copyright © 2019 zhangkai. All rights reserved.
//

#import "AgreementViewController.h"
#import <QuickLook/QuickLook.h>

@interface AgreementViewController ()<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@end

@implementation AgreementViewController {
    QLPreviewController *_previewController;
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
    
    filePath = [leqiBundle pathForResource:@"lqyx" ofType:@"pdf"];
    _previewController = [[QLPreviewController alloc] init];
    _previewController.dataSource = self;
    _previewController.delegate = self;
    [_previewController setCurrentPreviewItemIndex:0];
    [self.view addSubview:_previewController.view];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _previewController.view.frame = self.view.bounds;

}

#pragma -   QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    if (filePath) {
        return [NSURL fileURLWithPath:filePath];
    }
    return nil;
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
