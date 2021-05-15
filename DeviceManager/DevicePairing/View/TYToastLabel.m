//
//  TYToastLabel.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYToastLabel.h"

@implementation TYToastLabel

-(instancetype)init{
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect CGQBZRect =   [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, _textInsets) limitedToNumberOfLines:numberOfLines];
    CGQBZRect.origin.x += self.textInsets.left;
    CGQBZRect.origin.y += self.textInsets.top;
    CGQBZRect.size.width += self.textInsets.left + self.textInsets.right;
    CGQBZRect.size.height += self.textInsets.top + self.textInsets.bottom;
    return CGQBZRect;
}

-(void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
