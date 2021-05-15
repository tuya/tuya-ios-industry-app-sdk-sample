//
//  TYScanDeviceViewController.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYScanDeviceViewController.h"
#import "TYScanFinishViewController.h"
#import "UILabel+TYQuick.h"
#import "UIView+TYAnimation.h"
#import "TYWeakProxy.h"

typedef NS_ENUM(NSInteger,TYScanDeviceState) {
    TYScanDeviceStateScan           =   0,
    TYScanDeviceStateRegisted       =   1,
    TYScanDeviceStateInitialize     =   2,
};

@interface TYScanDeviceViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *circleView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) TYDeviceRegistrationManager *manager;

@property (nonatomic, assign) NSInteger queryCount;

@property (nonatomic, strong) TYAPActivator *activator;

@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation TYScanDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kStrState;
    [self setUI];
    [self startConfigureWiFi];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopConfigureWiFi];
}

#pragma mark - timer
- (void)doProgress:(id)sender{
    if (self.queryCount >= 100) {
        [self stopConfigureWiFi];
        [SVProgressHUD showErrorWithStatus:kStrTimeout];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.queryCount += 2;
    [self queryConfigureResult];
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
        make.left.equalTo(self.contentView).offset(36.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(190.0f, 190.0f));
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(90.0f);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(24.0f);
        make.centerX.equalTo(self.circleView);
    }];
}

- (void)setDeviceState:(TYScanDeviceState)state{
    if (state == TYScanDeviceStateScan) {
        [self.circleView addAnimationWithClockwise:YES];
        [self.circleView startRotating];
    } else if (state == TYScanDeviceStateRegisted){
        [self.circleView stopRotating];
        [self.circleView.layer removeAllAnimations];
        self.circleView.image = [UIImage imageNamed:@"TY_WiFi_Register"];
        self.stateLabel.text = kStrStateRegister;
    } else if (state == TYScanDeviceStateInitialize){
        self.circleView.image = [UIImage imageNamed:@"TY_WiFi_Initialize"];
        [self.circleView addAnimationWithClockwise:YES];
        [self.circleView startRotating];
        self.stateLabel.text = kStrStateInitialize;
    }
}

- (void)startConfigureWiFi{
    [self setDeviceState:TYScanDeviceStateScan];
    [self.activator start];
    [self startTimer];
}

- (void)stopConfigureWiFi{
    [self.activator stop];
    [self stopTimer];
}

- (void)startTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (void)queryConfigureResult{
    @weakify(self)
    [self.manager queryRegistrationResultOf:self.token completionHandle:^(TYDeviceRegistrationResult * _Nullable result, NSError * _Nullable error) {
        @strongify(self)
        if (result.succeedDevices.count != 0) {
            [self stopConfigureWiFi];
            [self pushToFinishViewController:result];
        } else if (result.failedDevices.count > 0){
            [SVProgressHUD showErrorWithStatus:result.failedDevices.lastObject.errorMessage];
            [self stopConfigureWiFi];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)pushToFinishViewController:(TYDeviceRegistrationResult *)result{
    TYScanFinishViewController *finishViewController = [[TYScanFinishViewController alloc] init];
    finishViewController.deviceModel = result.succeedDevices.firstObject;
    [self.navigationController pushViewController:finishViewController animated:YES];
}

#pragma mark - setter && getter
-(TYDeviceRegistrationManager *)manager{
    if (!_manager) {
        _manager = [[TYDeviceRegistrationManager alloc] init];
    }
    return _manager;
}

-(TYAPActivator *)activator{
    if (!_activator) {
        _activator = [[TYAPActivator alloc] initWithSSID:self.account password:self.password pairingToken:self.pairingToken];
    }
    return _activator;
}

- (NSTimer *)progressTimer{
    if (!_progressTimer) {
        _progressTimer = [NSTimer timerWithTimeInterval:2 target:[TYWeakProxy proxyWithTarget:self] selector:@selector(doProgress:) userInfo:nil repeats:YES];
    }
    return _progressTimer;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:kStrStateAddDevice textColor:HexRGB(0x333333, 1.0f) fontSize:18.0f onView:self.contentView];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelWithText:kStrStateMessage textColor:HexRGB(0x999999, 1.0f) fontSize:13.0f onView:self.contentView];
    }
    return _subTitleLabel;
}

-(UIImageView *)circleView{
    if (!_circleView) {
        _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190.0f, 190.0f)];
        _circleView.image = [UIImage imageNamed:@"TY_WiFi_ScanState"];
        [self.contentView addSubview:_circleView];
    }
    return _circleView;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [UILabel labelWithText:kStrStateScanDevices textColor:HexRGB(0x333333, 1.0f) fontSize:15.0f onView:self.contentView];
        _stateLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _stateLabel;
}

@end
