//
//  TYLoginViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYLoginViewController.h"
#import "TYLoginInputView.h"
#import "TYDeviceManagerViewController.h"
#import "TYLoginDefine.h"
#import "TYScanTipViewController.h"
#import "TYButton.h"

@interface TYLoginViewController ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, assign) TYHostRegion region;

@end

@implementation TYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    [self createTopView];
    [self createInputView];
    [self createButtonView];
}

#pragma mark - Private Method
- (void)createTopView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuya-icon"]];
    [self.view addSubview:iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = kStrDeviceManager;
    _nameLabel.font = [UIFont boldSystemFontOfSize:28];
    _nameLabel.textColor = HexRGB(0x000000, 1.0f);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(148);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(14);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
}

- (void)createInputView {
    TYLoginInputView *inputView = [[TYLoginInputView alloc] init];
    [inputView createView];
    [self.view addSubview:inputView];
    self.inputView = inputView;
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(32.0f);
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(16);        
    }];

    @weakify(self)
    inputView.locationButtonBlock = ^(NSString *location) {
        @strongify(self)
        
        self.location = location;
        self.region = TYHostRegionCN;
        if ([location isEqualToString:@"China"]) {
            self.region = TYHostRegionCN;
        } else if ([location isEqualToString:@"America"]) {
            self.region = TYHostRegionUS;
        } else if ([location isEqualToString:@"Europe"]) {
            self.region = TYHostRegionEU;
        } else if ([location isEqualToString:@"India"]) {
            self.region = TYHostRegionIN;
        } else if ([location isEqualToString:@"Eastern America"]) {
            self.region = TYHostRegionUE;
        } else if ([location isEqualToString:@"Western Europe"]) {
            self.region = TYHostRegionWE;
        } else {
            self.region = TYHostRegionCustom;
        }
        TYConstant.hostRegion = self.region;
    };
    inputView.accountFieldBlock = ^(NSString *account) {
        self_weak_.account = account;
    };
    inputView.passwordFieldBlock = ^(NSString *password) {
        self_weak_.password = password;
    };
}

- (void)createButtonView {
    TYButton *loginButton = [TYButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:kStrLogIn forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [loginButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16 * 2, 52.0f)];
    [self.view addSubview:loginButton];
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.layer.cornerRadius = 8;
    switchButton.layer.borderWidth = 1;
    switchButton.layer.borderColor = [UIColor colorWithRed:255/255 green:67/255 blue:0/255 alpha:1].CGColor;
    [switchButton setTitleColor:[UIColor colorWithRed:255/255 green:67/255 blue:0/255 alpha:1] forState:UIControlStateNormal];
    [switchButton setTitle:kStrSwitchApp forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_inputView.mas_bottom).offset(86);
        make.left.mas_equalTo(self.view).offset(16);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginButton.mas_bottom).offset(12);
        make.left.centerX.height.mas_equalTo(loginButton);
    }];
}

#pragma mark - Event Response
- (void)loginButtonAction {
    if (!_account.length || !_password.length) {
        [SVProgressHUD showErrorWithStatus:kStrAccountPasswordEmpty];
        return;
    }
    
    NSString *accountId = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessId];
    NSString *accessSecret = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessSecret];
    
    if (!accountId.length || !accessSecret.length) {
        [SVProgressHUD showErrorWithStatus:kStrClientEmptyAlert];
        return;
    }
    
    [TYSDK initializeWithClientID:accountId clientSecret:accessSecret hostRegion:_region];
    
    [SVProgressHUD show];
    [[NSUserDefaults standardUserDefaults] setValue:_account forKey:kUsername];
    
    TYUserManager *manager = [[TYUserManager alloc] init];
    [manager loginWithUserName:_account password:_password completionHandle:^(BOOL success, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (success) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogin];
            [[NSUserDefaults standardUserDefaults] setInteger:self.region forKey:kLocation];
            
            TYDeviceManagerViewController *vc = [[TYDeviceManagerViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        
    }];
}

- (void)switchButtonAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kStrPrompt message:kStrSwitchAppAlert preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kStrCancel style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:kStrYES style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TYScanTipViewController *scanVC = [[TYScanTipViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
