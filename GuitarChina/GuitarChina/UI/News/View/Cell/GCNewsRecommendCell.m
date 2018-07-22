//
//  GCNewsRecommendCell.m
//  GuitarChina
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsRecommendCell.h"

@implementation GCNewsRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self configureView];
    }
    return self;
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.blackTransparentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.readCountLabel];
}

- (void)setModel:(GCNewsModulePostModel *)model index:(NSInteger)index {
    _model = model;
    
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.time;
    self.readCountLabel.text = model.readCount;
    if (model.img.length > 0) {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:DefaultImage];
    }
    
    if (index == 0) {
        if (model.img.length > 0) {
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.timeLabel.textColor = [UIColor whiteColor];
            self.timeLabel.text = model.remark;
            
            CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:self.model.content fontSize:15 width:kScreenWidth - 40];
            
            self.leftImageView.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, kScreenWidth * 0.5);
            self.titleLabel.frame = CGRectMake(20, self.leftImageView.frame.origin.y + self.leftImageView.frame.size.height - titleLabelHeight - 10 - 20, kScreenWidth - 40, titleLabelHeight + 10);
            self.blackTransparentView.frame = CGRectMake(kMargin, self.leftImageView.frame.origin.y + self.leftImageView.frame.size.height - titleLabelHeight - 10 - 20, kSubScreenWidth, titleLabelHeight + 10 + 20);
            self.timeLabel.frame = CGRectMake(20, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height - 5, kScreenWidth - 40, 20);
            self.readCountLabel.frame = CGRectZero;
        }
        else {
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.preferredMaxLayoutWidth = kSubScreenWidth;
            self.titleLabel.textColor = [GCColor fontColor];
            self.timeLabel.textColor = [GCColor grayColor3];
            
            CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:self.model.content fontSize:15 width:kSubScreenWidth];
            
            self.leftImageView.frame = CGRectZero;
            self.titleLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, titleLabelHeight);
            self.timeLabel.frame = CGRectMake(kMargin, kMargin + titleLabelHeight + 10, kSubScreenWidth, 20);
            self.readCountLabel.frame = CGRectMake(kMargin, kMargin + titleLabelHeight + kMargin, kSubScreenWidth, 20);
        }
    }
    else {
        self.blackTransparentView.frame = CGRectZero;
        self.titleLabel.textColor = [GCColor fontColor];
        self.timeLabel.textColor = [GCColor grayColor3];
        
        if (self.model.img.length > 0) {
            self.titleLabel.numberOfLines = 2;
            
            self.leftImageView.frame = CGRectMake(kMargin, kMargin, 80, 74);
            self.titleLabel.frame = CGRectMake(kMargin + 80 + 10, 17, kScreenWidth - kMargin - 80 - 20, 45);
            self.timeLabel.frame = CGRectMake(kMargin + 80 + 10, 62, kScreenWidth - kMargin - 80 - 20, 35);
            self.readCountLabel.frame = CGRectMake(kMargin + 80 + 10, 62, kSubScreenWidth - kMargin - 80, 35);
        }
        else {
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.preferredMaxLayoutWidth = kSubScreenWidth;
            
            CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:self.model.content fontSize:15 width:kSubScreenWidth];
            
            self.leftImageView.frame = CGRectZero;
            self.titleLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, titleLabelHeight);
            self.timeLabel.frame = CGRectMake(kMargin, kMargin + titleLabelHeight + 10, kSubScreenWidth, 20);
            self.readCountLabel.frame = CGRectMake(kMargin, kMargin + titleLabelHeight + kMargin, kSubScreenWidth, 20);
        }
    }
}

+ (CGFloat)getCellHeightWithModel:(GCNewsModulePostModel *)model index:(NSInteger)index {
    if (index == 0) {
        if (model.img.length > 0) {
            return kMargin + kScreenWidth * 0.5 + kMargin;
        }
        else {
            CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:model.content fontSize:15 width:kSubScreenWidth];
            return titleLabelHeight + 60;
        }
    }
    else {
        if (model.img.length > 0) {
            return 104;
        }
        else {
            CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:model.content fontSize:15 width:kSubScreenWidth];
            return titleLabelHeight + 60;
        }
    }
    
    return 100;
}

#pragma mark - Getters

- (UIView *)blackTransparentView {
    if (!_blackTransparentView) {
        _blackTransparentView = [[UIView alloc] init];
        _blackTransparentView.backgroundColor = [UIColor blackColor];
        _blackTransparentView.alpha = 0.6;
    }
    return _blackTransparentView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [GCColor grayColor3];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)readCountLabel {
    if (!_readCountLabel) {
        _readCountLabel = [[UILabel alloc] init];
        _readCountLabel.font = [UIFont systemFontOfSize:12];
        _readCountLabel.textColor = [GCColor grayColor3];
        _readCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _readCountLabel;
}

@end
