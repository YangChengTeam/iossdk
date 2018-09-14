//
//  XHFloatWindowController.m
//  XHFloatingWindow
//
//  Created by Xinhou Jiang on 14/1/17.
//  Copyright © 2017年 Xinhou Jiang. All rights reserved.
//

#import "XHFloatWindowController.h"
#import "XHDraggableButton.h"
#import "XHFloatWindowSingleton.h"
#import "BaseViewController.h"


@interface XHFloatWindowController ()<UIDragButtonDelegate>

@property (strong,nonatomic) UIWindow *window;
@property (strong,nonatomic) XHDraggableButton *button;

@property (nonatomic, strong)UIImage *imageNormal;
@property (nonatomic, strong)UIImage *imageSelected;

@end

@implementation XHFloatWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // hide the root view
    self.view.frame = CGRectZero;
    // create floating window button
    [self createButton];
    // register UIDeviceOrientationDidChangeNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/**
 * create floating window and button
 */
- (void)createButton
{
    // 1.floating button
    _button = [XHDraggableButton buttonWithType:UIButtonTypeCustom];
    _button.minDir = xh_FloatWindowLEFT;
    [self resetBackgroundImage:@"float_drag" forState:UIControlStateNormal];
    [self resetBackgroundImage:@"float_drag" forState:UIControlStateSelected];
    _button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _button.frame = CGRectMake(0, 0, floatWindowSize, floatWindowSize);
    _button.buttonDelegate = self;
    _button.initOrientation = [UIApplication sharedApplication].statusBarOrientation;
    _button.originTransform = _button.transform;
    _button.imageView.alpha = 0.8;
    
    // 2.floating window
    _window = [[UIWindow alloc] init];
    _window.frame = CGRectMake(0, (kScreenHeight - floatWindowSize) / 2, floatWindowSize, floatWindowSize);
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor clearColor];
    _window.layer.cornerRadius = floatWindowSize/2;
    _window.layer.masksToBounds = YES;
    [_window addSubview:_button];
    [_window makeKeyAndVisible];
    
    [_button animateHalf];
}

/**
 * set rootview
 */
- (void)setRootView {
    _button.rootView = self.view.superview;
}


/**
 *  floating button clicked
 */
- (void)dragButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundImage:_imageSelected forState:UIControlStateSelected];
    }
    else {
        [sender setBackgroundImage:_imageNormal forState:UIControlStateNormal];
    }
    
    // click callback
    [_button reset];
    [XHFloatWindowSingleton Ins].floatWindowCallBack();
}

/**
 * reset window hiden
 */
- (void)setHideWindow:(BOOL)hide {
    _window.hidden = hide;
    if(!hide){
        [_button animateHalf];
    } 
}



/**
 * reset floating window size
 */
- (void)setWindowSize:(float)size {
    CGRect rect = _window.frame;
    _window.frame = CGRectMake(rect.origin.x, rect.origin.y, size, size);
    _button.frame = CGRectMake(0, 0, size, size);
    [self.view setNeedsLayout];
}

/**
 * reset button background image
 */
- (void)resetBackgroundImage:(NSString *)imageName forState:(UIControlState)UIControlState {
    UIImage *image = [UIImage imageNamed:imageName inBundle:leqiBundle compatibleWithTraitCollection:nil];
    switch (UIControlState) {
        case UIControlStateNormal:
            _imageNormal = image;
            break;
        case UIControlStateSelected:
            _imageSelected = image;
            break;
            
        default:
            break;
    }
    [_button setBackgroundImage:image forState:UIControlState];
}

/**
 * notification
 */
- (void)orientationChange:(NSNotification *)notification {
    [_button buttonRotate];
}

@end
