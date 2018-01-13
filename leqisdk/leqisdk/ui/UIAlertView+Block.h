//
//  UIAlertView+Block.h
//  leqisdk
//
//  Created by zhangkai on 2018/1/12.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView(Block)

- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;


@end
