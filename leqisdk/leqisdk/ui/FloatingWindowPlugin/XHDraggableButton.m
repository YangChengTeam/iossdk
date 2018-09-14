//
//  XHDraggableButton.m
//  XHFloatingWindow
//
//  Created by Xinhou Jiang on 14/1/17.
//  Copyright © 2017年 Xinhou Jiang. All rights reserved.
//

#import "XHDraggableButton.h"

#define xh_ScreenH [UIScreen mainScreen].bounds.size.height
#define xh_ScreenW [UIScreen mainScreen].bounds.size.width



@interface XHDraggableButton()

@property (nonatomic, assign)CGPoint touchStartPosition;

@end

@implementation XHDraggableButton {
    BOOL isHalf;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.touchStartPosition = [touch locationInView:_rootView];
    self.touchStartPosition = [self ConvertDir:_touchStartPosition];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isHalf = NO;
    self.superview.alpha = 1;
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    curPoint = [self ConvertDir:curPoint];
    self.superview.center = curPoint;
}

- (void)reset {
    isHalf = NO;
    self.superview.alpha = 1;
    switch (_minDir) {
        case xh_FloatWindowLEFT: {
            self.superview.frame =  CGRectMake(0, self.superview.frame.origin.y, floatWindowSize, floatWindowSize);
            break;
        }
        case xh_FloatWindowRIGHT: {
            self.superview.frame =  CGRectMake(xh_ScreenW - floatWindowSize, self.superview.frame.origin.y, floatWindowSize, floatWindowSize);
            break;
        }
        case xh_FloatWindowTOP: {
            self.superview.frame =  CGRectMake(self.superview.frame.origin.x, 0, floatWindowSize, floatWindowSize);
            break;
        }
        case xh_FloatWindowBOTTOM: {
            self.superview.frame =  CGRectMake(self.superview.frame.origin.x, xh_ScreenH - floatWindowSize, floatWindowSize, floatWindowSize);
            break;
        }
        default:
            break;
    }
}

- (void)animateHalf {
    if(isHalf) return;
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.superview.alpha = 0.6;
    } completion:^(BOOL finished) {
        switch (_minDir) {
            case xh_FloatWindowLEFT: {
                self.superview.frame =  CGRectMake(-floatWindowSize/2, self.superview.frame.origin.y, floatWindowSize, floatWindowSize);
                break;
            }
            case xh_FloatWindowRIGHT: {
                self.superview.frame =  CGRectMake(xh_ScreenW - floatWindowSize/2, self.superview.frame.origin.y, floatWindowSize, floatWindowSize);
                break;
            }
            case xh_FloatWindowTOP: {
                self.superview.frame =  CGRectMake(self.superview.frame.origin.x, -floatWindowSize/2, floatWindowSize, floatWindowSize);
                break;
            }
            case xh_FloatWindowBOTTOM: {
                self.superview.frame =  CGRectMake(self.superview.frame.origin.x, xh_ScreenH - floatWindowSize/2, floatWindowSize, floatWindowSize);
                break;
            }
            default:
                break;
        }
        isHalf = YES;
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    curPoint = [self ConvertDir:curPoint];
    // if the start touch point is too close to the end point, take it as the click event and notify the click delegate
    if (pow((_touchStartPosition.x - curPoint.x),2) + pow((_touchStartPosition.y - curPoint.y),2) < 1) {
        [self.buttonDelegate dragButtonClicked:self];
        return;
    }

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat W = xh_ScreenW;
    CGFloat H = xh_ScreenH;
    // (1,2->3,4 | 3,4->1,2)
    NSInteger judge = orientation + _initOrientation;
    if (orientation != _initOrientation && judge != 3 && judge != 7) {
        W = xh_ScreenH;
        H = xh_ScreenW;
    }
    // distances to the four screen edges
    CGFloat left = curPoint.x;
    CGFloat right = W - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = H - curPoint.y;
    // find the direction to go
    _minDir = xh_FloatWindowLEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        _minDir = xh_FloatWindowRIGHT;
    }
    if (top < minDistance) {
        minDistance = top;
        _minDir = xh_FloatWindowTOP;
    }
    if (bottom < minDistance) {
        _minDir = xh_FloatWindowBOTTOM;
    }
    
    switch (_minDir) {
        case xh_FloatWindowLEFT: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
            } completion:^(BOOL finished) {
                [self animateHalf];
            }];
            break;
        }
        case xh_FloatWindowRIGHT: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(W - self.superview.frame.size.width/2, self.superview.center.y);
            } completion:^(BOOL finished) {
                [self animateHalf];
            }];
            break;
        }
        case xh_FloatWindowTOP: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
            } completion:^(BOOL finished) {
                [self animateHalf];
            }];
            break;
        }
        case xh_FloatWindowBOTTOM: {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, H - self.superview.frame.size.height/2);
            } completion:^(BOOL finished) {
                [self animateHalf];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)buttonRotate {
    xh_ScreenChangeOrientation change2orien = [self screenChange];
    switch (change2orien) {
        case xh_Change2Origin:
            self.transform = _originTransform;
            break;
        case xh_Change2Left:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case xh_Change2Right:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case xh_Change2Upside:
            self.transform = _originTransform;
            self.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
            break;
    }
}

