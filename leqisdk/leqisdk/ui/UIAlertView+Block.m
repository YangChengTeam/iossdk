//
//  UIAlertView+Block.m
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>
@implementation UIAlertView (Block)

static void *key = "NTOAlertView";

- (void)showAlertViewWithCompleteBlock:(CompleteBlock)block
{
    if (block) {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }
    ////show
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ///获取关联的对象，通过关键字。
    CompleteBlock block = objc_getAssociatedObject(self, key);
    if (block) {
        ///block传值
        block(buttonIndex);
    }
}


@end
