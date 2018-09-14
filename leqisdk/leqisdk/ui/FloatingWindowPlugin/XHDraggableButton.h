//
//  XHDraggableButton.h
//  XHFloatingWindow
//
//  Created by Xinhou Jiang on 14/1/17.
//  Copyright © 2017年 Xinhou Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define floatWindowSize 40

/**
 * to avoid event collision between button click and pan,here touch event is adopted 
 * to deal with both click and pan event
 */

typedef NS_ENUM(NSInteger ,xh_FloatWindowDirection) {
    xh_FloatWindowLEFT,
    xh_FloatWindowRIGHT,
    xh_FloatWindowTOP,
    xh_FloatWindowBOTTOM
};

typedef NS_ENUM(NSInteger, xh_ScreenChangeOrientation) {
    xh_Change2Origin,
    xh_Change2Upside,
    xh_Change2Left,
    xh_Change2Right
};

@protocol UIDragButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;

@end

@interface XHDraggableButton : UIButton

@property (nonatomic, assign) xh_FloatWindowDirection minDir;

@property (nonatomic, strong)UIView *rootView;
@property (nonatomic, weak)id<UIDragButtonDelegate>buttonDelegate;
@property (nonatomic, assign)UIInterfaceOrientation initOrientation;
@property (nonatomic, assign)CGAffineTransform originTransform;

- (void)buttonRotate;
- (void)animateHalf;
- (void)reset;

@end