/**
 *  convert to the origin coordinate
 *
 *  UIInterfaceOrientationPortrait           = 1
 *  UIInterfaceOrientationPortraitUpsideDown = 2
 *  UIInterfaceOrientationLandscapeRight     = 3
 *  UIInterfaceOrientationLandscapeLeft      = 4
 */
- (CGPoint)ConvertDir:(CGPoint)p {
    xh_ScreenChangeOrientation change2orien = [self screenChange];
    // covert
    switch (change2orien) {
        case xh_Change2Left:
            return [self LandscapeLeft:p];
            break;
        case xh_Change2Right:
            return [self LandscapeRight:p];
            break;
        case xh_Change2Upside:
            return [self UpsideDown:p];
            break;
        default:
            return p;
            break;
    }
}

- (xh_ScreenChangeOrientation)screenChange {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // 1. xh_Change2Origin(1->1 | 2->2 | 3->3 | 4->4)
    if (_initOrientation == orientation) return xh_Change2Origin;
    
    // 2. xh_Change2Upside(1->2 | 2->1 | 4->3 | 3->4)
    NSInteger isUpside = orientation + _initOrientation;
    if (isUpside == 3 || isUpside == 7) return xh_Change2Upside;
    
    // 3. xh_Change2Left(1->4 | 4->2 | 2->3 | 3->1)
    // 4. xh_Change2Right(1->3 | 3->2 | 2->4 | 4->1)
    xh_ScreenChangeOrientation change2orien = 0;
    switch (_initOrientation) {
        case UIInterfaceOrientationPortrait:
            if (orientation == UIInterfaceOrientationLandscapeLeft)
                change2orien = xh_Change2Left;
            else if(orientation == UIInterfaceOrientationLandscapeRight)
                change2orien = xh_Change2Right;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if (orientation == UIInterfaceOrientationLandscapeRight)
                change2orien = xh_Change2Left;
            else if(orientation == UIInterfaceOrientationLandscapeLeft)
                change2orien = xh_Change2Right;
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (orientation == UIInterfaceOrientationPortrait)
                change2orien = xh_Change2Left;
            else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
                change2orien = xh_Change2Right;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (orientation == UIInterfaceOrientationPortraitUpsideDown)
                change2orien = xh_Change2Left;
            else if(orientation == UIInterfaceOrientationPortrait)
                change2orien = xh_Change2Right;
            break;
            
        default:
            break;
    }
    return change2orien;
}

- (CGPoint)UpsideDown:(CGPoint)p {
    return CGPointMake(xh_ScreenW - p.x, xh_ScreenH - p.y);
}

- (CGPoint)LandscapeLeft:(CGPoint)p {
    return CGPointMake(p.y, xh_ScreenW - p.x);
}

- (CGPoint)LandscapeRight:(CGPoint)p {
    return CGPointMake(xh_ScreenH - p.y, p.x);
}

@end
