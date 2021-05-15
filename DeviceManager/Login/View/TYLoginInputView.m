//
//  TYLoginInputView.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYLoginInputView.h"
#import <Masonry/Masonry.h>

@interface TYLoginInputView () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation TYLoginInputView

- (void)createView {
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.layer.cornerRadius = 6;
    locationButton.layer.borderWidth = 0.5;
    locationButton.layer.borderColor = [UIColor colorWithRed:229/255 green:229/255 blue:229/255 alpha:0.5].CGColor;
    [locationButton setTitle:@"China" forState:UIControlStateNormal];
    locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    [locationButton setTitleColor:[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1] forState:UIControlStateNormal];
    locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locationButton];
    self.locationButton = locationButton;
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    arrowButton.userInteractionEnabled = NO;
    [locationButton addSubview:arrowButton];
    
    UITextField *accountField = [[UITextField alloc] init];
    NSAttributedString *accountPlaceholder = [[NSAttributedString alloc] initWithString:kStrAccount attributes:
                                           @{NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f),
                                             NSFontAttributeName:[UIFont systemFontOfSize:16.0f]
                                           }];
    accountField.attributedPlaceholder = accountPlaceholder;
    accountField.autocorrectionType = UITextAutocorrectionTypeNo;
    accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accountField.keyboardType = UIKeyboardTypeASCIICapable;
    [accountField addTarget:self action:@selector(textFieldChangedWithTextField:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:accountField];
    self.accountField = accountField;
    
    UIView *accountLine = [[UIView alloc] init];
    accountLine.backgroundColor = HexRGB(0xE5E5E5, 1);
    [self addSubview:accountLine];
    
    UITextField *passwordField = [[UITextField alloc] init];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:kStrPassword attributes:
                                           @{NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f),
                                             NSFontAttributeName:[UIFont systemFontOfSize:16.0f]
                                           }];
    passwordField.attributedPlaceholder = passwordPlaceholder;
    passwordField.secureTextEntry = YES;
    [passwordField addTarget:self action:@selector(textFieldChangedWithTextField:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:passwordField];
    self.passwordField = passwordField;
    
    UIView *passwordLine = [[UIView alloc] init];
    passwordLine.backgroundColor = HexRGB(0xE5E5E5, 1);
    [self addSubview:passwordLine];
    
    UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [hiddenButton addTarget:self action:@selector(showAndHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hiddenButton];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(56);
        make.left.mas_equalTo(0);
    }];
    [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(locationButton.mas_right).offset(-16);
        make.width.height.mas_equalTo(44);
        make.centerY.mas_equalTo(locationButton);
    }];
    [accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locationButton.mas_bottom).offset(16);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(self);
        make.left.mas_equalTo(16);
    }];
    [accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0.5);
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(accountField.mas_bottom);
    }];
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountField.mas_bottom).offset(16);
        make.left.height.mas_equalTo(accountField);
        make.right.mas_equalTo(hiddenButton.mas_left);
    }];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0.5);
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(passwordField.mas_bottom);
    }];
    [hiddenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.width.height.mas_equalTo(44);
        make.centerY.mas_equalTo(passwordField);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(passwordField.mas_bottom);
    }];
    
}

#pragma mark - Event Response
- (void)locationButtonAction:(UIButton *)button {
    NSArray *locationArray = @[@"China", @"America", @"Europe", @"India", @"Eastern America", @"Western Europe"];
    __block NSString *currentLocation;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kStrChooseCountry message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *str in locationArray) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            currentLocation = str;
            [self.locationButton setTitle:str forState:UIControlStateNormal];
            if (self.locationButtonBlock) {
                self.locationButtonBlock(currentLocation);
            }
        }];
        [alertVC addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kStrCancel style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

- (void)textFieldChangedWithTextField:(UITextField *)textField {
    if ([textField isEqual:_accountField]) {
        if (self.accountFieldBlock) {
            self.accountFieldBlock(textField.text);
        }
        
    } else if ([textField isEqual:_passwordField]) {
        if (self.passwordFieldBlock) {
            self.passwordFieldBlock(textField.text);
        }
    }
}

//显示和隐藏登录视图的密码。
- (void)showAndHidePassword:(UIButton *)sender {
    _passwordField.secureTextEntry = !_passwordField.secureTextEntry;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //明文切换密文后避免被清空
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.passwordField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}

@end
