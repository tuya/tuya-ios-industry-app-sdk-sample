//
//  UIView+TYAnimation.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "UIView+TYAnimation.h"

@implementation UIView (TYAnimation)

- (BOOL)isRotating {
    if (self.layer.speed>0) {
        return YES;
    }
    return NO;
}

- (void)startRotating {
    if (![self isRotating]) {
        self.layer.speed = 1.0;
        self.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.layer timeOffset];
        CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.layer.beginTime = timeSincePause;
    }
}

- (void)stopRotating {
    if ([self isRotating]) {
        self.layer.speed = 0.0;
        self.layer.timeOffset = 0;
    }
}

- (void)addAnimationWithClockwise:(BOOL)clockwise {
    [self.layer removeAllAnimations];
    
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (clockwise) {
        monkeyAnimation.toValue =  [NSNumber numberWithFloat:2.0 *M_PI];
    } else {
        monkeyAnimation.toValue = [NSNumber numberWithFloat:-2.0 *M_PI];
    }
    monkeyAnimation.duration = 1.5f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO;
    
    monkeyAnimation.repeatCount = FLT_MAX;
    [self.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    
    // 加载动画 但不播放动画
    self.layer.speed = 0.0;
}

@end
