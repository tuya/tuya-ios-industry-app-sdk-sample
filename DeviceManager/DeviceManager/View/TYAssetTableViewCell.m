//
//  TYAssetTableViewCell.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYAssetTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TYAssetTableViewCell ()

@property (nonatomic, strong) UILabel *assetLabel;

@end

@implementation TYAssetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.assetLabel = [[UILabel alloc] init];        
        _assetLabel.textColor = HexRGB(0x999999, 1);
        _assetLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_assetLabel];
        
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImageView).offset(5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        }];
        
        [_assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.height.mas_equalTo(19);
            make.width.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom);
        }];
    }
    return self;
}

- (void)loadDataWithImage:(UIImage *)image title:(NSString *)title detailTitle:(NSString *)detailTitle{
    self.iconImageView.image = image;
    self.nameLabel.text = title;
    self.assetLabel.text = detailTitle;
}

+ (NSString *)cellIdentifier {
    return @"TYAssetTableViewCell";
}

@end
