//
//  XHFloatWindowController.h
//  XHFloatingWindow
//
//  Created by Xinhou Jiang on 14/1/17.
//  Copyright © 2017年 Xinhou Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHDraggableButton;
@interface XHFloatWindowController : UIViewController

- (void)setRootView;
- (void)setHideWindow:(BOOL)hide;
- (void)setWindowSize:(float)size; // 40 by default
- (void)resetBackgroundImage: (NSString *)imageName forState:(UIControlState)UIControlState;

@end
