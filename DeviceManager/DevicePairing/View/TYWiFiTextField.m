//
//  TYWiFiTextField.m
//  TuyaSmartHomeDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYWiFiTextField.h"

@interface TYWiFiTextField ()

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation TYWiFiTextField

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.centerX.equalTo(self);
        make.height.equalTo(@30.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(5.0f);
        make.centerX.left.equalTo(self.textField);
        make.height.equalTo(@1.0f);
        make.bottom.equalTo(self).offset(-1.0f);
    }];
}

#pragma mark - action
- (void)textFieldDidChange:(UITextField *)textField{
    if (self.textField.text.length > 0) {
        self.textField.leftView = nil;
        self.lineView.backgroundColor = HexRGB(0x333333, 1.0f);
    } else {
        self.textField.leftView = self.leftImageView;
        self.lineView.backgroundColor = HexRGB(0x999999, 1.0f);
    }
}

#pragma mark - setter && getter
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                           @{NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f),
                                             NSFontAttributeName:self.textField.font
                                           }];
    self.textField.attributedPlaceholder = attributeString;
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}

-(void)setLeftImage:(UIImage *)leftImage{
    _leftImage = leftImage;
    self.leftImageView.image = leftImage;
    self.textField.leftView = self.leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setText:(NSString *)text{
    self.textField.text = text;
}

-(NSString *)text{
    return self.textField.text;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textColor = HexRGB(0x333333, 1.0f);
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28.0f, 22.0f)];
        _leftImageView.frame = CGRectMake(0, 0, 22.0f, 22.0f);
        [_leftView addSubview:_leftImageView];
    }
    return _leftView;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexRGB(0xE5E5E5, 1.0f);
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
