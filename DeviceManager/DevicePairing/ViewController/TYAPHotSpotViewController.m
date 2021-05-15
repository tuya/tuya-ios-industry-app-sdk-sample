//
//  TYAPHotSpotViewController.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYAPHotSpotViewController.h"
#import "TYButton.h"
#import "UILabel+TYQuick.h"
#import "TYScanDeviceViewController.h"

@interface TYAPHotSpotViewController ()

@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UIImageView *hotspotImg;
@property (nonatomic, strong) TYButton *nextButton;

@end

@implementation TYAPHotSpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kStrConnectHotSpot;
    [self setUI];
}

#pragma mark - action
- (void)actionNext:(TYButton *)button {
    TYScanDeviceViewController *scanDeviceController = [[TYScanDeviceViewController alloc] init];
    scanDeviceController.account = self.account;
    scanDeviceController.password = self.password;
    scanDeviceController.pairingToken = self.pairingToken;
    scanDeviceController.token = self.token;    
    [self.navigationController pushViewController:scanDeviceController animated:YES];
}

#pragma mark - private method
- (void)setUI{
    
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(28.0f);
        make.left.equalTo(self.contentView).offset(33.0f);
        make.centerX.equalTo(self.contentView);
    }];
    [self.hotspotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(10.0f);
        make.left.equalTo(self.contentView).offset(33.0f);
        make.height.equalTo(@300);
        make.centerX.equalTo(self.contentView);
    }];
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotspotImg.mas_bottom).offset(10.0f);
        make.left.equalTo(self.contentView).offset(33.0f);
        make.centerX.equalTo(self.contentView);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18.0f);
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@52.0f);
    }];
}

#pragma mark - setter && getter
-(UILabel *)titleLabel1{
    if (!_titleLabel1) {
        _titleLabel1 = [UILabel labelWithText:kStrConnectHotSpotMessage1 textColor:HexRGB(0x333333, 1.0f) fontSize:18.0f onView:self.contentView];
        _titleLabel1.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel1;
}

-(UILabel *)titleLabel2{
    if (!_titleLabel2) {
        _titleLabel2 = [UILabel labelWithText:kStrConnectHotSpotMessage2 textColor:HexRGB(0x333333, 1.0f) fontSize:18.0f onView:self.contentView];
        _titleLabel2.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel2;
}

-(UIImageView *)hotspotImg{
    
    if (!_hotspotImg){
        _hotspotImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotspot_wifi.png"]];
        [self.contentView addSubview:_hotspotImg];

    }
    return _hotspotImg;
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
