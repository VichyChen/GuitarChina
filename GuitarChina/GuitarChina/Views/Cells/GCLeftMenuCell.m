//
//  GCLeftMenuCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLeftMenuCell.h"

@interface GCLeftMenuCell()


@end

@implementation GCLeftMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([Util getCurrentLanguageIsChinese]) {
        self.leftImageView.frame = CGRectMake(self.leftImageViewOffsetX - 15, 15, 20, 20);
    } else {
        self.leftImageView.frame = CGRectMake(self.leftImageViewOffsetX - 30, 15, 20, 20);
    }
    self.titleLabel.frame = CGRectMake(self.leftImageView.frame.origin.x + 40, 10, 100, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.backgroundColor = [UIColor backgroundColor];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.backgroundColor = [UIColor whiteColor];
        }];
    }
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
}

#pragma mark - Getters

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIView createImageView:CGRectZero
                                     contentMode:UIViewContentModeScaleAspectFit];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UIView createLabel:CGRectZero
                                     text:@""
                                     font:[UIFont systemFontOfSize:17]
                                textColor:[UIColor FontColor]];
    }
    return _titleLabel;
}

@end
