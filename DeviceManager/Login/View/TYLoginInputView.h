//
//  TYLoginInputView.h
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYLoginInputView : UIView

@property (nonatomic, copy) void (^locationButtonBlock) (NSString *location);
@property (nonatomic, copy) void (^accountFieldBlock) (NSString *account);
@property (nonatomic, copy) void (^passwordFieldBlock) (NSString *password);
- (void)createView;

@end

NS_ASSUME_NONNULL_END
