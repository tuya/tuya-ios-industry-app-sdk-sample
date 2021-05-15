//
//  UILabel+TYQuick.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "UILabel+TYQuick.h"

@implementation UILabel (TYQuick)

+(instancetype)labelWithText:(NSString *)text
                    textColor:(UIColor *)color
                     fontSize:(CGFloat)size
                      onView:(UIView *)view{
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    if (view) {
        [view addSubview:label];
    }
    
    return label;
}

@end
