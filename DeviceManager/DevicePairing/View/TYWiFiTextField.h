//
//  TYWiFiTextField.h
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWiFiTextField : UIView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) BOOL secureTextEntry;

@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
