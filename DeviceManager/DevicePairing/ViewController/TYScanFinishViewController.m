//
//  TYScanFinishViewController.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYScanFinishViewController.h"
#import <SDWebImage/UIImageView+webCache.h>
#import "TYButton.h"
#import "TYLoginDefine.h"
#import "UILabel+TYQuick.h"

@interface TYScanFinishViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) UILabel *assetIDLabel;

@property (nonatomic, strong) UILabel *deviceIDLabel;

@property (nonatomic, strong) TYButton *finishButton;

@property (nonatomic, strong) TYDeviceManager *deviceManager;

@property (nonatomic, strong) TYDevice *device;

@end

@implementation TYScanFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kStrActivatorResult;
    [self setUI];
    [self configureData];
}

#pragma mark - action
- (void)actionFinish:(TYButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)setUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(28.0f);
        make.left.equalTo(self.contentView).offset(33.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58.0f, 58.0f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.assetIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceImageView.mas_bottom).offset(23.0f);
        make.centerX.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16.0f);
    }];
    
    [self.deviceIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assetIDLabel.mas_bottom).offset(4.0f);
        make.left.centerX.equalTo(self.assetIDLabel);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18.0f);
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@52.0f);
    }];
}
    
- (void)configureData{
    [SVProgressHUD show];
    [self.deviceManager queryDeviceInfoOf:self.deviceModel.id completionHandle:^(TYDevice * _Nullable device, NSError * _Nullable error) {
        if (device) {
            [SVProgressHUD dismiss];
            self.device = device;
            [self updateUI];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)updateUI{
    NSString *assetId = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentAssetID];
    self.assetIDLabel.text = [NSString stringWithFormat:kStrAssetIDFormat,assetId];
    
    NSString *devId = self.device.id;
    self.deviceIDLabel.text = [NSString stringWithFormat:kStrDeviceIDFormat,devId];
    
    NSString *urlString = [NSString stringWithFormat:kIconUrlWithIconName, self.device.icon];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.deviceImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"TY_WiFi_Account"]];    
}

#pragma mark - setter && getter
-(TYDeviceManager *)deviceManager{
    if (!_deviceManager) {
        _deviceManager = [[TYDeviceManager alloc] init];
    }
    return _deviceManager;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:kStrActivatorResultMessage textColor:HexRGB(0x333333, 1.0f) fontSize:18.0f onView:self.contentView];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    return _titleLabel;
}

-(UIImageView *)deviceImageView{
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] init];
        _deviceImageView.image = [UIImage imageNamed:@"TY_WiFi_Account"];
        [self.contentView addSubview:_deviceImageView];
    }
    return _deviceImageView;
}

-(UILabel *)assetIDLabel{
    if (!_assetIDLabel) {
        _assetIDLabel = [UILabel labelWithText:nil textColor:HexRGB(0x333333, 1.0f) fontSize:15.0f onView:self.contentView];
        _assetIDLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _assetIDLabel;
}

-(UILabel *)deviceIDLabel{
    if (!_deviceIDLabel) {
        _deviceIDLabel = [UILabel labelWithText:nil textColor:HexRGB(0x999999, 1.0f) fontSize:13.0f onView:self.contentView];
    }
    return _deviceIDLabel;
}

-(UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [TYButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:kStrOK forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(actionFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_finishButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16 * 4, 52.0f)];
        [self.contentView addSubview:_finishButton];
    }
    return _finishButton;
}
@end
