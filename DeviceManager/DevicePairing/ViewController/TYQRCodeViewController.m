//
//  TYQRCodeViewController.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYQRCodeViewController.h"
#import "TYScanDeviceViewController.h"
#import "TYButton.h"
#import "UILabel+TYQuick.h"

@interface TYQRCodeViewController ()

@property (nonatomic, strong) UIImageView *qrCodeImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TYButton *nextButton;

@end

@implementation TYQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kStrQRCofiged;
    [self setUI];
    [self configureData];
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
    
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(36.0f);
        make.left.equalTo(self.contentView).offset(30.0f);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(self.qrCodeImageView.mas_width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeImageView.mas_bottom).offset(28.0f);
        make.left.equalTo(self.contentView).offset(30.0f);
        make.centerX.equalTo(self.qrCodeImageView);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18.0f);
        make.left.equalTo(self.contentView).offset(16.0f);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@52.0f);
    }];
}

- (void)configureData{
    
    TYQRCodeActivator *activator = [[TYQRCodeActivator alloc] initWithSSID:self.account password:self.password pairingToken:self.pairingToken];
    NSError *error = nil;
    CGFloat width = CGRectGetWidth(self.view.frame) - 16.0f* 2 - 30.0f * 2;    
    UIImage *image = [activator generateQRCodeUIImageWithWidth:width error:&error];
    if (!image) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        return;
    }
    
    self.qrCodeImageView.image = image;
}

#pragma mark - setter && getter
-(UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_qrCodeImageView];
    }
    return _qrCodeImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:kStrQRCofigedMessage textColor:HexRGB(0x999999, 1.0f) fontSize:13.0f onView:self.contentView];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0f];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSString  *testString = _titleLabel.text;
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        [_titleLabel  setAttributedText:setString];
    }
    return _titleLabel;
}

-(TYButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [TYButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:kStrQRCofigedPrompt forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton configureGradientColorWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16 * 4, 52.0f)];
        [self.contentView addSubview:_nextButton];
    }
    return _nextButton;
}

@end
