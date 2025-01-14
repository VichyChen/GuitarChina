//
//  GCNewsListCell.m
//  GuitarChina
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsListCell.h"

@implementation GCNewsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        self.clipsToBounds = YES;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

+ (CGFloat)getCellHeightWithModel:(GCNewsModel *)model {
    if (model.img.length > 0) {
        return 104;
    }
    else {
        CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:model.content fontSize:15 width:kScreenWidth - 26];
        return titleLabelHeight + 55;
    }
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.readCountLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)setModel:(GCNewsModel *)model {
    _model = model;
    
    self.titleLabel.text = model.content;
    self.timeLabel.text = model.time;
    self.readCountLabel.text = model.readCount;
    if (model.img.length > 0) {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:DefaultImage];
    }
    
    if (self.model.img.length > 0) {
        self.titleLabel.numberOfLines = 2;

        self.leftImageView.frame = CGRectMake(kMargin, kMargin, 80, 74);
        self.titleLabel.frame = CGRectMake(kMargin + 80 + 10, 17, kScreenWidth - 13 - 80 - 20, 45);
        self.timeLabel.frame = CGRectMake(kMargin + 80 + 10, 62, kScreenWidth - 13 - 80 - 20, 35);
        self.readCountLabel.frame = CGRectMake(kMargin + 80 + 10, 62, kScreenWidth - 13 - 80 - 26, 35);
    }
    else {
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.preferredMaxLayoutWidth = kSubScreenWidth;

        CGFloat titleLabelHeight = [UIView calculateLabelHeightWithText:self.model.content fontSize:15 width:kSubScreenWidth];
        
        self.leftImageView.frame = CGRectMake(0, 0, 0, 0);
        self.titleLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, titleLabelHeight);
        self.timeLabel.frame = CGRectMake(kMargin, 10 + titleLabelHeight + 10, kSubScreenWidth, 20);
        self.readCountLabel.frame = CGRectMake(kMargin, 10 + titleLabelHeight + 10, kScreenWidth - 29, 20);
    }

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
