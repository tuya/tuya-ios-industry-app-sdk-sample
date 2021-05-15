//
//  TYSelectWiFiViewController.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYSelectWiFiViewController.h"
#import "TYScanDeviceViewController.h"
#import "TYAPHotSpotViewController.h"
#import "TYQRCodeViewController.h"
#import "TYButton.h"
#import "TYToastLabel.h"
#import "TYWiFiTextField.h"
#import "UILabel+TYQuick.h"
#import "TYLoginDefine.h"

@interface TYSelectWiFiViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) TYWiFiTextField *accountTextField;

@property (nonatomic, strong) TYWiFiTextField *passwordTextField;

@property (nonatomic, strong) TYButton *nextButton;

@property (nonatomic, strong) TYDeviceRegistrationManager *manager;

@property (nonatomic, copy) NSString *pairingToken;

@property (nonatomic, copy) NSString *token;

@end

@implementation TYSelectWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kStrSetWiFi;
    [self setUI];
    [self getTokenWithCompleteBlock:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - action
- (void)actionNext:(TYButton *)button{
    if (self.pairingToken) {
        [self pushScanDeviceViewController];
    } else {
        @weakify(self)
        [self getTokenWithCompleteBlock:^(TYDeviceRegistrationToken *result) {
            @strongify(self)
            [self pushScanDeviceViewController];
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - private method
- (void)setUI{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(28.0f);
        make.left.equalTo(self.contentView).offset(33.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12.0f);
        make.left.equalTo(self.contentView).offset(20.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(65.0f);
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(22.0f);
        make.centerX.left.equalTo(self.accountTextField);        
    }];
        
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18.0f);
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@52.0f);
    }];
}

- (void)getTokenWithCompleteBlock:(void(^)(TYDeviceRegistrationToken *result))completeBlock{
    
    NSString *uid = [TYUserInfo uid];
    NSString *timeZoneID = [NSTimeZone systemTimeZone].name;
    NSString *assetId = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentAssetID];
    
    [SVProgressHUD show];
    @weakify(self)
    [self.manager generateTokenFor:TYDevicePairingTypeAP uid:uid timeZoneID:timeZoneID assetID:assetId deviceUUID:nil completionHandle:^(TYDeviceRegistrationToken * _Nullable result, NSError * _Nullable error) {
        @strongify(self)
        if (result) {
            [self handleCallBackWithToken:result];
            if (completeBlock) {
                completeBlock(result);
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)pushScanDeviceViewController{
    if (self.pairingToken.length <= 0) {
        [SVProgressHUD showInfoWithStatus:kStrPairingTokenEmpty];
        return;
    }
    
    if (self.token.length <= 0) {
        [SVProgressHUD showInfoWithStatus:kStrTokenEmpty];
        return;
    }

    if (self.accountTextField.text.length <= 0 || self.passwordTextField.text.length <= 0) {
        [SVProgressHUD showInfoWithStatus:kStrAccountPasswordEmpty];
        return;
    }
    
    if (self.pairingMode == TYPairingDeviceModeAP) {
        TYAPHotSpotViewController *apHotController = [[TYAPHotSpotViewController alloc] init];
        apHotController.account = self.accountTextField.text;
        apHotController.password = self.passwordTextField.text;
        apHotController.pairingToken = self.pairingToken;
        apHotController.token = self.token;
        [self.navigationController pushViewController:apHotController animated:YES];
    } else if (self.pairingMode == TYPairingDeviceModeQRCode) {
        TYQRCodeViewController *qrCodeController = [[TYQRCodeViewController alloc] init];
        qrCodeController.account = self.accountTextField.text;
        qrCodeController.password = self.passwordTextField.text;
        qrCodeController.pairingToken = self.pairingToken;
        qrCodeController.token = self.token;
        [self.navigationController pushViewController:qrCodeController animated:YES];
    }
}

- (void)handleCallBackWithToken:(TYDeviceRegistrationToken *)result{
    if (result.pairingToken.length > 0 && result.token) {
        self.pairingToken = result.pairingToken;
        self.token = result.token;
    } else {
        self.pairingToken = nil;
        self.token = nil;
    }
}

#pragma mark - setter && getter
-(TYDeviceRegistrationManager *)manager{
    if (!_manager) {
        _manager = [[TYDeviceRegistrationManager alloc] init];
    }
    return _manager;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:kStrSetWiFiMessage textColor:HexRGB(0x333333, 1.0f) fontSize:18.0f onView:self.contentView];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelWithText:kStrSetWiFiMessageDetail textColor:HexRGB(0x999999, 1.0f) fontSize:13.0f onView:self.contentView];
    }
    return _subTitleLabel;
}

-(TYWiFiTextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[TYWiFiTextField alloc] init];
        _accountTextField.placeholder = kStrAccount;
        _accountTextField.leftImage = [UIImage imageNamed:@"TY_WiFi_Account"];
        [self.contentView addSubview:_accountTextField];
    }
    return _accountTextField;
}

-(TYWiFiTextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[TYWiFiTextField alloc] init];
        _passwordTextField.placeholder = kStrPassword;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.leftImage = [UIImage imageNamed:@"TY_WiFi_Password"];
        [self.contentView addSubview:_passwordTextField];
    }
    return _passwordTextField;
}

-(TYButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [TYButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:kStrNext forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16 * 4, 52.0f)];
        [self.contentView addSubview:_nextButton];
    }
    return _nextButton;
}

@end
