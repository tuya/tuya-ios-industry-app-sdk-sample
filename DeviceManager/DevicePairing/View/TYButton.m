//
//  TYButton.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYButton.h"

@interface TYButton ()

@end

@implementation TYButton

-(instancetype)init{
    if (self = [super init]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)configureGradientColorWithSize:(CGSize)size{
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
    gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
    gradientLayer.locations = @[@(0.0f),@(1.0f)];
    [gradientLayer setColors:@[
        (__bridge id)HexRGB(0xff7e00, 1.0f).CGColor,
        (__bridge id)HexRGB(0xff4800, 1.0f).CGColor]];
    [self.layer addSublayer:gradientLayer];

    // Radius Code
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

@end
