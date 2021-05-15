//
//  UILabel+TYQuick.h
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>


@interface UILabel (TYQuick)

+(instancetype)labelWithText:(NSString *)text
                    textColor:(UIColor *)color
                     fontSize:(CGFloat)size
                      onView:(UIView *)view;

@end
