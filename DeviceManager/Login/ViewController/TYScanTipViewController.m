//
//  TYScanTipViewController.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYScanTipViewController.h"
#import "TYScanViewController.h"
#import "TYButton.h"

@interface TYScanTipViewController ()

@end

@implementation TYScanTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
}

#pragma mark - Private Method
- (void)createView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuya-icon"]];
    [self.view addSubview:iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = kStrDeviceManager;
    nameLabel.font = [UIFont boldSystemFontOfSize:28];
    nameLabel.textColor = HexRGB(0x000000, 1.0f);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    TYButton *scanButton = [TYButton buttonWithType:UIButtonTypeCustom];
    [scanButton setTitle:kStrScan forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scanButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16 * 2, 52.0f)];
    [self.view addSubview:scanButton];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = kStrScanMessage;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = [UIColor colorWithRed:153/255 green:153/255 blue:153/255 alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(143);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(14);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-77);
        make.left.mas_offset(16);
        make.right.mas_offset(-16);
        make.height.mas_equalTo(52);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(scanButton);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-32);
    }];
}

#pragma mark - Event Response
- (void)scanButtonAction {
    TYScanViewController *vc = [[TYScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
