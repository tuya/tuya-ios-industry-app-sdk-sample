//
//  UIView+TYAnimation.h
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TYAnimation)

- (void)addAnimationWithClockwise:(BOOL)clockwise;
- (void)startRotating;
- (void)stopRotating;
- (BOOL)isRotating;

@end

NS_ASSUME_NONNULL_END
